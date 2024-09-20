<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://xmlns.jcp.org/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="com.genius.dao.BookDAO" %>
<%@ page import="com.genius.dao.MemberDAO" %>
<%@ page import="com.genius.model.Book" %>
<%@ page import="com.genius.model.Member" %>

<%
    // You should have the connection set as an attribute in your servlet context
    Connection connection = (Connection) application.getAttribute("DBConnection");

    // Initialize DAOs
    BookDAO bookDAO = new BookDAO(connection);
    MemberDAO memberDAO = new MemberDAO(connection);

    // Fetch list of books and members to display in dropdowns
    List<Book> books = bookDAO.getAllBooks();
    List<Member> members = memberDAO.getAllMembers();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Loan</title>
    <link rel="stylesheet" href="styles.css"> <!-- Add your custom styles -->
</head>
<body>
    <div class="container">
        <h2>Create New Loan</h2>

        <form action="loan" method="post">
            <input type="hidden" name="action" value="create">

            <div class="form-group">
                <label for="bookId">Book Title:</label>
                <select name="bookId" id="bookId" required>
                    <option value="">Select Book</option>
                    <c:forEach var="book" items="<%= books %>">
                        <option value="${book.id}">${book.title}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="memberId">Member Name:</label>
                <select name="memberId" id="memberId" required>
                    <option value="">Select Member</option>
                    <c:forEach var="member" items="<%= members %>">
                        <option value="${member.id}">${member.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="dueDate">Due Date:</label>
                <input type="date" name="dueDate" id="dueDate" required>
            </div>

            <button type="submit" class="btn">Create Loan</button>
        </form>
    </div>
</body>
</html>
