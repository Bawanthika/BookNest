package models;
public class CustomerUser extends User {
    public CustomerUser(int id,String n,String e){super(id,n,e,"CUSTOMER");}
    @Override public String getDashboardLabel(){return "Customer Account";}
}
