package dao;

import models.*;
import utils.DBConnection;

import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class BookDAO {

 private Book map(ResultSet r) throws SQLException {

  String format = r.getString("format");

  Book b;

  if ("EBOOK".equalsIgnoreCase(format)) {

   b = new EBook(
           r.getInt("book_id"),
           r.getString("isbn"),
           r.getString("title"),
           r.getInt("author_id"),
           r.getInt("category_id"),
           r.getBigDecimal("price"),
           r.getInt("stock"),
           r.getString("description"),
           r.getString("image_url")
   );

  } else {

   b = new PrintedBook(
           r.getInt("book_id"),
           r.getString("isbn"),
           r.getString("title"),
           r.getInt("author_id"),
           r.getInt("category_id"),
           r.getBigDecimal("price"),
           r.getInt("stock"),
           r.getString("description"),
           r.getString("image_url")
   );
  }

  try {
   b.setAuthorName(r.getString("author_name"));
   b.setCategoryName(r.getString("category_name"));
  } catch (SQLException ignored) {
  }

  return b;
 }


 // READ ALL
 public List<Book> all() {

  List<Book> books = new ArrayList<>();

  String q =
          "SELECT b.*, a.name author_name, c.name category_name " +
                  "FROM books b " +
                  "JOIN authors a ON a.author_id=b.author_id " +
                  "JOIN categories c ON c.category_id=b.category_id " +
                  "ORDER BY b.book_id DESC";

  try (
          Connection c = DBConnection.getConnection();
          PreparedStatement p = c.prepareStatement(q);
          ResultSet r = p.executeQuery()
  ) {

   while (r.next()) {
    books.add(map(r));
   }

  } catch (Exception e) {
   e.printStackTrace();
  }

  return books;
 }


 // READ ONE
 public Book byId(int id) {

  String q =
          "SELECT b.*, a.name author_name, c.name category_name " +
                  "FROM books b " +
                  "JOIN authors a ON a.author_id=b.author_id " +
                  "JOIN categories c ON c.category_id=b.category_id " +
                  "WHERE b.book_id=?";

  try (
          Connection c = DBConnection.getConnection();
          PreparedStatement p = c.prepareStatement(q)
  ) {

   p.setInt(1, id);

   try (ResultSet r = p.executeQuery()) {

    if (r.next()) {
     return map(r);
    }
   }

  } catch (Exception e) {
   e.printStackTrace();
  }

  return null;
 }


 // CREATE
 public boolean create(
         String isbn,
         String title,
         int authorId,
         int categoryId,
         BigDecimal price,
         int stock,
         String format,
         String description,
         String imageUrl
 ) {

  String q =
          "INSERT INTO books " +
                  "(isbn,title,author_id,category_id,price,stock,format,description,image_url) " +
                  "VALUES(?,?,?,?,?,?,?,?,?)";

  try (
          Connection c = DBConnection.getConnection();
          PreparedStatement p = c.prepareStatement(q)
  ) {

   p.setString(1, isbn);
   p.setString(2, title);
   p.setInt(3, authorId);
   p.setInt(4, categoryId);
   p.setBigDecimal(5, price);
   p.setInt(6, stock);
   p.setString(7, format);
   p.setString(8, description);
   p.setString(9, imageUrl);

   return p.executeUpdate() > 0;

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }


 // UPDATE
 public boolean update(
         int id,
         String isbn,
         String title,
         int authorId,
         int categoryId,
         BigDecimal price,
         int stock,
         String format,
         String description,
         String imageUrl
 ) {

  String q =
          "UPDATE books SET " +
                  "isbn=?, title=?, author_id=?, category_id=?, " +
                  "price=?, stock=?, format=?, description=?, image_url=? " +
                  "WHERE book_id=?";

  try (
          Connection c = DBConnection.getConnection();
          PreparedStatement p = c.prepareStatement(q)
  ) {

   p.setString(1, isbn);
   p.setString(2, title);
   p.setInt(3, authorId);
   p.setInt(4, categoryId);
   p.setBigDecimal(5, price);
   p.setInt(6, stock);
   p.setString(7, format);
   p.setString(8, description);
   p.setString(9, imageUrl);
   p.setInt(10, id);

   return p.executeUpdate() > 0;

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }


 // DELETE
 public boolean delete(int id) {

  try (
          Connection c = DBConnection.getConnection();
          PreparedStatement p =
                  c.prepareStatement(
                          "DELETE FROM books WHERE book_id=?"
                  )
  ) {

   p.setInt(1, id);

   return p.executeUpdate() > 0;

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }


 // DASHBOARD - BOOK COUNT
 public int countBooks() {

  String q = "SELECT COUNT(*) FROM books";

  try (
          Connection c = DBConnection.getConnection();
          PreparedStatement p = c.prepareStatement(q);
          ResultSet r = p.executeQuery()
  ) {

   if (r.next()) {
    return r.getInt(1);
   }

  } catch (Exception e) {
   e.printStackTrace();
  }

  return 0;
 }


 // DASHBOARD - LOW STOCK BOOKS
 public List<Book> lowStockBooks() {

  List<Book> books = new ArrayList<>();

  String q =
          "SELECT b.*, a.name author_name, c.name category_name " +
                  "FROM books b " +
                  "JOIN authors a ON a.author_id=b.author_id " +
                  "JOIN categories c ON c.category_id=b.category_id " +
                  "WHERE b.stock <= 5 " +
                  "ORDER BY b.stock ASC, b.title ASC " +
                  "LIMIT 5";

  try (
          Connection c = DBConnection.getConnection();
          PreparedStatement p = c.prepareStatement(q);
          ResultSet r = p.executeQuery()
  ) {

   while (r.next()) {
    books.add(map(r));
   }

  } catch (Exception e) {
   e.printStackTrace();
  }

  return books;
 }
}