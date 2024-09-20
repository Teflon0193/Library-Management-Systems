<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Success</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f9fc;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }
        h1 {
            color: #28a745; /* Green color */
        }
        .message {
            font-size: 20px;
            margin-bottom: 20px;
        }
        .button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }
        .button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h1>Success</h1>
    <div class="message">
        <%= request.getParameter("message") %>
    </div>
    <a href="listBooks.jsp" class="button">Go Back to Book List</a>
</body>
</html>
