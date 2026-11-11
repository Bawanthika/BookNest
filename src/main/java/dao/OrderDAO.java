package dao;

import models.Book;
import models.Order;
import utils.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class OrderDAO {

 private Order map(ResultSet r) throws SQLException {
  Order o = new Order(
          r.getInt("order_id"),
          r.getInt("user_id"),
          r.getInt("book_id"),
          r.getInt("quantity"),
          r.getBigDecimal("unit_price"),
          r.getBigDecimal("total"),
          r.getString("status"),
          r.getTimestamp("created_at")
  );

  try {
   o.setCustomerName(r.getString("full_name"));
   o.setBookTitle(r.getString("title"));
  } catch (SQLException ignored) {
  }

  return o;
 }

 // ================= CREATE =================

 public boolean create(int userId, int bookId, int qty) {
  Book b = new BookDAO().byId(bookId);

  if (b == null || qty < 1 || b.getStock() < qty) {
   return false;
  }

  BigDecimal total = b.getPrice()
          .multiply(BigDecimal.valueOf(qty))
          .add(b.getDeliveryFee());

  String insertOrder =
          "INSERT INTO orders(user_id,book_id,quantity,unit_price,total,status) " +
                  "VALUES(?,?,?,?,?,'PENDING')";

  try (Connection c = DBConnection.getConnection()) {
   c.setAutoCommit(false);

   try (
           PreparedStatement p = c.prepareStatement(insertOrder);
           PreparedStatement s = c.prepareStatement(
                   "UPDATE books SET stock=stock-? WHERE book_id=? AND stock>=?"
           )
   ) {
    p.setInt(1, userId);
    p.setInt(2, bookId);
    p.setInt(3, qty);
    p.setBigDecimal(4, b.getPrice());
    p.setBigDecimal(5, total);
    p.executeUpdate();

    s.setInt(1, qty);
    s.setInt(2, bookId);
    s.setInt(3, qty);

    if (s.executeUpdate() != 1) {
     c.rollback();
     return false;
    }

    c.commit();
    return true;

   } catch (Exception e) {
    c.rollback();
    throw e;
   }

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }

 // ================= READ =================

 public List<Order> all() {
  return list("", 0);
 }

 public List<Order> byUser(int uid) {
  return list(" WHERE o.user_id=?", uid);
 }

 private List<Order> list(String where, int uid) {
  List<Order> orders = new ArrayList<>();

  String q =
          "SELECT o.*, u.full_name, b.title " +
                  "FROM orders o " +
                  "JOIN users u ON u.user_id=o.user_id " +
                  "JOIN books b ON b.book_id=o.book_id " +
                  where +
                  " ORDER BY o.order_id DESC";

  try (
          Connection c = DBConnection.getConnection();
          PreparedStatement p = c.prepareStatement(q)
  ) {
   if (uid > 0) {
    p.setInt(1, uid);
   }

   try (ResultSet r = p.executeQuery()) {
    while (r.next()) {
     orders.add(map(r));
    }
   }

  } catch (Exception e) {
   e.printStackTrace();
  }

  return orders;
 }

 // ================= ADMIN UPDATE =================
 // Handles quantity, total, delivery fee and stock correctly.

 public boolean update(int orderId, int newQty, String newStatus) {
  if (newQty < 1 || !validStatus(newStatus)) {
   return false;
  }

  String selectSql =
          "SELECT o.quantity, o.book_id, o.status, o.unit_price, " +
                  "b.stock, b.format " +
                  "FROM orders o " +
                  "JOIN books b ON b.book_id=o.book_id " +
                  "WHERE o.order_id=? FOR UPDATE";

  try (Connection c = DBConnection.getConnection()) {
   c.setAutoCommit(false);

   try (PreparedStatement select = c.prepareStatement(selectSql)) {
    select.setInt(1, orderId);

    try (ResultSet r = select.executeQuery()) {
     if (!r.next()) {
      c.rollback();
      return false;
     }

     int oldQty = r.getInt("quantity");
     int bookId = r.getInt("book_id");
     int currentStock = r.getInt("stock");
     String oldStatus = r.getString("status");
     String format = r.getString("format");
     BigDecimal unitPrice = r.getBigDecimal("unit_price");

     boolean oldCancelled = "CANCELLED".equalsIgnoreCase(oldStatus);
     boolean newCancelled = "CANCELLED".equalsIgnoreCase(newStatus);

     int stockChange = 0;

     if (!oldCancelled && !newCancelled) {
      // Active -> active: quantity difference affects stock.
      int difference = newQty - oldQty;

      if (difference > 0 && currentStock < difference) {
       c.rollback();
       return false;
      }

      stockChange = -difference;

     } else if (!oldCancelled) {
      // Active -> cancelled: restore previous quantity.
      stockChange = oldQty;

     } else if (!newCancelled) {
      // Cancelled -> active: reserve new quantity again.
      if (currentStock < newQty) {
       c.rollback();
       return false;
      }

      stockChange = -newQty;
     }

     BigDecimal deliveryFee =
             "PRINTED".equalsIgnoreCase(format)
                     ? new BigDecimal("350.00")
                     : BigDecimal.ZERO;

     BigDecimal newTotal =
             unitPrice.multiply(BigDecimal.valueOf(newQty))
                     .add(deliveryFee);

     try (
             PreparedStatement updateOrder = c.prepareStatement(
                     "UPDATE orders SET quantity=?, total=?, status=? WHERE order_id=?"
             );
             PreparedStatement updateStock = c.prepareStatement(
                     "UPDATE books SET stock=stock+? WHERE book_id=?"
             )
     ) {
      updateOrder.setInt(1, newQty);
      updateOrder.setBigDecimal(2, newTotal);
      updateOrder.setString(3, newStatus.toUpperCase());
      updateOrder.setInt(4, orderId);

      if (updateOrder.executeUpdate() != 1) {
       c.rollback();
       return false;
      }

      if (stockChange != 0) {
       updateStock.setInt(1, stockChange);
       updateStock.setInt(2, bookId);

       if (updateStock.executeUpdate() != 1) {
        c.rollback();
        return false;
       }
      }

      c.commit();
      return true;
     }
    }
   } catch (Exception e) {
    c.rollback();
    throw e;
   }

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }

 // ================= ADMIN DELETE =================
 // Restores stock before physical deletion if order was still active.

 public boolean delete(int orderId) {
  String selectSql =
          "SELECT quantity, book_id, status FROM orders " +
                  "WHERE order_id=? FOR UPDATE";

  try (Connection c = DBConnection.getConnection()) {
   c.setAutoCommit(false);

   try (PreparedStatement select = c.prepareStatement(selectSql)) {
    select.setInt(1, orderId);

    try (ResultSet r = select.executeQuery()) {
     if (!r.next()) {
      c.rollback();
      return false;
     }

     int qty = r.getInt("quantity");
     int bookId = r.getInt("book_id");
     String status = r.getString("status");

     try (
             PreparedStatement deleteOrder = c.prepareStatement(
                     "DELETE FROM orders WHERE order_id=?"
             );
             PreparedStatement restoreStock = c.prepareStatement(
                     "UPDATE books SET stock=stock+? WHERE book_id=?"
             )
     ) {
      deleteOrder.setInt(1, orderId);

      if (deleteOrder.executeUpdate() != 1) {
       c.rollback();
       return false;
      }

      // CANCELLED orders already had their stock restored.
      if (!"CANCELLED".equalsIgnoreCase(status)) {
       restoreStock.setInt(1, qty);
       restoreStock.setInt(2, bookId);

       if (restoreStock.executeUpdate() != 1) {
        c.rollback();
        return false;
       }
      }

      c.commit();
      return true;
     }
    }

   } catch (Exception e) {
    c.rollback();
    throw e;
   }

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }

 // ================= CUSTOMER UPDATE =================

 public boolean updateCustomerOrder(int orderId, int userId, int newQty) {
  if (newQty < 1) {
   return false;
  }

  String selectSql =
          "SELECT o.quantity, o.book_id, o.status, o.unit_price, " +
                  "b.stock, b.format " +
                  "FROM orders o " +
                  "JOIN books b ON b.book_id=o.book_id " +
                  "WHERE o.order_id=? AND o.user_id=? FOR UPDATE";

  try (Connection c = DBConnection.getConnection()) {
   c.setAutoCommit(false);

   try (PreparedStatement select = c.prepareStatement(selectSql)) {
    select.setInt(1, orderId);
    select.setInt(2, userId);

    try (ResultSet r = select.executeQuery()) {
     if (!r.next()) {
      c.rollback();
      return false;
     }

     if (!"PENDING".equalsIgnoreCase(r.getString("status"))) {
      c.rollback();
      return false;
     }

     int oldQty = r.getInt("quantity");
     int bookId = r.getInt("book_id");
     int currentStock = r.getInt("stock");
     BigDecimal unitPrice = r.getBigDecimal("unit_price");
     String format = r.getString("format");

     int difference = newQty - oldQty;

     if (difference > 0 && currentStock < difference) {
      c.rollback();
      return false;
     }

     BigDecimal deliveryFee =
             "PRINTED".equalsIgnoreCase(format)
                     ? new BigDecimal("350.00")
                     : BigDecimal.ZERO;

     BigDecimal newTotal =
             unitPrice.multiply(BigDecimal.valueOf(newQty))
                     .add(deliveryFee);

     try (
             PreparedStatement updateOrder = c.prepareStatement(
                     "UPDATE orders SET quantity=?, total=? " +
                             "WHERE order_id=? AND user_id=?"
             );
             PreparedStatement updateStock = c.prepareStatement(
                     "UPDATE books SET stock=stock-? WHERE book_id=?"
             )
     ) {
      updateOrder.setInt(1, newQty);
      updateOrder.setBigDecimal(2, newTotal);
      updateOrder.setInt(3, orderId);
      updateOrder.setInt(4, userId);

      if (updateOrder.executeUpdate() != 1) {
       c.rollback();
       return false;
      }

      if (difference != 0) {
       updateStock.setInt(1, difference);
       updateStock.setInt(2, bookId);

       if (updateStock.executeUpdate() != 1) {
        c.rollback();
        return false;
       }
      }

      c.commit();
      return true;
     }
    }

   } catch (Exception e) {
    c.rollback();
    throw e;
   }

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }

 // ================= CUSTOMER CANCEL =================
 // Advanced behavior: preserve order history as CANCELLED instead of deleting it.

 public boolean cancelCustomerOrder(int orderId, int userId) {
  String selectSql =
          "SELECT quantity, book_id, status FROM orders " +
                  "WHERE order_id=? AND user_id=? FOR UPDATE";

  try (Connection c = DBConnection.getConnection()) {
   c.setAutoCommit(false);

   try (PreparedStatement select = c.prepareStatement(selectSql)) {
    select.setInt(1, orderId);
    select.setInt(2, userId);

    try (ResultSet r = select.executeQuery()) {
     if (!r.next()) {
      c.rollback();
      return false;
     }

     if (!"PENDING".equalsIgnoreCase(r.getString("status"))) {
      c.rollback();
      return false;
     }

     int qty = r.getInt("quantity");
     int bookId = r.getInt("book_id");

     try (
             PreparedStatement cancel = c.prepareStatement(
                     "UPDATE orders SET status='CANCELLED' " +
                             "WHERE order_id=? AND user_id=?"
             );
             PreparedStatement restoreStock = c.prepareStatement(
                     "UPDATE books SET stock=stock+? WHERE book_id=?"
             )
     ) {
      cancel.setInt(1, orderId);
      cancel.setInt(2, userId);

      if (cancel.executeUpdate() != 1) {
       c.rollback();
       return false;
      }

      restoreStock.setInt(1, qty);
      restoreStock.setInt(2, bookId);

      if (restoreStock.executeUpdate() != 1) {
       c.rollback();
       return false;
      }

      c.commit();
      return true;
     }
    }

   } catch (Exception e) {
    c.rollback();
    throw e;
   }

  } catch (Exception e) {
   e.printStackTrace();
   return false;
  }
 }

 // ================= DASHBOARD =================

 public int countOrders() {
  return countByQuery("SELECT COUNT(*) FROM orders");
 }

 public int countPendingOrders() {
  return countByQuery(
          "SELECT COUNT(*) FROM orders WHERE status='PENDING'"
  );
 }

 public BigDecimal totalRevenue() {
  String q =
          "SELECT COALESCE(SUM(total),0) FROM orders " +
                  "WHERE status IN ('PAID','SHIPPED','COMPLETED')";

  try (
          Connection c = DBConnection.getConnection();
          PreparedStatement p = c.prepareStatement(q);
          ResultSet r = p.executeQuery()
  ) {
   if (r.next()) {
    BigDecimal revenue = r.getBigDecimal(1);
    return revenue == null ? BigDecimal.ZERO : revenue;
   }

  } catch (Exception e) {
   e.printStackTrace();
  }

  return BigDecimal.ZERO;
 }

 public List<Order> recentOrders() {
  List<Order> orders = new ArrayList<>();

  String q =
          "SELECT o.*, u.full_name, b.title " +
                  "FROM orders o " +
                  "JOIN users u ON u.user_id=o.user_id " +
                  "JOIN books b ON b.book_id=o.book_id " +
                  "ORDER BY o.order_id DESC LIMIT 5";

  try (
          Connection c = DBConnection.getConnection();
          PreparedStatement p = c.prepareStatement(q);
          ResultSet r = p.executeQuery()
  ) {
   while (r.next()) {
    orders.add(map(r));
   }

  } catch (Exception e) {
   e.printStackTrace();
  }

  return orders;
 }

 public int countByStatus(String status) {
  if (!validStatus(status)) {
   return 0;
  }

  String q = "SELECT COUNT(*) FROM orders WHERE status=?";

  try (
          Connection c = DBConnection.getConnection();
          PreparedStatement p = c.prepareStatement(q)
  ) {
   p.setString(1, status.toUpperCase());

   try (ResultSet r = p.executeQuery()) {
    return r.next() ? r.getInt(1) : 0;
   }

  } catch (Exception e) {
   e.printStackTrace();
   return 0;
  }
 }

 private int countByQuery(String q) {
  try (
          Connection c = DBConnection.getConnection();
          PreparedStatement p = c.prepareStatement(q);
          ResultSet r = p.executeQuery()
  ) {
   return r.next() ? r.getInt(1) : 0;

  } catch (Exception e) {
   e.printStackTrace();
   return 0;
  }
 }

 private boolean validStatus(String status) {
  if (status == null) {
   return false;
  }

  return switch (status.toUpperCase()) {
   case "PENDING", "PAID", "SHIPPED", "COMPLETED", "CANCELLED" -> true;
   default -> false;
  };
 }


 // ================= PHASE 2 ANALYTICS =================

 public int countByUser(int userId) {
  String q = "SELECT COUNT(*) FROM orders WHERE user_id=?";

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

 public Map<String, Integer> orderStatusCounts() {
  Map<String, Integer> data = new LinkedHashMap<>();
  data.put("PENDING", 0);
  data.put("PAID", 0);
  data.put("SHIPPED", 0);
  data.put("COMPLETED", 0);
  data.put("CANCELLED", 0);

  String q = "SELECT status, COUNT(*) total FROM orders GROUP BY status";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q);
       ResultSet r = p.executeQuery()) {
   while (r.next()) {
    data.put(r.getString("status").toUpperCase(), r.getInt("total"));
   }
  } catch (Exception e) {
   e.printStackTrace();
  }

  return data;
 }

 public Map<String, BigDecimal> monthlyRevenue() {
  Map<String, BigDecimal> data = new LinkedHashMap<>();

  String q = "SELECT DATE_FORMAT(created_at,'%Y-%m') month_key, " +
          "COALESCE(SUM(total),0) revenue " +
          "FROM orders " +
          "WHERE status IN ('PAID','SHIPPED','COMPLETED') " +
          "AND created_at >= DATE_SUB(CURDATE(), INTERVAL 5 MONTH) " +
          "GROUP BY DATE_FORMAT(created_at,'%Y-%m') " +
          "ORDER BY month_key";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q);
       ResultSet r = p.executeQuery()) {
   while (r.next()) {
    data.put(r.getString("month_key"), r.getBigDecimal("revenue"));
   }
  } catch (Exception e) {
   e.printStackTrace();
  }

  return data;
 }

 public List<Map<String, Object>> bestSellingBooks() {
  List<Map<String, Object>> data = new ArrayList<>();

  String q = "SELECT b.title, SUM(o.quantity) sold, COALESCE(SUM(o.total),0) revenue " +
          "FROM orders o " +
          "JOIN books b ON b.book_id=o.book_id " +
          "WHERE o.status <> 'CANCELLED' " +
          "GROUP BY b.book_id, b.title " +
          "ORDER BY sold DESC, revenue DESC " +
          "LIMIT 5";

  try (Connection c = DBConnection.getConnection();
       PreparedStatement p = c.prepareStatement(q);
       ResultSet r = p.executeQuery()) {
   while (r.next()) {
    Map<String, Object> row = new LinkedHashMap<>();
    row.put("title", r.getString("title"));
    row.put("sold", r.getInt("sold"));
    row.put("revenue", r.getBigDecimal("revenue"));
    data.add(row);
   }
  } catch (Exception e) {
   e.printStackTrace();
  }

  return data;
 }

}
