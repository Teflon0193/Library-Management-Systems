<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.genius.dao.UserBookDAO" %>
<%
    // Check if the user is logged in
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }

    Integer userId = (Integer) session.getAttribute("userId");
    Integer bookId = Integer.parseInt(request.getParameter("bookId"));

    // Get current due date passed from the servlet
    Date currentDueDate = (Date) request.getAttribute("currentDueDate");

    // Format the due date
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String formattedDueDate = (currentDueDate != null) ? dateFormat.format(currentDueDate) : "N/A";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Renew Loan</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f9fc;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0; /* Remove default margin */
        }
        h1 {
            color: #28a745; /* Green color */
        }
        label {
            margin-right: 10px;
        }
        input[type="date"] {
            padding: 5px;
            font-size: 16px;
        }
        button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        a {
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>Renew Loan</h1>
    <p>Current Due Date: <%= formattedDueDate %></p> <!-- Display the current due date -->

    <form action="userBook" method="post">
        <input type="hidden" name="action" value="renew">
        <input type="hidden" name="bookId" value="<%= bookId %>"> <!-- Use the local variable -->
        <label for="newDueDate">New Due Date:</label>
        <input type="date" name="newDueDate" required>
        <button type="submit">Renew</button>
    </form>
    <a href="listBooks.jsp" class="back-link">Back to Book List</a>
</body>
</html>
