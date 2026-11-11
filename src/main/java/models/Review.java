package models;
import java.sql.Timestamp;
public class Review {
    private int id,userId,bookId,rating; private String comment,userName,bookTitle; private boolean approved; private Timestamp createdAt;
    public Review(){}
    public Review(int id,int userId,int bookId,int rating,String comment,boolean approved,Timestamp createdAt){this.id=id;this.userId=userId;this.bookId=bookId;this.rating=rating;this.comment=comment;this.approved=approved;this.createdAt=createdAt;}
    public int getId(){return id;} public void setId(int v){id=v;} public int getUserId(){return userId;} public void setUserId(int v){userId=v;} public int getBookId(){return bookId;} public void setBookId(int v){bookId=v;} public int getRating(){return rating;} public void setRating(int v){rating=v;} public String getComment(){return comment;} public void setComment(String v){comment=v;} public boolean isApproved(){return approved;} public void setApproved(boolean v){approved=v;} public Timestamp getCreatedAt(){return createdAt;} public void setCreatedAt(Timestamp v){createdAt=v;} public String getUserName(){return userName;} public void setUserName(String v){userName=v;} public String getBookTitle(){return bookTitle;} public void setBookTitle(String v){bookTitle=v;}
}
