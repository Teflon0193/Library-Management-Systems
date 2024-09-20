<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.genius.model.Book" %>
<%@ page import="com.genius.dao.UserBookDAO" %>
<%@ page import="java.sql.Connection" %>

<%
    // Check if the user is logged in
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Book List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f9fc;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        h1 {
            margin-top: 20px;
        }
        table {
            border-collapse: collapse;
            width: 80%;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            margin: 10px;
            text-decoration: none;
        }
        button:hover {
            background-color: #0056b3;
        }
        .black-button {
            background-color: black;
            color: white;
        }
        .black-button:hover {
            background-color: #333;
        }
        .logout-container {
            width: 80%;
            display: flex;
            justify-content: flex-end;
            margin-top: 10px;
        }
        .logout-button {
            background-color: black;
            color: white;
            padding: 10px 15px;
            border: none;
            text-decoration: none;
            cursor: pointer;
        }
        .logout-button:hover {
            background-color: #333;
        }
        .actions-container {
            width: 80%;
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .actions-container a, .actions-container form {
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <h1>Liste des Livres</h1>

    <div class="actions-container">
        <form action="loanHistory.jsp" method="get">
            <button type="submit">Voir Mon History</button>
        </form>

        <div class="logout-container">
            <a href="userLogin.jsp" class="logout-button">Logout</a>
        </div>
    </div>

    <table>
        <tr>
            <th>Title</th>
            <th>Author</th>
            <th>ISBN</th>
            <th>Category</th>
            <th>Available Copies</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        <%
            Connection connection = (Connection) application.getAttribute("DBConnection");
            Integer userId = (Integer) session.getAttribute("userId"); // Using the implicit session variable

            if (connection != null && userId != null) {
                UserBookDAO userBookDAO = new UserBookDAO(connection);

                // Get the list of books and the list of borrowed books for the current user
                List<Book> books = userBookDAO.getAvailableBooks();
                Set<Integer> borrowedBooks = userBookDAO.getBorrowedBooksByUser(userId);

                for (Book book : books) {
                    boolean isBorrowed = borrowedBooks.contains(book.getId());
        %>
        <tr>
            <td><%= book.getTitle() %></td>
            <td><%= book.getAuthor() %></td>
            <td><%= book.getIsbn() %></td>
            <td><%= book.getCategory() %></td>
            <td><%= book.getAvailableCopies() %></td>
            <td><%= book.getStatus() %></td>
            <td>
                <% if ("disponible".equalsIgnoreCase(book.getStatus()) && !isBorrowed) { %>
                    <!-- Borrow button if the book is available and not already borrowed by the user -->
                    <form action="borrowBookPage.jsp" method="get" style="display: inline;">
                        <input type="hidden" name="bookId" value="<%= book.getId() %>">
                        <button type="submit">Borrow</button>
                    </form>
                <% } else if (isBorrowed) { %>
                    <!-- If the book is borrowed by the user, show renew and return options -->
                    <form action="renewLoan" method="post" style="display: inline;">
                        <input type="hidden" name="bookId" value="<%= book.getId() %>">
                        <button type="submit">Renew</button>
                    </form>

                   <form action="userBook" method="post" style="display: inline;">
                       <input type="hidden" name="action" value="return">
                       <input type="hidden" name="bookId" value="<%= book.getId() %>">
                       <button type="submit" class="black-button">Return</button>
                   </form>

                <% } %>
            </td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="7">Database connection or user session is not available.</td>
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>
