package models;
import java.math.BigDecimal;
public abstract class Book {
    private int id; private String isbn,title,description,imageUrl; private int authorId,categoryId,stock; private BigDecimal price; private String authorName,categoryName;
    protected Book(int id,String isbn,String title,int authorId,int categoryId,BigDecimal price,int stock,String description,String imageUrl){this.id=id;this.isbn=isbn;this.title=title;this.authorId=authorId;this.categoryId=categoryId;this.price=price;this.stock=stock;this.description=description;this.imageUrl=imageUrl;}
    public int getId(){return id;} public void setId(int v){id=v;} public String getIsbn(){return isbn;} public void setIsbn(String v){isbn=v;} public String getTitle(){return title;} public void setTitle(String v){title=v;} public int getAuthorId(){return authorId;} public void setAuthorId(int v){authorId=v;} public int getCategoryId(){return categoryId;} public void setCategoryId(int v){categoryId=v;} public BigDecimal getPrice(){return price;} public void setPrice(BigDecimal v){price=v;} public int getStock(){return stock;} public void setStock(int v){stock=v;} public String getDescription(){return description;} public void setDescription(String v){description=v;} public String getImageUrl(){return imageUrl;} public void setImageUrl(String v){imageUrl=v;} public String getAuthorName(){return authorName;} public void setAuthorName(String v){authorName=v;} public String getCategoryName(){return categoryName;} public void setCategoryName(String v){categoryName=v;}
    public abstract String getFormat();
    public abstract BigDecimal getDeliveryFee();
}
