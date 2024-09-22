<%@ page import="java.sql.*" %>
<%@ page import="com.genius.dao.UserBookDAO" %>
<%
    // Check if the user is logged in
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }

    Integer userId = (Integer) session.getAttribute("userId");
    Integer bookId = Integer.parseInt(request.getParameter("bookId"));
    String newDueDate = request.getParameter("newDueDate");

    Connection connection = (Connection) application.getAttribute("DBConnection");
    if (connection != null) {
        UserBookDAO userBookDAO = new UserBookDAO(connection);

        // Update the loan s due date
        boolean updated = userBookDAO.updateLoanDueDate(userId, bookId, newDueDate);

        if (updated) {
            out.println("<p>Loan renewed successfully! New due date: " + newDueDate + "</p>");
        } else {
            out.println("<p>Failed to renew loan. Please try again.</p>");
        }
    } else {
        out.println("<p>Database connection is not available.</p>");
    }
%>
<a href="bookList.jsp">Back to Book List</a>
