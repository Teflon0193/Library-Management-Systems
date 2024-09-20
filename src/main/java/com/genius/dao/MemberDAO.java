package com.genius.dao;

import com.genius.model.Loan;
import com.genius.model.Member;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {
    private Connection connection;

    public MemberDAO(Connection connection) {
        this.connection = connection;
    }

    // Retrieve all members
    public List<Member> getAllMembers() throws SQLException {
        List<Member> members = new ArrayList<>();
        String query = "SELECT * FROM member";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Member member = new Member();
                member.setUserId(rs.getInt("userId"));
                member.setUsername(rs.getString("username"));
                member.setPassword(rs.getString("password"));
                member.setFullName(rs.getString("fullName"));
                member.setEmail(rs.getString("email"));
                members.add(member);
            }
        }
        return members;
    }

    // Retrieve member by ID
    public Member getMemberById(int userId) throws SQLException {
        Member member = null;
        String query = "SELECT * FROM member WHERE userId = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    member = new Member();
                    member.setUserId(rs.getInt("userId"));
                    member.setUsername(rs.getString("username"));
                    member.setPassword(rs.getString("password"));
                    member.setFullName(rs.getString("fullName"));
                    member.setEmail(rs.getString("email"));
                }
            }
        }
        return member;
    }

    // Search members by full name
    public List<Member> searchMembersByFullName(String fullName) throws SQLException {
        List<Member> members = new ArrayList<>();
        String sql = "SELECT * FROM member WHERE fullName LIKE ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + fullName + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Member member = new Member();
                    member.setUserId(rs.getInt("userId"));
                    member.setUsername(rs.getString("username"));
                    member.setPassword(rs.getString("password"));
                    member.setFullName(rs.getString("fullName"));
                    member.setEmail(rs.getString("email"));
                    members.add(member);
                }
            }
        }
        return members;
    }

    // Create a new member
    public void createMember(Member member) throws SQLException {
        String query = "INSERT INTO member (username, password, fullName, email) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setString(1, member.getUsername());
            pstmt.setString(2, member.getPassword());
            pstmt.setString(3, member.getFullName());
            pstmt.setString(4, member.getEmail());
            pstmt.executeUpdate();
        }
    }

    // Update an existing member
    public void updateMember(Member member) throws SQLException {
        String query = "UPDATE member SET username = ?, password = ?, fullName = ?, email = ? WHERE userId = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setString(1, member.getUsername());
            pstmt.setString(2, member.getPassword());
            pstmt.setString(3, member.getFullName());
            pstmt.setString(4, member.getEmail());
            pstmt.setInt(5, member.getUserId());
            pstmt.executeUpdate();
        }
    }

    // Delete a member
    public void deleteMember(int userId) throws SQLException {
        String query = "DELETE FROM member WHERE userId = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
        }
    }

    // Retrieve all loan requests
    public List<Loan> getAllLoanRequests() throws SQLException {
        List<Loan> loans = new ArrayList<>();
        String query = "SELECT * FROM loan";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Loan loan = new Loan();
                loan.setId(rs.getInt("id"));
                loan.setBookId(rs.getInt("bookId"));
                loan.setUserId(rs.getInt("userId"));
                loan.setBorrowDate(rs.getDate("borrowDate"));
                loan.setReturnDate(rs.getDate("returnDate"));
                loan.setDueDate(rs.getDate("dueDate"));
                loan.setPenalty(rs.getDouble("penalty"));
                loan.setStatus(rs.getString("status"));
                loans.add(loan);
            }
        }
        return loans;
    }

    // Retrieve loan requests with optional status filtering
    public List<Loan> getLoansByStatus(String status) throws SQLException {
        List<Loan> loans = new ArrayList<>();
        String query = "SELECT * FROM loan";

        // Filter by status if a status is provided
        if (status != null && !status.isEmpty()) {
            query += " WHERE status = ?";
        }

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            if (status != null && !status.isEmpty()) {
                stmt.setString(1, status);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Loan loan = new Loan();
                    loan.setId(rs.getInt("id"));
                    loan.setBookId(rs.getInt("bookId"));
                    loan.setUserId(rs.getInt("userId"));
                    loan.setBorrowDate(rs.getDate("borrowDate"));
                    loan.setReturnDate(rs.getDate("returnDate"));
                    loan.setDueDate(rs.getDate("dueDate"));
                    loan.setPenalty(rs.getDouble("penalty"));
                    loan.setStatus(rs.getString("status"));
                    loans.add(loan);
                }
            }
        }
        return loans;
    }


    // Accept loan request by setting dueDate and updating the status
    public void acceptLoanRequest(int id, Date dueDate, double penalty) throws SQLException {
        String query = "UPDATE loan SET dueDate = ?, penalty = ?, status = 'accepted' WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setDate(1, dueDate);
            pstmt.setDouble(2, penalty);
            pstmt.setInt(3, id);
            pstmt.executeUpdate();
        }
    }

    // Reject loan request by updating the status
    public void rejectLoanRequest(int id) throws SQLException {
        String query = "UPDATE loan SET status = 'rejected' WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }
}
