package models;
public class Category {
    private int id; private String name; private String description;
    public Category(){} public Category(int id,String name,String description){this.id=id;this.name=name;this.description=description;}
    public int getId(){return id;} public void setId(int v){id=v;}
    public String getName(){return name;} public void setName(String v){name=v;}
    public String getDescription(){return description;} public void setDescription(String v){description=v;}
}
