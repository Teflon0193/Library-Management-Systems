<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.genius.model.Member" %>
<%@ page import="com.genius.dao.MemberDAO" %>
<%@ page import="java.sql.SQLException" %>

<%
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    MemberDAO memberDAO = new MemberDAO((java.sql.Connection) getServletContext().getAttribute("DBConnection"));
    List<Member> members = null;

    // Retrieve search term if provided
    String searchTerm = request.getParameter("searchTerm");

    try {
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            members = memberDAO.searchMembers(searchTerm);
        } else {
            members = memberDAO.getAllMembers();
        }
    } catch (SQLException e) {
        request.setAttribute("errorMessage", "Error retrieving members: " + e.getMessage());
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
        .header {
            background-color: #343a40;
            color: white;
            padding: 20px;
            text-align: center;
        }
        .container {
            margin: 50px auto;
            width: 80%;
        }
        .search-bar {
            margin-bottom: 20px;
        }
        .search-bar input[type="text"] {
            padding: 10px;
            width: 300px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .search-bar button {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .search-bar button:hover {
            background-color: #0056b3;
        }
        .return-button {
            display: inline-block;
            margin: 10px 0;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .return-button:hover {
            background-color: #0056b3;
        }
        .add-button {
            display: inline-block;
            margin: 10px 0;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            float: right; /* Align to the right */
        }
        .add-button:hover {
            background-color: #0056b3;
        }
        table {
            width: 100%;
            margin: 20px 0;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        td {
            background-color: white;
        }
        .delete-button {
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 3px;
            background-color: #000; /* Black background */
            color: white;
        }
        .delete-button:hover {
            background-color: #333; /* Darker black on hover */
        }
        .edit-button {
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 3px;
            background-color: #007bff; /* Blue color */
            color: white;
        }
        .edit-button:hover {
            background-color: #0056b3; /* Darker Blue on hover */
        }
    </style>
</head>
<body>

    <div class="header">
        <h1>Gérer Les Membres</h1>
    </div>

    <div class="container">
        <h2>Liste des Membres</h2>

        <!-- Search Form -->
        <div class="search-bar">
            <form action="manageMembers.jsp" method="get">
                <input type="text" name="searchTerm" placeholder="Rechercher par nom" value="<%= searchTerm != null ? searchTerm : "" %>">
                <button type="submit">Rechercher</button>
            </form>
        </div>

        <a href="addMember.jsp" class="add-button">Ajouter un Membre</a>
        <a href="dashboard.jsp" class="return-button">Retour au Tableau de Bord</a>

        <table>
            <thead>
                <tr>
                    <!-- Hidden ID column -->
                    <th style="display:none;">ID</th>
                    <th>Nom</th>
                    <th>Classe</th>
                    <th>Numéro Membre</th>
                    <th>Modifier</th>
                    <th>Supprimer</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (members != null && !members.isEmpty()) {
                        for (Member member : members) {
                %>
                            <tr>
                                <!-- Hidden ID data -->
                                <td style="display:none;"><%= member.getId() %></td>
                                <td><%= member.getName() %></td>
                                <td><%= member.getCour() %></td>
                                <td><%= member.getMemberNumber() %></td>
                                <td>
                                    <a href="editMember.jsp?id=<%= member.getId() %>" class="edit-button">Modifier</a>
                                </td>
                                <td>
                                    <a href="manageMembers?action=delete&id=<%= member.getId() %>" class="delete-button" onclick="return confirm('Are you sure you want to delete this member?');">Supprimer</a>
                                </td>
                            </tr>
                <%
                        }
                    } else {
                %>
                        <tr>
                            <td colspan="6">Aucun membre trouvé.</td>
                        </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

</body>
</html>
