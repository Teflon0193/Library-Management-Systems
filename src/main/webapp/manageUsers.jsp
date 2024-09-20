<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
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
    List<User> users = null;

    // Retrieve search term if provided
    String searchTerm = request.getParameter("searchTerm");

    try {
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            users = userDAO.searchUsersByFullName(searchTerm);
        } else {
            users = userDAO.getAllUsers(); // Retrieve all users if no search term is provided
        }
    } catch (SQLException e) {
        request.setAttribute("errorMessage", "Error retrieving users: " + e.getMessage());
        request.getRequestDispatcher("error.jsp").forward(request, response);
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gérer Les Membres</title>
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

        form {
            margin: 20px;
            display: flex;
            justify-content: center;
        }

        input[type="text"] {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 200px;
            margin-right: 10px;
        }

        button, .add-button, .return-button {
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            color: white;
            border: none;
            cursor: pointer;
            text-align: center;
            font-size: 14px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        button {
            background-color: #007bff;
        }

        button:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }

        .add-button {
            background-color:#007bff;
        }

        .add-button:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }

        .return-button {
            background-color: #6c757d;
        }

        .return-button:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
        }

        .container {
            width: 80%;
            margin: 30px auto;
            position: relative;
        }

        .button-container {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f8f9fa;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .edit-button {
            background-color: #007bff;
            padding: 5px 10px;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }

        .edit-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>

<body>
    <h1>Admin - Bibliotheque Management System</h1>
    <form action="manageUsers.jsp" method="get">
        <input type="text" name="searchTerm" placeholder="Recherche par full name" value="<%= searchTerm != null ? searchTerm : "" %>">
        <button type="submit">Recherche</button>
    </form>

    <div class="container">
        <div class="button-container">
            <a href="addUser.jsp" class="add-button">Ajouter Un Membre</a>
            <a href="dashboard.jsp" class="return-button">Retour au Tableau de Bord</a>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (users != null && !users.isEmpty()) {
                        for (User user : users) {
                %>
                    <tr>
                        <td><%= user.getUsername() %></td>
                        <td><%= user.getFullName() %></td>
                        <td><%= user.getEmail() %></td>
                        <td>
                            <a href="editUser.jsp?username=<%= user.getUsername() %>" class="edit-button">Modifier</a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="4">No users found.</td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
