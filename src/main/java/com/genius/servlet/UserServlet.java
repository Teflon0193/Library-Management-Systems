package com.genius.servlet;

import com.genius.dao.UserDAO;
import com.genius.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/user")
public class UserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private Connection connection;

    @Override
    public void init() throws ServletException {
        connection = (Connection) getServletContext().getAttribute("DBConnection");
        if (connection == null) {
            throw new ServletException("Database connection not available.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String username = request.getParameter("username");
        UserDAO userDAO = new UserDAO((Connection) getServletContext().getAttribute("DBConnection"));

        try {
            if ("search".equals(action)) {
                // Search users by full name
                String searchTerm = request.getParameter("searchTerm");
                List<User> users = userDAO.searchUsersByFullName(searchTerm);
                request.setAttribute("users", users);
                request.getRequestDispatcher("/manageUsers.jsp").forward(request, response);

            } else {

                List<User> users = userDAO.getAllUsers();
                request.setAttribute("users", users);
                request.getRequestDispatcher("/manageUsers.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        UserDAO userDAO = new UserDAO((Connection) getServletContext().getAttribute("DBConnection"));

        try {
            if ("update".equals(action)) {
                // Update user details
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");

                User user = new User();
                user.setUsername(username);
                user.setPassword(password);
                user.setFullName(fullName);
                user.setEmail(email);

                userDAO.updateUser(user);
                response.sendRedirect("user?action=search");

            } else if ("create".equals(action)) {
                // Create a new user
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");

                User user = new User();
                user.setUsername(username);
                user.setPassword(password);
                user.setFullName(fullName);
                user.setEmail(email);

                userDAO.addUser(user);
                response.sendRedirect("user?action=search"); // Redirect to list users after creation
            }
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
