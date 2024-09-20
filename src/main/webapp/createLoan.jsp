<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Loan Request - Bibliotheque Management System</title>
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
               padding: 30px;
               box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
           }
           h2 {
               text-align: center;
           }
           .form-group {
               margin-bottom: 15px;
           }
           .form-group label {
               display: block;
               margin-bottom: 5px;
           }
           .form-group input, .form-group select {
               width: 100%;
               padding: 10px;
               border: 1px solid #ddd;
               border-radius: 5px;
           }
           .button {
               background-color: #007bff;
               color: white;
               padding: 10px 20px;
               text-decoration: none;
               border-radius: 5px;
               display: inline-block;
               margin: 10px 0;
               text-align: center;
           }
           .button:hover {
               background-color: #0056b3;
           }
           .button-container {
               display: flex;
               justify-content: center;
               gap: 10px; /* Space between buttons */
           }
       </style>
</head>
<body>

    <div class="header">
        <h1>Ajouter Un Nouveau Pret</h1>

    </div>

    <div class="container">
        <h2>Nouvelle Demande De Pret</h2>
       <form action="manageLoan" method="post">
        <input type="hidden" name="action" value="create">
           <div class="form-group">
               <label for="bookId">Book ID:</label>
               <input type="number" id="bookId" name="bookId" required>
           </div>
           <div class="form-group">
               <label for="userId">User Id:</label>
               <input type="number" id="userId" name="userId" required>
           </div>
           <div class="form-group">
               <label for="borrowDate">Borrow Date:</label>
               <input type="date" id="borrowDate" name="borrowDate" required>
           </div>
           <div class="form-group">
               <label for="returnDate">Return Date:</label>
               <input type="date" id="returnDate" name="returnDate">
           </div>
           <div class="form-group">
               <label for="dueDate">Due Date:</label>
               <input type="date" id="dueDate" name="dueDate" required>
           </div>
           <div class="form-group">
               <label for="penalty">Penalty:</label>
               <input type="number" step="0.01" id="penalty" name="penalty">
           </div>
           <div class="form-group">
               <label for="status">Status:</label>
               <select id="status" name="status" required>
                   <option value="Pending">En Cours..</option>
                   <option value="Approved">Accepter</option>
                   <option value="Rejected">Rejecter</option>
               </select>
           </div>

          <button type="submit" class="button">Creer</button>
          <a href="manageLoans.jsp" class="button">Retour</a>
       </form>

    </div>

</body>
</html>
