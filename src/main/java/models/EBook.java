package models;
import java.math.BigDecimal;
public class EBook extends Book {
    public EBook(int id,String isbn,String title,int a,int c,BigDecimal p,int s,String d,String i){super(id,isbn,title,a,c,p,s,d,i);}
    @Override public String getFormat(){return "EBOOK";}
    @Override public BigDecimal getDeliveryFee(){return BigDecimal.ZERO;}
}
