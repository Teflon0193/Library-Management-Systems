package com.genius.dao;

import com.genius.model.Loan;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LoanDAO {
    private Connection connection;

    public LoanDAO(Connection connection) {
        this.connection = connection;
    }

    // Fetch all loans for admin view
    public List<Loan> getAllLoans() throws SQLException {
        List<Loan> loans = new ArrayList<>();
        String sql = "SELECT * FROM loan";

        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

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

    public Loan getLoanById(int id) throws SQLException {
        Loan loan = null;
        String sql = "SELECT * FROM loan WHERE id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                loan = new Loan();
                loan.setId(resultSet.getInt("id"));
                loan.setBookId(resultSet.getInt("bookId"));
                loan.setUserId(resultSet.getInt("userId"));
                loan.setBorrowDate(resultSet.getDate("borrowDate"));
                loan.setReturnDate(resultSet.getDate("returnDate"));
                loan.setDueDate(resultSet.getDate("dueDate"));
                loan.setPenalty(resultSet.getDouble("penalty"));
                loan.setStatus(resultSet.getString("status"));
            }
        } catch (SQLException e) {
            // Handle SQLException, e.g., log it or throw a custom exception
            throw new SQLException("Error retrieving loan with ID " + id, e);
        }
        return loan;
    }

    public void updateLoan(Loan loan) throws SQLException {
        String sql = "UPDATE loan SET status = ?, dueDate = ? WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, loan.getStatus());
            // Convert java.util.Date to java.sql.Date
            if (loan.getDueDate() != null) {
                pstmt.setDate(2, new java.sql.Date(loan.getDueDate().getTime()));
            } else {
                pstmt.setNull(2, java.sql.Types.DATE); // If due date is null
            }

            pstmt.setInt(3, loan.getId());
            pstmt.executeUpdate();
        }
    }


}
