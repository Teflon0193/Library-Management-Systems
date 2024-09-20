<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.genius.model.Loan" %>
<%@ page import="com.genius.dao.LoanDAO" %>
<%@ page import="java.sql.SQLException" %>

<%
    // Ensure the session is valid for admin access
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    LoanDAO loanDAO = new LoanDAO((java.sql.Connection) getServletContext().getAttribute("DBConnection"));
    List<Loan> loans = null;

    try {
        loans = loanDAO.getAllLoans(); // Method to retrieve all loans
    } catch (SQLException e) {
        request.setAttribute("errorMessage", "Error retrieving loans: " + e.getMessage());
        request.getRequestDispatcher("error.jsp").forward(request, response);
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Loans</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .header {
            background-color: #333;
            color: #fff;
            padding: 15px;
            text-align: center;
        }

        .container {
            padding: 20px;
        }

        .nav-buttons {
            margin-bottom: 20px;
        }

        .nav-button {
            display: inline-block;
            margin-right: 10px;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
        }

        .nav-button:hover {
            background-color: #0056b3;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        table th, table td {
            border: 1px solid #ddd;
            padding: 10px;
        }

        table th {
            background-color: #f2f2f2;
            text-align: left;
        }

        .action-button {
            display: inline-block;
            padding: 5px 10px;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
        }

        .renew-button {
            background-color: #28a745;
        }

        .renew-button:hover {
            background-color: #218838;
        }

        .return-button {
            background-color: #dc3545;
        }

        .return-button:hover {
            background-color: #c82333;
        }

        .error-message {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <div class="header">
        <h1>Manage Loans</h1>
    </div>

    <div class="container">
        <div class="nav-buttons">
            <a href="dashboard.jsp" class="nav-button">Back to Dashboard</a>
            <a href="createLoan.jsp" class="nav-button">Create New Loan</a>
        </div>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Member Name</th>
                    <th>Borrow Date</th>
                    <th>Due Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (loans != null && !loans.isEmpty()) {
                        for (Loan loan : loans) {
                %>
                            <tr>
                                <td><%= loan.getId() %></td>
                                <td><%= loan.getTitle() %></td>
                                <td><%= loan.getMemberName() %></td>
                                <td><%= loan.getBorrowDate() %></td>
                                <td><%= loan.getDueDate() %></td>
                                <td><%= loan.getStatus() %></td>
                                <td>
                                    <a href="loan?action=renew&loanId=<%= loan.getId() %>" class="action-button renew-button">Renew</a>
                                    <a href="loan?action=return&loanId=<%= loan.getId() %>&penalty=0" class="action-button return-button">Return</a>
                                </td>
                            </tr>
                <%
                        }
                    } else {
                %>
                        <tr>
                            <td colspan="7">No loans found.</td>
                        </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

</body>
</html>
