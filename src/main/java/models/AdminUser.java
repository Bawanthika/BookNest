package models;
public class AdminUser extends User {
    public AdminUser(int id,String n,String e){super(id,n,e,"ADMIN");}
    @Override public String getDashboardLabel(){return "Administrator Dashboard";}
}
