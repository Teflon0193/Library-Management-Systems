package com.genius.servlet;

import com.genius.dao.BookDAO;
import com.genius.model.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/book")  // Handles add, update, and delete operations
public class BookServlet extends HttpServlet {

    private Connection connection;

    @Override
    public void init() throws ServletException {
        connection = (Connection) getServletContext().getAttribute("DBConnection");
        if (connection == null) {
            throw new ServletException("Database connection not available.");
        }
    }

    // Handle POST requests for adding and updating books
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            throw new ServletException("Action parameter is missing.");
        }

        switch (action) {
            case "add":
                addBook(request, response);
                break;
            case "update":
                updateBook(request, response);
                break;
            default:
                throw new ServletException("Invalid action for POST request.");
        }
    }

    // Handle GET requests for deleting a book
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            deleteBook(request, response);
        } else {
            throw new ServletException("Invalid action for GET request.");
        }
    }

    private void addBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Retrieve book details from the request
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String isbn = request.getParameter("isbn");
            String category = request.getParameter("category");
            String availableCopiesStr = request.getParameter("availableCopies");
            String status = request.getParameter("status");

            if (title == null || author == null || isbn == null || category == null || availableCopiesStr == null || status == null) {
                throw new ServletException("All form fields are required.");
            }

            int availableCopies = Integer.parseInt(availableCopiesStr);

            // Create a new Book object
            Book book = new Book();
            book.setTitle(title);
            book.setAuthor(author);
            book.setIsbn(isbn);
            book.setCategory(category);
            book.setAvailableCopies(availableCopies);
            book.setStatus(status);

            // Save the book using BookDAO
            BookDAO bookDAO = new BookDAO(connection);
            bookDAO.addBook(book);

            // Redirect to success page
            response.sendRedirect("addBookSuccess.jsp");
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void updateBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Retrieve book details and ID from the request
            String idStr = request.getParameter("id");
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String isbn = request.getParameter("isbn");
            String category = request.getParameter("category");
            String availableCopiesStr = request.getParameter("availableCopies");
            String status = request.getParameter("status");

            if (idStr == null || title == null || author == null || isbn == null || category == null || availableCopiesStr == null || status == null) {
                throw new ServletException("All form fields are required.");
            }

            int id = Integer.parseInt(idStr);
            int availableCopies = Integer.parseInt(availableCopiesStr);

            // Create a Book object with updated values
            Book book = new Book();
            book.setId(id);
            book.setTitle(title);
            book.setAuthor(author);
            book.setIsbn(isbn);
            book.setCategory(category);
            book.setAvailableCopies(availableCopies);
            book.setStatus(status);

            // Update the book in the database
            BookDAO bookDAO = new BookDAO(connection);
            bookDAO.updateBook(book);

            // Redirect to success page or back to book list
            response.sendRedirect("index.jsp");
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void deleteBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Retrieve the book ID from the request
            String idStr = request.getParameter("id");

            if (idStr == null) {
                throw new ServletException("Book ID is required.");
            }

            int id = Integer.parseInt(idStr);

            // Delete the book from the database
            BookDAO bookDAO = new BookDAO(connection);
            bookDAO.deleteBook(id);

            // Redirect to the book list page
            response.sendRedirect("index.jsp");
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
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
