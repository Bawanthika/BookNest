package dao;
import models.Author; import utils.DBConnection; import java.sql.*; import java.util.*;
public class AuthorDAO {
 public List<Author> all(){List<Author>x=new ArrayList<>();try(Connection c=DBConnection.getConnection();PreparedStatement p=c.prepareStatement("SELECT * FROM authors ORDER BY name");ResultSet r=p.executeQuery()){while(r.next())x.add(new Author(r.getInt(1),r.getString(2),r.getString(3)));}catch(Exception e){e.printStackTrace();}return x;}
 public Author byId(int id){try(Connection c=DBConnection.getConnection();PreparedStatement p=c.prepareStatement("SELECT * FROM authors WHERE author_id=?")){p.setInt(1,id);try(ResultSet r=p.executeQuery()){return r.next()?new Author(r.getInt(1),r.getString(2),r.getString(3)):null;}}catch(Exception e){e.printStackTrace();return null;}}
 public boolean create(String n,String b){try(Connection c=DBConnection.getConnection();PreparedStatement p=c.prepareStatement("INSERT INTO authors(name,bio) VALUES(?,?)")){p.setString(1,n);p.setString(2,b);return p.executeUpdate()>0;}catch(Exception e){e.printStackTrace();return false;}}
 public boolean update(int id,String n,String b){try(Connection c=DBConnection.getConnection();PreparedStatement p=c.prepareStatement("UPDATE authors SET name=?,bio=? WHERE author_id=?")){p.setString(1,n);p.setString(2,b);p.setInt(3,id);return p.executeUpdate()>0;}catch(Exception e){e.printStackTrace();return false;}}
 public boolean delete(int id){try(Connection c=DBConnection.getConnection();PreparedStatement p=c.prepareStatement("DELETE FROM authors WHERE author_id=?")){p.setInt(1,id);return p.executeUpdate()>0;}catch(Exception e){e.printStackTrace();return false;}}
}
