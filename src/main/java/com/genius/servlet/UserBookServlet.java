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
import java.text.SimpleDateFormat;
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
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date currentDueDate = null;
        try {
            // Get userId and bookId from the session/request
            Integer userId = (Integer) request.getSession().getAttribute("userId");
            if (userId == null) {
                response.sendRedirect("userLogin.jsp?message=Please log in to renew the loan.");
                return;
            }

            int bookId = Integer.parseInt(request.getParameter("bookId"));
            // Initialize DAO and fetch active loan details
            UserBookDAO userBookDAO = new UserBookDAO(connection);
            Loan activeLoan = userBookDAO.getActiveLoanDetails(userId, bookId);

            System.out.println("Active Loan: " + activeLoan);

            if (activeLoan == null) {
                response.sendRedirect("listBooks.jsp?message=No active loan found for this book.");
                return;
            }

            // Set the current due date
            String currentDueDateString = (activeLoan.getDueDate() != null)
                    ? new SimpleDateFormat("yyyy-MM-dd").format(activeLoan.getDueDate())
                    : "N/A";
            request.setAttribute("currentDueDate", currentDueDateString);


            // If a new due date is provided (for actual renewal)
            String newDueDateStr = request.getParameter("newDueDate");
            if (newDueDateStr != null && !newDueDateStr.isEmpty()) {
                boolean updated = userBookDAO.updateLoanDueDate(userId, bookId, newDueDateStr);

                if (updated) {
                    response.sendRedirect("loanSuccess.jsp?message=Loan renewed successfully! New due date: " + newDueDateStr);
                } else {
                    String dueDateStr = dateFormat.format(currentDueDate);
                    response.sendRedirect("renewLoan.jsp?message=Failed to renew loan.");
                }
            } else {
                // If the new due date is not provided, simply show the renewal form with current due date
                request.getRequestDispatcher("renewLoan.jsp").forward(request, response);
            }
        } catch (NumberFormatException | SQLException e) {
            handleException(request, response, e);
        }
    }


    private void returnBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookId;

        try {
            bookId = Integer.parseInt(request.getParameter("bookId"));
            Integer userId = (Integer) request.getSession().getAttribute("userId");

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
            e.printStackTrace();
        } catch (SQLException e) {
            response.sendRedirect("listBooks.jsp?message=Database error occurred.");
            e.printStackTrace();
        } catch (Exception e) {
            response.sendRedirect("listBooks.jsp?message=Unexpected error occurred.");
            e.printStackTrace();
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
