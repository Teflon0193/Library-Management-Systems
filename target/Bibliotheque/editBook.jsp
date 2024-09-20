<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.genius.model.Book" %>
<%@ page import="com.genius.dao.BookDAO" %>
<%@ page import="java.sql.Connection" %>
<%
    // Get the book ID from the request parameter
    String bookId = request.getParameter("id");
    BookDAO bookDAO = new BookDAO((Connection) getServletContext().getAttribute("DBConnection"));
    Book book = bookDAO.getBookById(Integer.parseInt(bookId));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bibliotheque Management System</title>
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
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        form {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }
        label {
            font-weight: bold;
            margin-top: 10px;
        }
        input {
            padding: 8px;
            margin: 5px 0 15px;
            width: 100%;
            max-width: 400px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .back-link {
            margin-top: 20px;
        }
        .back-link a {
            color: #007bff;
            text-decoration: none;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="header">
        <h1>Bibliotheque Management System</h1>
    </div>

    <div class="container">
        <h2>Modifier les détails du livre</h2>

        <form action="${pageContext.request.contextPath}/book" method="post">
            <input type="hidden" name="action" value="update"> <!-- Pass action as 'update' -->
            <input type="hidden" name="id" value="<%= book.getId() %>">

            <label for="title">Titres:</label>
            <input type="text" id="title" name="title" value="<%= book.getTitle() %>" required>

            <label for="author">Auteurs:</label>
            <input type="text" id="author" name="author" value="<%= book.getAuthor() %>" required>

            <label for="isbn">ISBN:</label>
            <input type="text" id="isbn" name="isbn" value="<%= book.getIsbn() %>" required>

            <label for="category">Categories:</label>
            <input type="text" id="category" name="category" value="<%= book.getCategory() %>" required>

            <label for="availableCopies">Copies Disponibles:</label>
            <input type="number" id="availableCopies" name="availableCopies" value="<%= book.getAvailableCopies() %>" required>

            <label for="status">Status:</label>
            <input type="text" id="status" name="status" value="<%= book.getStatus() %>" required>

            <button type="submit">Modifier</button>
        </form>

        <div class="back-link">
            <p><a href="index.jsp">Retour à l accueil</a></p>
        </div>
    </div>

</body>
</html>
