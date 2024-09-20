<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.genius.model.Loan" %>
<%@ page import="com.genius.dao.LoanDAO" %>
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
        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .table-header h2 {
            margin: 0 auto;
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
         .accept-button, .reject-button, .due-date-button {
                   padding: 5px 10px;
                   text-decoration: none;
                   border-radius: 3px;
                   color: white;
                   border: none;
                   cursor: pointer;
               }
        .accept-button {
            background-color: #28a745; /* Green color */
        }
        .accept-button:hover {
            background-color: #218838;
        }
        .reject-button {
            background-color: #dc3545; /* Red color */
        }
        .reject-button:hover {
            background-color: #c82333;
        }

         .due-date-button {
                    background-color: #007bff; /* Blue color */
                }
                .due-date-button:hover {
                    background-color: #0056b3;
                }
        .hidden {
            display: none;
        }

        .return-button {
            background-color: #6c757d; /* Gray */
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            margin-top: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .return-button:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
        }

    </style>
</head>
<body>

    <div class="header">
        <h1>Bibliotheque Management System</h1>
    </div>

    <div class="container">
        <div class="table-header">
            <a href="dashboard.jsp" class="return-button">Retour au Tableau de Bord</a>
            <h2>Liste Des Prêts</h2>
        </div>

        <table>
            <thead>
                <tr>
                    <th class="hidden">ID</th>
                    <th>Book ID</th>
                    <th>User ID</th>
                    <th>Date d'Emprunt</th>
                    <th>Date de Retour</th>
                    <th>Date Limite</th>
                    <th>Pénalité</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    LoanDAO loanDAO = new LoanDAO((java.sql.Connection) getServletContext().getAttribute("DBConnection"));
                    List<Loan> loans = loanDAO.getAllLoans();

                    if (loans != null && !loans.isEmpty()) {
                        for (Loan loan : loans) {
                %>
                            <tr>
                                <td class="hidden"><%= loan.getId() %></td>
                                <td><%= loan.getBookId() %></td>
                                <td><%= loan.getUserId() %></td>
                                <td><%= loan.getBorrowDate() %></td>
                                <td><%= loan.getReturnDate() != null ? loan.getReturnDate() : "N/A" %></td>
                                <td><%= loan.getDueDate() != null ? loan.getDueDate() : "N/A" %></td>
                                <td><%= loan.getPenalty() %></td>
                                <td><%= loan.getStatus() %></td>
                                <td>
                                   <%
                                       String status = loan.getStatus().trim(); // Trim any whitespace
                                   %>
                                   <% if ("Pending".equals(status)) { %>
                                       <span>Aucune action disponible</span> <!-- Optional for other statuses -->
                                   <% } else if ("Accepted".equals(status)) { %>
                                       <span>Demande acceptée</span>
                                   <% } else if ("Rejected".equals(status)) { %>
                                       <span>Demande rejetée</span>
                                   <% } else { %>
                                      <a href="acceptLoan.jsp?id=<%= loan.getId() %>" class="action-button accept-button">Accepter</a>
                                      <a href="rejectLoan.jsp?id=<%= loan.getId() %>" class="action-button reject-button">Rejeter</a>
                                   <% } %>
                                </td>

                            </tr>
                <%
                        }
                    } else {
                %>
                        <tr>
                            <td colspan="9">Aucun prêt trouvé.</td>
                        </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <!-- Example JavaScript for opening a popup to add the due date -->
    <script>
          function openDueDatePopup(id) {
                   var dueDate = prompt("Enter the due date (YYYY-MM-DD):");
                   if (dueDate) {
                       window.location.href = "acceptLoan.jsp?id=" + id + "&dueDate=" + dueDate;
                   }
               }

               function rejectLoan(id) {
                   if (confirm("Are you sure you want to reject this loan?")) {
                       window.location.href = `rejectLoan.jsp?id=${id}`;
                   }
               }


    </script>

</body>
</html>
