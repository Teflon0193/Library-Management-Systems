package com.genius.servlet;

import com.genius.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/userLogin")
public class UserLoginServlet extends HttpServlet {
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO(connection);

        try {
            boolean isAuthenticated = userDAO.authenticate(username, password);

            if (isAuthenticated) {
                // Fetch userId and store it in the session
                int userId = userDAO.getUserIdByUsername(username); // Assume this method exists in your UserDAO
                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);  // Set userId in session
                session.setAttribute("username", username);  // Optionally, set username
                response.sendRedirect("listBooks.jsp");  // Redirect to the user book list
            } else {
                response.sendRedirect("userLogin.jsp?error=invalid"); // Redirect back to login page with error
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred during login.");
            request.getRequestDispatcher("userLogin.jsp").forward(request, response);
        }
    }


    @Override
    public void destroy() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
