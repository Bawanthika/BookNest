# Online BookStore Management System — SE1020 OOP Project

Complete Java/JSP/Servlet/MySQL project created for the SE1020 Object Oriented Programming assignment.

## Requirements covered
- Java web application for an Online BookStore.
- OOP: encapsulation, inheritance, polymorphism and abstraction.
- Six independent CRUD components: User, Book, Author, Category, Order, Review.
- Responsive JSP/HTML/CSS frontend.
- MySQL data storage (allowed by the assignment guidance).
- Source code, SQL sample data, class diagram, workload distribution and viva guide.

## Technology
Java 17, Jakarta Servlet 6, JSP, MySQL 8, Maven WAR, IntelliJ IDEA, Tomcat 10.1+.

## Setup
1. Open this folder in IntelliJ as a Maven project.
2. Run `database/online_bookstore.sql` in MySQL Workbench/phpMyAdmin.
3. If MySQL root has a password, edit `src/main/java/utils/DBConnection.java`.
4. Add Tomcat 10.1+ in IntelliJ: Run > Edit Configurations > Tomcat Server > Local.
5. Deploy the `OnlineBookStore:war exploded` artifact.
6. Run and open `/OnlineBookStore/catalog` (your context path may differ).

## Demo accounts
- Admin: `admin@booknest.lk` / `admin123`
- Customer: `customer@booknest.lk` / `customer123`

## OOP evidence
- Encapsulation: private fields and getters/setters in model classes.
- Inheritance: `AdminUser`, `CustomerUser` extend `User`; `PrintedBook`, `EBook` extend `Book`.
- Polymorphism: subclasses override `getDashboardLabel()`, `getFormat()`, `getDeliveryFee()`.
- Abstraction: `User` and `Book` are abstract classes.

## Architecture
JSP / Browser → Servlet Controller → DAO → MySQL

## Progress-check demo
Show catalogue → register/login → User CRUD → Book CRUD → Author CRUD → Category CRUD → customer order → admin order update/delete → customer review → admin approval.

## GitHub
Create the repo early and commit each member's module separately. The final report/viva asks for commit history.
