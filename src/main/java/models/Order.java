package models;
import java.math.BigDecimal; import java.sql.Timestamp;
public class Order {
    private int id,userId,bookId,quantity; private BigDecimal unitPrice,total; private String status,customerName,bookTitle; private Timestamp createdAt;
    public Order(){}
    public Order(int id,int userId,int bookId,int quantity,BigDecimal unitPrice,BigDecimal total,String status,Timestamp createdAt){this.id=id;this.userId=userId;this.bookId=bookId;this.quantity=quantity;this.unitPrice=unitPrice;this.total=total;this.status=status;this.createdAt=createdAt;}
    public int getId(){return id;} public void setId(int v){id=v;} public int getUserId(){return userId;} public void setUserId(int v){userId=v;} public int getBookId(){return bookId;} public void setBookId(int v){bookId=v;} public int getQuantity(){return quantity;} public void setQuantity(int v){quantity=v;} public BigDecimal getUnitPrice(){return unitPrice;} public void setUnitPrice(BigDecimal v){unitPrice=v;} public BigDecimal getTotal(){return total;} public void setTotal(BigDecimal v){total=v;} public String getStatus(){return status;} public void setStatus(String v){status=v;} public Timestamp getCreatedAt(){return createdAt;} public void setCreatedAt(Timestamp v){createdAt=v;} public String getCustomerName(){return customerName;} public void setCustomerName(String v){customerName=v;} public String getBookTitle(){return bookTitle;} public void setBookTitle(String v){bookTitle=v;}
}
