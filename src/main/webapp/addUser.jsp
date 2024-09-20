<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add a New User</title>
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
            width: 80%;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        form {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }
        label {
            font-weight: bold;
            margin-top: 10px;
        }
        input, select {
            padding: 8px;
            margin: 5px 0 15px;
            width: 100%;
            max-width: 400px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 10px;
        }
        button:hover {
            background-color: #0056b3;
        }
        .button-container {
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
            width: 100%;
            max-width: 400px;
        }
        .button-container button {
            width: auto;
            padding: 10px 15px;
        }
        .error {
            color: red;
            text-align: center;
        }

    </style>
</head>
<body>

    <div class="header">
        <h1>Bibliotheque Management System</h1>
    </div>

    <div class="container">
        <h2>Ajouter Un Nouveau Utilisateur</h2>

        <form action="user" method="post">
            <input type="hidden" name="action" value="create">

            <div class="form-group">
                <label for="username">Nom d'utilisateur:</label>
                <input type="text" id="username" name="username" required>
            </div>

            <div class="form-group">
                <label for="password">Mot de passe:</label>
                <input type="password" id="password" name="password" required>
            </div>

            <div class="form-group">
                <label for="fullName">Nom complet:</label>
                <input type="text" id="fullName" name="fullName" required>
            </div>

            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>

            <div class="button-container">
                <button type="submit">Ajouter</button>
                <button type="button" onclick="window.location.href='manageUsers.jsp'">Retour à l accueil</button>
            </div>
        </form>

    </div>

</body>
</html>
