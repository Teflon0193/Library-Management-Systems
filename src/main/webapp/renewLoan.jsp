<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.util.Calendar" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    // Check if the user is logged in
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }

    Integer userId = (Integer) session.getAttribute("userId");
    Integer bookId = Integer.parseInt(request.getParameter("bookId"));

    // Get due date passed as a request parameter
    String dueDateStr = request.getParameter("dueDate");
    Date dueDate = null;

    // If due date string is not null, convert it to a Date object
    if (dueDateStr != null && !dueDateStr.isEmpty()) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        try {
            dueDate = dateFormat.parse(dueDateStr);
        } catch (ParseException e) {
            e.printStackTrace();
            dueDate = null; // In case of error, set to null
        }
    }

    // Get the current date for setting the new due date
    Calendar calendar = Calendar.getInstance();
    calendar.setTime(dueDate != null ? dueDate : new Date());
    // Set the maximum new due date to one month from today
    Calendar maxDate = (Calendar) calendar.clone();
    maxDate.add(Calendar.MONTH, 1);

    // Format the due date for display
    String formattedDueDate = (dueDate != null) ? new SimpleDateFormat("yyyy-MM-dd").format(dueDate) : "N/A";
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Renouveler le prêt</title>
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
    <h1>Choose New Date</h1>
      <!-- Input for new due date -->
         <form action="userBook" method="post">
             <input type="hidden" name="action" value="renew">
             <input type="hidden" name="bookId" value="<%= bookId %>">
             <label for="newDueDate">New Due Date:</label>
             <input type="date" name="newDueDate" id="newDueDate"
                    min="<%= new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime()) %>"
                    max="<%= new SimpleDateFormat("yyyy-MM-dd").format(maxDate.getTime()) %>"
                    required>
             <button type="submit">Renouveler</button>
         </form>

    <a href="listBooks.jsp" class="back-link">Retour à la liste des livres</a>
</body>
</html>
