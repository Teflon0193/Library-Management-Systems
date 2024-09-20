<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.genius.model.User" %>
<%@ page import="com.genius.dao.UserDAO" %>
<%@ page import="java.sql.SQLException" %>

<%
    // Ensure the user is an admin
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get the UserDAO instance
    UserDAO userDAO = new UserDAO((java.sql.Connection) getServletContext().getAttribute("DBConnection"));
    User user = null;
    String username = request.getParameter("username");

    if (username != null) {
        try {
            user = userDAO.getUserByUsername(username);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error retrieving user: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
    } else {
        response.sendRedirect("manageUsers.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifier User</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
        }

        h1 {
            background-color: #343a40;
            color: white;
            padding: 20px;
            margin: 0;
            text-align: center;
        }

        .container {
            width: 80%;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        form {
            width: 100%;
            display: flex;
            flex-direction: column;
        }

        label {
            margin-bottom: 10px;
            font-size: 14px;
            font-weight: bold;
        }

        input[type="text"], input[type="password"] {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-bottom: 20px;
            width: 100%;
        }

        button, .return-button {
            display: inline-block;
            padding: 15px 20px;
            margin: 10px;
            border-radius: 4px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border: none;
            cursor: pointer;
            text-align: center;
            font-size: 14px;
            width: 200px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        button:hover, .return-button:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }
        .return-button {
            background-color: #6c757d;
        }

        .return-button:hover {
            background-color: #5a6268;
        }

        .edit-button {
            background-color: #007bff;
        }

        .edit-button:hover {
            background-color: #0056b3;
        }
        .button-container {
            display: flex;
            justify-content: space-between; /* Aligns buttons to the edges */
            margin-top: 20px; /* Space between form fields and buttons */
        }
    </style>
</head>
<body>
    <h1>Admin Modifier User</h1>
    <div class="container">
        <form action="user" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="username" value="<%= user.getUsername() %>">

            <label for="username">Username</label>
            <input type="text" id="username" name="username" value="<%= user.getUsername() %>" readonly>

            <label for="password">Password</label>
            <input type="password" id="password" name="password" value="<%= user.getPassword() %>">

            <label for="fullName">Full Name</label>
            <input type="text" id="fullName" name="fullName" value="<%= user.getFullName() %>">

            <label for="email">Email</label>
            <input type="text" id="email" name="email" value="<%= user.getEmail() %>">


             <div class="button-container">
                 <button type="submit">Modifier</button>
                 <a href="manageUsers.jsp" class="return-button">Retour</a>
             </div>
        </form>


    </div>
</body>
</html>
