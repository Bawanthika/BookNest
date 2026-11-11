package models;

public abstract class User {
    private int id;
    private String fullName;
    private String email;
    private String role;

    protected User(int id, String fullName, String email, String role) {
        this.id=id; this.fullName=fullName; this.email=email; this.role=role;
    }
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public String getFullName(){return fullName;} public void setFullName(String v){this.fullName=v;}
    public String getEmail(){return email;} public void setEmail(String v){this.email=v;}
    public String getRole(){return role;} public void setRole(String v){this.role=v;}
    public abstract String getDashboardLabel();
}
