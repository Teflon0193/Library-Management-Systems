<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.genius.model.Book" %>
<%@ page import="com.genius.dao.BookDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Bibliotheque Management System</title>
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
        .header .button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            margin-top: 10px;
        }
        .header .button:hover {
            background-color: #0056b3;
        }
        .container {
            margin: 50px auto;
            width: 80%;
        }
        .button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            margin: 10px 0;
            border-radius: 5px;
            display: inline-block;
        }
        .button:hover {
            background-color: #0056b3;
        }
        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .table-header h2 {
            margin: 0 auto; /* Center the heading */
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
        .edit-button, .delete-button {
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 3px;
            color: white;
        }
        .edit-button {
                   background-color: #007bff; /* Blue color */
               }
               .edit-button:hover {
                   background-color: #0056b3; /* Darker blue */
               }
               .delete-button {
                   background-color: #000000; /* Black color */
               }
               .delete-button:hover {
                   background-color: #333333; /* Darker black */
               }
        /* Hiding the ID column */
        .hidden {
            display: none;
        }
    </style>
</head>
<body>

    <div class="header">
        <h1>Bibliotheque Management System</h1>
    </div>

    <div class="container">
        <!-- Header with button on the left and title in the center -->
        <div class="table-header">
            <a href="dashboard.jsp" class="button">Retour au Tableau de Bord</a>
            <h2>Liste Des Livres</h2>
             <a href="addBook.jsp" class="button">Ajouter un livre</a>
        </div>

        <table>
            <thead>
                <tr>
                    <!-- Removed ID from the table headers -->
                    <th>Titres</th>
                    <th>Auteurs</th>
                    <th>ISBN</th>
                    <th>Categories</th>
                    <th>Copies Disponibles</th>
                    <th>Status</th>
                    <th>Modifier</th>
                    <th>Supprimer</th> <!-- New Delete Column -->
                </tr>
            </thead>
            <tbody>
                <%
                    BookDAO bookDAO = new BookDAO((java.sql.Connection) getServletContext().getAttribute("DBConnection"));
                    List<Book> books = bookDAO.getAllBooks();

                    if (books != null && !books.isEmpty()) {
                        for (Book book : books) {
                %>
                            <tr>
                                <!-- Store the ID in a hidden form field instead of displaying it -->
                                <td class="hidden"><%= book.getId() %></td>
                                <td><%= book.getTitle() %></td>
                                <td><%= book.getAuthor() %></td>
                                <td><%= book.getIsbn() %></td>
                                <td><%= book.getCategory() %></td>
                                <td><%= book.getAvailableCopies() %></td>
                                <td><%= book.getStatus() %></td>
                                <td>
                                    <a href="editBook.jsp?id=<%= book.getId() %>" class="edit-button">Modifier</a>
                                </td>
                                <td>
                                    <a href="book?action=delete&id=<%= book.getId() %>" class="delete-button" onclick="return confirm('Are you sure you want to delete this book?');">Supprimer</a> <!-- Delete Button -->
                                </td>
                            </tr>
                <%
                        }
                    } else {
                %>
                        <tr>
                            <td colspan="8">Aucun livre trouvé.</td>
                        </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

</body>
</html>
