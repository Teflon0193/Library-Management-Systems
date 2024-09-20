package com.genius.dao;

import com.genius.model.Book;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    private Connection connection;

    public BookDAO(Connection connection) {
        this.connection = connection;
    }

    // Create (Add Book)
    public void addBook(Book book) throws SQLException {
        String query = "INSERT INTO book (title, author, isbn, category, availableCopies, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            connection.setAutoCommit(false); // Start transaction
            pstmt.setString(1, book.getTitle());
            pstmt.setString(2, book.getAuthor());
            pstmt.setString(3, book.getIsbn());
            pstmt.setString(4, book.getCategory());
            pstmt.setInt(5, book.getAvailableCopies());
            pstmt.setString(6, book.getStatus());
            pstmt.executeUpdate();
            connection.commit(); // Commit transaction
        } catch (SQLException e) {
            connection.rollback(); // Rollback if there is an error
            throw new SQLException("Error adding book: " + e.getMessage(), e);
        } finally {
            connection.setAutoCommit(true); // Ensure auto-commit is turned back on
        }
    }

    // Read (Get All Books)
    public List<Book> getAllBooks() throws SQLException {
        List<Book> books = new ArrayList<>();
        String query = "SELECT * FROM book";
        try (PreparedStatement pstmt = connection.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                books.add(mapRowToBook(rs));
            }
        } catch (SQLException e) {
            throw new SQLException("Error retrieving books: " + e.getMessage(), e);
        }
        return books;
    }

    // Read (Get Book by ID)
    public Book getBookById(int id) throws SQLException {
        String query = "SELECT * FROM book WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToBook(rs);
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Error retrieving book with ID: " + id, e);
        }
        return null;
    }

    // Update Book
    public void updateBook(Book book) throws SQLException {
        String query = "UPDATE book SET title = ?, author = ?, isbn = ?, category = ?, availableCopies = ?, status = ? WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            connection.setAutoCommit(false); // Start transaction
            pstmt.setString(1, book.getTitle());
            pstmt.setString(2, book.getAuthor());
            pstmt.setString(3, book.getIsbn());
            pstmt.setString(4, book.getCategory());
            pstmt.setInt(5, book.getAvailableCopies());
            pstmt.setString(6, book.getStatus());
            pstmt.setInt(7, book.getId());
            pstmt.executeUpdate();
            connection.commit(); // Commit transaction
        } catch (SQLException e) {
            connection.rollback(); // Rollback if there is an error
            throw new SQLException("Error updating book: " + e.getMessage(), e);
        } finally {
            connection.setAutoCommit(true); // Ensure auto-commit is turned back on
        }
    }

    // Delete Book
    public void deleteBook(int id) throws SQLException {
        String query = "DELETE FROM book WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            connection.setAutoCommit(false); // Start transaction
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            connection.commit(); // Commit transaction
        } catch (SQLException e) {
            connection.rollback(); // Rollback if there is an error
            throw new SQLException("Error deleting book with ID: " + id, e);
        } finally {
            connection.setAutoCommit(true); // Ensure auto-commit is turned back on
        }
    }

    // Search Books (by title, author, or ISBN)
    public List<Book> searchBooks(String searchTerm) throws SQLException {
        List<Book> books = new ArrayList<>();
        String query = "SELECT * FROM book WHERE title LIKE ? OR author LIKE ? OR isbn LIKE ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            String searchPattern = "%" + searchTerm + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapRowToBook(rs));
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Error searching books: " + e.getMessage(), e);
        }
        return books;
    }

    public String getBookTitleById(int id) throws SQLException {
        String query = "SELECT title FROM book WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("title");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Error retrieving book title by ID: " + id, e);
        }
        return null; // Return null if no book is found with the given ID
    }


    // Utility method for mapping ResultSet rows to Book objects
    private Book mapRowToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setId(rs.getInt("id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setIsbn(rs.getString("isbn"));
        book.setCategory(rs.getString("category"));
        book.setAvailableCopies(rs.getInt("availableCopies"));
        book.setStatus(rs.getString("status"));
        return book;
    }


}
