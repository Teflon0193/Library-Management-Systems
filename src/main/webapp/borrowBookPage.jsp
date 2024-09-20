<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Borrow Book</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 300px;
            max-width: 100%;
        }
        h1 {
            font-size: 24px;
            margin-bottom: 20px;
            text-align: center;
            color: #333;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        input[type="date"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-bottom: 16px;
            box-sizing: border-box;
        }
        button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 15px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
            border-radius: 4px;
            width: 100%;
        }
        button:hover {
            background-color: #45a049;
        }
        .return-button {
            background-color: #f44336;
        }
        .return-button:hover {
            background-color: #e53935;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Borrow Book</h1>
        <form action="userBook" method="post">
            <input type="hidden" name="action" value="borrow">
            <input type="hidden" name="bookId" value="<%= request.getParameter("bookId") %>">

            <label for="borrowDate">Borrow Date:</label>
            <input type="date" name="borrowDate" id="borrowDate" required>

            <label for="returnDate">Return Date:</label>
            <input type="date" name="returnDate" id="returnDate" required>

            <button type="submit"> Borrow </button>
             <button type="button" class="return-button" onclick="window.location.href='listBooks.jsp'">Retour</button>
        </form>
    </div>
</body>
</html>
