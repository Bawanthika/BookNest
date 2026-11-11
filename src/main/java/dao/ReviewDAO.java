package dao;

import models.Review;
import utils.DBConnection;

import java.sql.*;
import java.util.*;

public class ReviewDAO {

 private Review map(ResultSet r) throws SQLException {
  Review v = new Review(
          r.getInt("review_id"),
          r.getInt("user_id"),
          r.getInt("book_id"),
          r.getInt("rating"),
          r.getString("comment"),
          r.getBoolean("approved"),
          r.getTimestamp("created_at")
  );

  try {
   v.setUserName(r.getString("full_name"));
   v.setBookTitle(r.getString("title"));
  } catch (SQLException ignored) {
  }

  return v;
 }

 public boolean create(int userId, int bookId, int rating, String comment) {
  if (rating < 1 || rating > 5 || comment == null || comment.trim().isEmpty()) {
   return false;
  }

  String q = "INSERT INTO reviews(user_id,book_id,rating,comment,approved) VALUES(?,?,?,?,false)";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q)) {

   p.setInt(1, userId);
   p.setInt(2, bookId);
   p.setInt(3, rating);
   p.setString(4, comment.trim());

   return p.executeUpdate() > 0;

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }

 public List<Review> all() {
  return list(false, 0);
 }

 public List<Review> approved() {
  return list(true, 0);
 }

 public List<Review> byUser(int uid) {
  return list(false, uid);
 }

 public List<Review> approvedByBook(int bookId) {
  List<Review> reviews = new ArrayList<>();

  String q =
          "SELECT r.*,u.full_name,b.title " +
                  "FROM reviews r " +
                  "JOIN users u ON u.user_id=r.user_id " +
                  "JOIN books b ON b.book_id=r.book_id " +
                  "WHERE r.approved=true AND r.book_id=? " +
                  "ORDER BY r.review_id DESC";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q)) {

   p.setInt(1, bookId);

   try (ResultSet r = p.executeQuery()) {
    while (r.next()) {
     reviews.add(map(r));
    }
   }

  } catch (Exception e) {
   e.printStackTrace();
  }

  return reviews;
 }

 public double averageRatingForBook(int bookId) {
  String q = "SELECT COALESCE(AVG(rating),0) FROM reviews WHERE approved=true AND book_id=?";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q)) {

   p.setInt(1, bookId);

   try (ResultSet r = p.executeQuery()) {
    if (r.next()) {
     return r.getDouble(1);
    }
   }

  } catch (Exception e) {
   e.printStackTrace();
  }

  return 0;
 }

 public int countByUser(int userId) {
  String q = "SELECT COUNT(*) FROM reviews WHERE user_id=?";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q)) {

   p.setInt(1, userId);

   try (ResultSet r = p.executeQuery()) {
    if (r.next()) {
     return r.getInt(1);
    }
   }

  } catch (Exception e) {
   e.printStackTrace();
  }

  return 0;
 }

 public int countPending() {
  String q = "SELECT COUNT(*) FROM reviews WHERE approved=false";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q);
       ResultSet r = p.executeQuery()) {

   if (r.next()) {
    return r.getInt(1);
   }

  } catch (Exception e) {
   e.printStackTrace();
  }

  return 0;
 }

 public int countApproved() {
  String q = "SELECT COUNT(*) FROM reviews WHERE approved=true";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q);
       ResultSet r = p.executeQuery()) {

   if (r.next()) {
    return r.getInt(1);
   }

  } catch (Exception e) {
   e.printStackTrace();
  }

  return 0;
 }

 private List<Review> list(boolean approvedOnly, int uid) {
  List<Review> reviews = new ArrayList<>();

  String q =
          "SELECT r.*,u.full_name,b.title " +
                  "FROM reviews r " +
                  "JOIN users u ON u.user_id=r.user_id " +
                  "JOIN books b ON b.book_id=r.book_id " +
                  "WHERE 1=1" +
                  (approvedOnly ? " AND r.approved=true" : "") +
                  (uid > 0 ? " AND r.user_id=?" : "") +
                  " ORDER BY r.review_id DESC";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q)) {

   if (uid > 0) {
    p.setInt(1, uid);
   }

   try (ResultSet r = p.executeQuery()) {
    while (r.next()) {
     reviews.add(map(r));
    }
   }

  } catch (Exception e) {
   e.printStackTrace();
  }

  return reviews;
 }

 // ADMIN: edit review content and approval status
 public boolean update(int id, int rating, String comment, boolean approved) {
  if (rating < 1 || rating > 5 || comment == null || comment.trim().isEmpty()) {
   return false;
  }

  String q = "UPDATE reviews SET rating=?,comment=?,approved=? WHERE review_id=?";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q)) {

   p.setInt(1, rating);
   p.setString(2, comment.trim());
   p.setBoolean(3, approved);
   p.setInt(4, id);

   return p.executeUpdate() > 0;

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }

 // ADMIN: approve review with one click
 public boolean approve(int id) {
  String q = "UPDATE reviews SET approved=true WHERE review_id=?";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q)) {

   p.setInt(1, id);
   return p.executeUpdate() > 0;

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }

 // ADMIN: send an approved review back to pending
 public boolean setPending(int id) {
  String q = "UPDATE reviews SET approved=false WHERE review_id=?";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q)) {

   p.setInt(1, id);
   return p.executeUpdate() > 0;

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }

 // ADMIN: permanently remove review
 public boolean delete(int id) {
  String q = "DELETE FROM reviews WHERE review_id=?";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q)) {

   p.setInt(1, id);
   return p.executeUpdate() > 0;

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }

 // CUSTOMER: update only own review and return it to pending
 public boolean updateByUser(int id, int userId, int rating, String comment) {
  if (rating < 1 || rating > 5 || comment == null || comment.trim().isEmpty()) {
   return false;
  }

  String q =
          "UPDATE reviews " +
                  "SET rating=?, comment=?, approved=false " +
                  "WHERE review_id=? AND user_id=?";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q)) {

   p.setInt(1, rating);
   p.setString(2, comment.trim());
   p.setInt(3, id);
   p.setInt(4, userId);

   return p.executeUpdate() > 0;

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }

 // CUSTOMER: delete only own review
 public boolean deleteByUser(int id, int userId) {
  String q = "DELETE FROM reviews WHERE review_id=? AND user_id=?";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q)) {

   p.setInt(1, id);
   p.setInt(2, userId);

   return p.executeUpdate() > 0;

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }
}
