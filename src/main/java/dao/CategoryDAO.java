package dao;
import models.Category; import utils.DBConnection; import java.sql.*; import java.util.*;
public class CategoryDAO {
 public List<Category> all(){List<Category>x=new ArrayList<>();try(Connection c=DBConnection.getConnection();PreparedStatement p=c.prepareStatement("SELECT * FROM categories ORDER BY name");ResultSet r=p.executeQuery()){while(r.next())x.add(new Category(r.getInt(1),r.getString(2),r.getString(3)));}catch(Exception e){e.printStackTrace();}return x;}
 public Category byId(int id){try(Connection c=DBConnection.getConnection();PreparedStatement p=c.prepareStatement("SELECT * FROM categories WHERE category_id=?")){p.setInt(1,id);try(ResultSet r=p.executeQuery()){return r.next()?new Category(r.getInt(1),r.getString(2),r.getString(3)):null;}}catch(Exception e){e.printStackTrace();return null;}}
 public boolean create(String n,String d){try(Connection c=DBConnection.getConnection();PreparedStatement p=c.prepareStatement("INSERT INTO categories(name,description) VALUES(?,?)")){p.setString(1,n);p.setString(2,d);return p.executeUpdate()>0;}catch(Exception e){e.printStackTrace();return false;}}
 public boolean update(int id,String n,String d){try(Connection c=DBConnection.getConnection();PreparedStatement p=c.prepareStatement("UPDATE categories SET name=?,description=? WHERE category_id=?")){p.setString(1,n);p.setString(2,d);p.setInt(3,id);return p.executeUpdate()>0;}catch(Exception e){e.printStackTrace();return false;}}
 public boolean delete(int id){try(Connection c=DBConnection.getConnection();PreparedStatement p=c.prepareStatement("DELETE FROM categories WHERE category_id=?")){p.setInt(1,id);return p.executeUpdate()>0;}catch(Exception e){e.printStackTrace();return false;}}
}
