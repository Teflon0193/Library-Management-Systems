<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
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
        .header h1 {
            margin: 0;
        }
        .container {
            width: 80%;
            margin: 50px auto;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .button-group {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-top: 30px;
            width: 100%;
            justify-items: center;
        }
        .button {
            background-color: #007bff;
            color: white;
            padding: 15px 20px;
            text-decoration: none;
            border-radius: 5px;
            text-align: center;
            width: 200px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.3s ease;
        }
        .button:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }
        .welcome-message {
            margin-top: 10px;
            font-size: 18px;
        }
        .button-logout {
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <div class="header">
        <h1>Admin Tableau de Bord</h1>
        <p class="welcome-message">Bienvenue, <%= session.getAttribute("admin") %></p>
        <a href="logout.jsp" class="button button-logout">Logout</a>
    </div>

    <div class="container">
        <h2>Gérer le Système</h2>
        <div class="button-group">
            <a href="index.jsp" class="button">Gérer Les Livres</a>
            <a href="manageMembers.jsp" class="button">Gérer Les Membres</a>
            <a href="manageLoans.jsp" class="button">Gérer Les Prêts</a>
        </div>
    </div>

</body>
</html>
