package com.genius.servlet;

import com.genius.dao.MemberDAO;
import com.genius.model.Member;
import com.genius.model.Loan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manageMembers")
public class MemberServlet extends HttpServlet {
    private MemberDAO memberDAO;
    private Connection connection;

    @Override
    public void init() throws ServletException {

        connection = (Connection) getServletContext().getAttribute("DBConnection");
        if (connection == null) {
            throw new ServletException("Database connection not available.");
        }
        memberDAO = new MemberDAO(connection);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "listMembers":
                    listMembers(request, response);
                    break;
                case "viewMember":
                    viewMember(request, response);
                    break;
                case "searchMembers":
                    searchMembers(request, response);
                    break;
                case "listLoans":
                    listLoans(request, response);
                    break;
                case "acceptLoan":
                    acceptLoan(request, response);
                    break;
                case "rejectLoan":
                    rejectLoan(request, response);
                    break;
                default:
                    listMembers(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "createMember":
                    createMember(request, response);
                    break;
                case "updateMember":
                    updateMember(request, response);
                    break;
                default:
                    response.sendRedirect("member?action=listMembers");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listMembers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<Member> members = memberDAO.getAllMembers();
        request.setAttribute("members", members);
        request.getRequestDispatcher("/.jsp").forward(request, response);
    }

    private void viewMember(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        Member member = memberDAO.getMemberById(userId);
        request.setAttribute("member", member);
        request.getRequestDispatcher("/viewMember.jsp").forward(request, response);
    }

    private void searchMembers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String fullName = request.getParameter("fullName");
        List<Member> members = memberDAO.searchMembersByFullName(fullName);
        request.setAttribute("members", members);
        request.getRequestDispatcher("/.jsp").forward(request, response);
    }

    private void createMember(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");

        Member member = new Member();
        member.setUsername(username);
        member.setPassword(password);
        member.setFullName(fullName);
        member.setEmail(email);

        memberDAO.createMember(member);
        response.sendRedirect("member?action=manageMembers");
    }

    private void updateMember(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");

        Member member = new Member();
        member.setUserId(userId);
        member.setUsername(username);
        member.setPassword(password);
        member.setFullName(fullName);
        member.setEmail(email);

        memberDAO.updateMember(member);
        response.sendRedirect("member?action=manageMembers");
    }

    private void listLoans(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Loan> loans = memberDAO.getAllLoanRequests();
        request.setAttribute("loans", loans);
        request.getRequestDispatcher("/loanList.jsp").forward(request, response);
    }

    private void acceptLoan(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int loanId = Integer.parseInt(request.getParameter("loanId"));
        Date dueDate = Date.valueOf(request.getParameter("dueDate"));
        double penalty = Double.parseDouble(request.getParameter("penalty"));
        memberDAO.acceptLoanRequest(loanId, dueDate, penalty);
        response.sendRedirect("member?action=manageMembers");
    }

    private void rejectLoan(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int loanId = Integer.parseInt(request.getParameter("loanId"));
        memberDAO.rejectLoanRequest(loanId);
        response.sendRedirect("member?action=manageMembers");
    }
}
