<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ajouter Membre</title>
    <style>
        /* Add your CSS styles here */
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
        button, .cancel-button {
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
        }
        button {
            background-color: #007bff;
            color: white;
            border: none;
            margin-right: 10px;
        }
        button:hover {
            background-color: #0056b3;
        }
        .cancel-button {
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            display: inline-block;
        }
        .cancel-button:hover {
            background-color: #5a6268;
        }
        .button-container {
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
        }
    </style>

</head>
<body>

    <div class="header">
        <h1>Ajouter Nouveau Membre</h1>
    </div>

    <div class="container">
        <form id="addMemberForm" method="post" action="manageMembers">
            <input type="hidden" name="action" value="create">

            <label for="name">Nom:</label>
            <input type="text" id="name" name="name" required>

            <label for="cour">Classe:</label>
            <input type="text" id="cour" name="cour" required>

            <label for="memberNumber">Numéro Membre:</label>
            <input type="text" id="memberNumber" name="memberNumber" required>

            <div class="button-container">
                <button type="submit">Ajouter</button>
                <a href="manageMembers.jsp" class="cancel-button">Annuler</a>
            </div>
        </form>
    </div>

</body>
</html>
