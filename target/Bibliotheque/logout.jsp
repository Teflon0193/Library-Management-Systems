<%
    session.invalidate(); // Invalidate session to log out admin
    response.sendRedirect("login.jsp"); // Redirect to login page
%>
