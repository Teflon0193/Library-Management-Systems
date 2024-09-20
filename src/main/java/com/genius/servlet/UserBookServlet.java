package com.genius.servlet;

import com.genius.model.Book;
import com.genius.dao.UserBookDAO;
import com.genius.model.Loan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

@WebServlet("/userBook")
public class UserBookServlet extends HttpServlet {

    private Connection connection;

    @Override
    public void init() throws ServletException {
        connection = (Connection) getServletContext().getAttribute("DBConnection");
        if (connection == null) {
            throw new ServletException("Database connection not available.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            throw new ServletException("Action parameter is missing.");
        }

        switch (action) {
            case "borrow":
                borrowBook(request, response);
                break;
            case "renew":
                renewLoan(request, response);
                break;
            case "return":
                returnBook(request, response);
                break;
            case "viewHistory":
                viewLoanHistory(request, response);
                break;
            default:
                throw new ServletException("Invalid action.");
        }
    }

    private void listAvailableBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            UserBookDAO userBookDAO = new UserBookDAO(connection);
            List<Book> books = userBookDAO.getAvailableBooks();

            request.setAttribute("books", books);
            request.getRequestDispatcher("listBooks.jsp").forward(request, response);
        } catch (SQLException e) {
            handleException(request, response, e);
        }
    }

    private void borrowBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));

            UserBookDAO userBookDAO = new UserBookDAO(connection);

            // Check if the user already has an active loan for the book
            if (userBookDAO.hasActiveLoan(userId, bookId)) {
                response.sendRedirect("listBooks.jsp?message=You already have this book borrowed.");
                return;
            }

            String borrowDateStr = request.getParameter("borrowDate");
            String returnDateStr = request.getParameter("returnDate");

            java.sql.Date borrowDate = java.sql.Date.valueOf(borrowDateStr);
            java.sql.Date returnDate = java.sql.Date.valueOf(returnDateStr);

            boolean success = userBookDAO.borrowBook(userId, bookId, borrowDate, returnDate);

            if (success) {
                // Redirect to success page
                response.sendRedirect("borrowsuccess.jsp?message=Book borrowed successfully&returnPage=listBooks.jsp");
            } else {
                response.sendRedirect("listBooks.jsp?message=Failed to borrow book");
            }
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Error borrowing book: " + e.getMessage(), e);
        }
    }


    private void renewLoan(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            int userId = (Integer) request.getSession().getAttribute("userId");

            UserBookDAO userBookDAO = new UserBookDAO(connection);
            userBookDAO.renewLoan(userId, bookId);

            response.sendRedirect("success.jsp");
        } catch (NumberFormatException | SQLException e) {
            handleException(request, response, e);
        }
    }

    private void returnBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookId;

        try {
            // Parse the book ID from the request
            bookId = Integer.parseInt(request.getParameter("bookId"));
            Integer userId = (Integer) request.getSession().getAttribute("userId"); // Use Integer to allow null

            if (userId == null) {
                response.sendRedirect("userLogin.jsp?message=Please log in to return a book");
                return;
            }

            UserBookDAO userBookDAO = new UserBookDAO(connection);
            boolean success = userBookDAO.returnBook(userId, bookId);

            if (success) {
                // Increase available copies after successful return
                userBookDAO.increaseAvailableCopies(bookId); // Ensure this method is implemented correctly
                response.sendRedirect("returnSuccess.jsp?message=Book returned successfully");
            } else {
                response.sendRedirect("listBooks.jsp?message=Failed to return book: Book might not be borrowed.");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("listBooks.jsp?message=Invalid book ID format.");
            e.printStackTrace(); // Log the exception for debugging
        } catch (SQLException e) {
            response.sendRedirect("listBooks.jsp?message=Database error occurred.");
            e.printStackTrace(); // Log the exception for debugging
        } catch (Exception e) {
            response.sendRedirect("listBooks.jsp?message=Unexpected error occurred.");
            e.printStackTrace(); // Log the exception for debugging
        }
    }



    private void viewLoanHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int memberId = (Integer) request.getSession().getAttribute("memberId");

            UserBookDAO userBookDAO = new UserBookDAO(connection);
            List<Loan> loanHistory = userBookDAO.getLoanHistory(memberId);

            request.setAttribute("loanHistory", loanHistory);
            request.getRequestDispatcher("loanHistory.jsp").forward(request, response);
        } catch (SQLException e) {
            handleException(request, response, e);
        }
    }

    private void handleException(HttpServletRequest request, HttpServletResponse response, Exception e)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", "Error: " + e.getMessage());
        request.getRequestDispatcher("error.jsp").forward(request, response);
    }

    @Override
    public void destroy() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
