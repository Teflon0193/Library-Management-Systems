<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.genius.dao.LoanDAO" %>
<%@ page import="com.genius.model.Loan" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Accept Loan</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center; /* Center items vertically */
            height: 100vh; /* Full viewport height */
        }
        h2 {
            color: #343a40;
            text-align: center;
        }
        .button {
            background-color: #007bff; /* Blue */
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            display: block; /* Center the button */
            margin-bottom: 20px;
        }
        .button:hover {
            background-color: #0056b3;
        }
        form {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            width: 300px; /* Set a fixed width */
            text-align: center; /* Center the form content */
        }
        label {
            display: block;
            margin-bottom: 10px;
            font-weight: bold;
        }
        input[type="date"] {
            padding: 8px;
            margin-bottom: 20px;
            width: calc(100% - 16px);
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button[type="submit"],
        button[type="button"] {
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        button[type="submit"] {
            background-color: #007bff; /* Blue */
        }
        button[type="submit"]:hover {
            background-color: #0056b3;
        }
        button[type="button"] {
            background-color: #dc3545; /* Red */
        }
        button[type="button"]:hover {
            background-color: #c82333;
        }
    </style>

    <script>
        function hideButtons() {
            document.getElementById('acceptButton').style.display = 'none';
            document.getElementById('rejectButton').style.display = 'none';
        }

        function returnToManageLoans() {
            window.location.href = "manageLoans.jsp"; // Adjust this path if necessary
        }
    </script>
</head>
<body>

    <!-- Return button -->
    <button class="button" onclick="returnToManageLoans()">Retour à la Gestion des Prêts</button>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    LoanDAO loanDAO = new LoanDAO((java.sql.Connection) getServletContext().getAttribute("DBConnection"));
    Loan loan = loanDAO.getLoanById(id);

    if (loan != null) {
%>


    <form action="loan" method="post" onsubmit="hideButtons()">
        <input type="hidden" name="action" value="accept">
        <input type="hidden" name="id" value="<%= loan.getId() %>">
        <label for="dueDate">Choose Due Date:</label>
        <input type="date" id="dueDate" name="dueDate" required>
        <button type="submit" id="acceptButton">Accept</button>
        <button type="button" id="rejectButton" onclick="window.location='rejectLoan.jsp?id=<%= loan.getId() %>';">Reject</button>
    </form>
<%
    } else {
%>
    <p>Loan not found.</p>
<%
    }
%>

</body>
</html>
