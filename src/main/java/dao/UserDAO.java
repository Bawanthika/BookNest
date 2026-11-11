package dao;

import models.*;
import utils.*;

import java.sql.*;
import java.util.*;

public class UserDAO {

    private User map(ResultSet r) throws SQLException {

        if ("ADMIN".equals(r.getString("role"))) {

            return new AdminUser(
                    r.getInt("user_id"),
                    r.getString("full_name"),
                    r.getString("email")
            );

        } else {

            return new CustomerUser(
                    r.getInt("user_id"),
                    r.getString("full_name"),
                    r.getString("email")
            );
        }
    }


    public User login(
            String email,
            String password
    ) {

        String q =
                "SELECT * FROM users " +
                        "WHERE email=? AND password_hash=?";

        try (
                Connection c = DBConnection.getConnection();
                PreparedStatement p = c.prepareStatement(q)
        ) {

            p.setString(1, email);
            p.setString(
                    2,
                    SecurityUtil.hashPassword(password)
            );

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


    public boolean create(
            String name,
            String email,
            String password,
            String role
    ) {

        String q =
                "INSERT INTO users " +
                        "(full_name,email,password_hash,role) " +
                        "VALUES(?,?,?,?)";

        try (
                Connection c = DBConnection.getConnection();
                PreparedStatement p = c.prepareStatement(q)
        ) {

            p.setString(1, name);
            p.setString(2, email);
            p.setString(
                    3,
                    SecurityUtil.hashPassword(password)
            );
            p.setString(4, role);

            return p.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public List<User> all() {

        List<User> users = new ArrayList<>();

        String q =
                "SELECT * FROM users " +
                        "ORDER BY user_id DESC";

        try (
                Connection c = DBConnection.getConnection();
                PreparedStatement p = c.prepareStatement(q);
                ResultSet r = p.executeQuery()
        ) {

            while (r.next()) {
                users.add(map(r));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return users;
    }


    public User byId(int id) {

        try (
                Connection c = DBConnection.getConnection();
                PreparedStatement p =
                        c.prepareStatement(
                                "SELECT * FROM users WHERE user_id=?"
                        )
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


    public boolean update(
            int id,
            String name,
            String email,
            String role
    ) {

        String q =
                "UPDATE users " +
                        "SET full_name=?,email=?,role=? " +
                        "WHERE user_id=?";

        try (
                Connection c = DBConnection.getConnection();
                PreparedStatement p = c.prepareStatement(q)
        ) {

            p.setString(1, name);
            p.setString(2, email);
            p.setString(3, role);
            p.setInt(4, id);

            return p.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean delete(int id) {

        try (
                Connection c = DBConnection.getConnection();
                PreparedStatement p =
                        c.prepareStatement(
                                "DELETE FROM users WHERE user_id=?"
                        )
        ) {

            p.setInt(1, id);

            return p.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    // DASHBOARD - CUSTOMER COUNT
    public int countCustomers() {

        String q =
                "SELECT COUNT(*) " +
                        "FROM users " +
                        "WHERE role='CUSTOMER'";

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


    // CUSTOMER PROFILE - update own name and email
    public boolean updateProfile(int userId, String name, String email) {
        if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            return false;
        }

        String q = "UPDATE users SET full_name=?, email=? WHERE user_id=?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(q)) {
            p.setString(1, name.trim());
            p.setString(2, email.trim());
            p.setInt(3, userId);
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // CUSTOMER PROFILE - change password after verifying current password
    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        if (newPassword == null || newPassword.length() < 6) {
            return false;
        }

        String check = "SELECT password_hash FROM users WHERE user_id=?";
        String update = "UPDATE users SET password_hash=? WHERE user_id=?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(check)) {
            p.setInt(1, userId);

            try (ResultSet r = p.executeQuery()) {
                if (!r.next()) {
                    return false;
                }

                String currentHash = r.getString("password_hash");
                if (!currentHash.equals(SecurityUtil.hashPassword(currentPassword))) {
                    return false;
                }
            }

            try (PreparedStatement u = c.prepareStatement(update)) {
                u.setString(1, SecurityUtil.hashPassword(newPassword));
                u.setInt(2, userId);
                return u.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
