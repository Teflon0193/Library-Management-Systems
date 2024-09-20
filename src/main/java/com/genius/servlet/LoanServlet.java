package com.genius.servlet;

import com.genius.dao.LoanDAO;
import com.genius.model.Loan;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/loan")
public class LoanServlet extends HttpServlet {

    private LoanDAO loanDAO;

    @Override
    public void init() throws ServletException {
        Connection connection = (Connection) getServletContext().getAttribute("DBConnection");
        loanDAO = new LoanDAO(connection);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch all loans from the database
            List<Loan> loans = loanDAO.getAllLoans();

            // Set the loans in the request scope
            request.setAttribute("loans", loans);

            // Forward to JSP page to display loans
            request.getRequestDispatcher("/webapp/manageLoans.jsp").forward(request, response);
        } catch (SQLException e) {
            // Handle SQLException by forwarding to an error page
            request.setAttribute("errorMessage", "Error retrieving loans: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        int id = Integer.parseInt(request.getParameter("id"));
        java.util.Date dueDate = null;

        if ("accept".equals(action)) {
            if (request.getParameter("dueDate") != null && !request.getParameter("dueDate").isEmpty()) {
                try {
                    // Convert the due date string to java.util.Date
                    dueDate = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("dueDate"));
                } catch (ParseException e) {
                    request.setAttribute("errorMessage", "Invalid date format: " + e.getMessage());
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                    return;
                }
            }

            try {
                Loan loan = loanDAO.getLoanById(id);
                if (loan == null) {
                    request.setAttribute("errorMessage", "Loan not found.");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                    return;
                }
                loan.setStatus("Accepted");
                loan.setDueDate(dueDate);
                loanDAO.updateLoan(loan);
                response.sendRedirect("manageLoans.jsp");
            } catch (SQLException e) {
                request.setAttribute("errorMessage", "Error updating loan: " + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        } else if ("reject".equals(action)) {
            try {
                Loan loan = loanDAO.getLoanById(id);
                if (loan != null) {
                    loan.setStatus("Rejected");
                    loanDAO.updateLoan(loan);
                }
                response.sendRedirect("manageLoans.jsp");
            } catch (SQLException e) {
                request.setAttribute("errorMessage", "Error rejecting loan: " + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        }
    }

}
