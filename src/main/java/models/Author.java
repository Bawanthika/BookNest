package models;
public class Author {
    private int id; private String name; private String bio;
    public Author(){} public Author(int id,String name,String bio){this.id=id;this.name=name;this.bio=bio;}
    public int getId(){return id;} public void setId(int v){id=v;}
    public String getName(){return name;} public void setName(String v){name=v;}
    public String getBio(){return bio;} public void setBio(String v){bio=v;}
}
