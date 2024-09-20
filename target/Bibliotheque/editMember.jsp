<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.genius.model.Member" %>
<%@ page import="com.genius.dao.MemberDAO" %>
<%@ page import="java.sql.SQLException" %>

<%
    // Fetch member ID from the request parameter
    String memberId = request.getParameter("id");
    if (memberId == null || memberId.trim().isEmpty()) {
        response.sendRedirect("manageMembers.jsp");
        return;
    }

    // Initialize the MemberDAO to retrieve member information
    MemberDAO memberDAO = new MemberDAO((java.sql.Connection) getServletContext().getAttribute("DBConnection"));
    Member member = null;
    try {
        member = memberDAO.getMemberById(Integer.parseInt(memberId));
    } catch (SQLException e) {
        request.setAttribute("errorMessage", "Error retrieving member: " + e.getMessage());
        request.getRequestDispatcher("error.jsp").forward(request, response);
        return;
    }

    // If no member is found with the given ID, redirect back to member list
    if (member == null) {
        response.sendRedirect("manageMembers.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifier Membre</title>
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
            width: 50%;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        form {
            display: flex;
            flex-direction: column;
        }
        input[type="text"] {
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .button-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        button {
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .cancel-button {
            display: inline-block;
            padding: 10px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            text-align: center;
        }
        .cancel-button:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>

    <div class="header">
        <h1>Modifier Membre</h1>
    </div>

    <div class="container">
        <form id="editMemberForm" method="post" action="manageMembers">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= member.getId() %>">

            <label for="name">Nom:</label>
            <input type="text" id="name" name="name" value="<%= member.getName() %>" required>

            <label for="cour">Classe:</label>
            <input type="text" id="cour" name="cour" value="<%= member.getCour() %>" required>

            <label for="memberNumber">Numéro Membre:</label>
            <input type="text" id="memberNumber" name="memberNumber" value="<%= member.getMemberNumber() %>" required>

            <div class="button-container">
                <button type="submit">Modifier</button>
                <a href="manageMembers.jsp" class="cancel-button">Annuler</a>
            </div>
        </form>
    </div>

</body>
</html>
