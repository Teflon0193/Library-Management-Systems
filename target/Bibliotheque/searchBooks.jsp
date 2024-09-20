<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Search Books</title>
</head>
<body>
    <h1>Search Books</h1>
    <form action="searchBooks" method="get">
        <label for="title">Book Title:</label>
        <input type="text" id="title" name="title"><br>

        <label for="author">Author:</label>
        <input type="text" id="author" name="author"><br>

        <label for="isbn">ISBN:</label>
        <input type="text" id="isbn" name="isbn"><br>

        <label for="category">Category:</label>
        <input type="text" id="category" name="category"><br>

        <button type="submit">Search</button>
    </form>

    <p><a href="index.jsp">Back to Home</a></p>

    <h2>Search Results</h2>
    <!-- This section can display the search results -->
    <c:if test="${!empty bookList}">
        <table border="1">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Author</th>
                    <th>ISBN</th>
                    <th>Category</th>
                    <th>Available Copies</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="book" items="${bookList}">
                    <tr>
                        <td>${book.title}</td>
                        <td>${book.author}</td>
                        <td>${book.isbn}</td>
                        <td>${book.category}</td>
                        <td>${book.availableCopies}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
</body>
</html>
