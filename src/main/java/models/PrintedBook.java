package models;
import java.math.BigDecimal;
public class PrintedBook extends Book {
    public PrintedBook(int id,String isbn,String title,int a,int c,BigDecimal p,int s,String d,String i){super(id,isbn,title,a,c,p,s,d,i);}
    @Override public String getFormat(){return "PRINTED";}
    @Override public BigDecimal getDeliveryFee(){return new BigDecimal("350.00");}
}
