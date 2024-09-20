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

@WebServlet("/userRegister")
public class UserRegisterServlet extends HttpServlet {

    private Connection connection;

    @Override
    public void init() throws ServletException {
        // Get the DB connection from the servlet context
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
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setFullName(fullName);
        user.setEmail(email);

        try {
            UserDAO userDAO = new UserDAO(connection);
            userDAO.registerUser(user);
            response.sendRedirect("userLogin.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            request.getRequestDispatcher("userRegister.jsp").forward(request, response);
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