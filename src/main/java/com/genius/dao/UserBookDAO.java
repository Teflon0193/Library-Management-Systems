package com.genius.dao;

import com.genius.model.Book;
import com.genius.model.Loan;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class UserBookDAO {

    private Connection connection;

    public UserBookDAO(Connection connection) {
        this.connection = connection;
    }

    public boolean hasActiveLoan(int userId, int bookId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM loan WHERE userId = ? AND bookId = ? AND returnDate IS NULL";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // If count > 0, user has an active loan
                }
            }
        }
        return false;
    }

    public Set<Integer> getBorrowedBooksByUser(int userId) throws SQLException {
        Set<Integer> borrowedBookIds = new HashSet<>();
        String sql = "SELECT bookId FROM loan WHERE userId = ? AND status != 'returned'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    borrowedBookIds.add(rs.getInt("bookId"));
                }
            }
        }
        return borrowedBookIds;
    }



    public boolean borrowBook(int userId, int bookId, Date borrowDate, Date returnDate) throws SQLException {
        // Decrease the available copies
        boolean updatedCopies = decreaseAvailableCopies(bookId);
        if (!updatedCopies) {
            return false; // Not enough copies available
        }

        String sql = "INSERT INTO loan (userId, bookId, borrowDate, returnDate, dueDate, status) VALUES (?, ?, ?, ?, NULL, 'pending')";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            stmt.setDate(3, new java.sql.Date(borrowDate.getTime())); // Set borrowDate
            stmt.setDate(4, new java.sql.Date(returnDate.getTime())); // Set returnDate
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }




    public void renewLoan(int userId, int bookId) throws SQLException {
        // Implement loan renewal logic
        String query = "UPDATE loan SET dueDate = DATE_ADD(dueDate, INTERVAL 30 DAY) WHERE bookId = ? AND userId = ? AND status = 'borrowed'";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, bookId);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
        }
    }

    public boolean updateLoanDueDate(Integer userId, Integer bookId, String newDueDate) {
        String query = "UPDATE loan SET dueDate = ? WHERE userId = ? AND bookId = ? AND status = 'borrowed'";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setDate(1, java.sql.Date.valueOf(newDueDate));
            stmt.setInt(2, userId);
            stmt.setInt(3, bookId);
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean returnBook(int userId, int bookId) throws SQLException {
        String query = "UPDATE loan SET returnDate = NOW(), status = 'returned' WHERE bookId = ? AND userId = ? AND status = 'Accepted'";
        int rowsAffected;

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, bookId);
            pstmt.setInt(2, userId);
            rowsAffected = pstmt.executeUpdate();
        }

        if (rowsAffected > 0) {
            // Increase available copies of the book
            increaseAvailableCopies(bookId);
            return true;
        }

        return false;
    }



    public List<Loan> getLoanHistory(int userId) throws SQLException {
        List<Loan> loanHistory = new ArrayList<>();
        String query = "SELECT * FROM loan WHERE userId = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Loan loan = new Loan();
                    loan.setId(rs.getInt("id"));
                    loan.setBookId(rs.getInt("bookId"));
                    loan.setUserId(rs.getInt("userId"));
                    loan.setBorrowDate(rs.getDate("borrowDate"));
                    loan.setReturnDate(rs.getDate("returnDate"));
                    loan.setDueDate(rs.getDate("dueDate"));
                    loan.setStatus(rs.getString("status"));
                    loanHistory.add(loan);
                }
            }
        }
        return loanHistory;
    }

    public List<Book> getAvailableBooks() throws SQLException {
        List<Book> books = new ArrayList<>();
        String query = "SELECT * FROM book WHERE availableCopies > 0";

        try (PreparedStatement pstmt = connection.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Book book = new Book();
                book.setId(rs.getInt("id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setIsbn(rs.getString("isbn"));
                book.setCategory(rs.getString("category"));
                book.setAvailableCopies(rs.getInt("availableCopies"));
                book.setStatus(rs.getString("status"));
                books.add(book);
            }
        }
        return books;
    }

    public Loan getActiveLoanDetails(int userId, int bookId) throws SQLException {
        String query = "SELECT * FROM loan WHERE userId = ? AND bookId = ? AND status = 'borrowed'";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Loan loan = new Loan();
                    loan.setDueDate(rs.getDate("dueDate"));
                    // Set other loan details if necessary
                    return loan;
                }
            }
        }
        return null; // No active loan found
    }


    public boolean decreaseAvailableCopies(int bookId) throws SQLException {
        String query = "UPDATE book SET availableCopies = availableCopies - 1 WHERE id = ? AND availableCopies > 0";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, bookId);
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        }
    }

    public void increaseAvailableCopies(int bookId) throws SQLException {
        String query = "UPDATE book SET availableCopies = availableCopies + 1 WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, bookId);
            stmt.executeUpdate(); // Increase the copies after the book is returned
        }
    }

}
