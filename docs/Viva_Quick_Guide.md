# Viva Quick Guide

**Project:** BookNest Online BookStore Management System.

**Architecture:** JSP frontend → Servlet controller → DAO → MySQL.

**Encapsulation:** all model data is private and accessed using getters/setters.

**Inheritance:** AdminUser and CustomerUser inherit User; PrintedBook and EBook inherit Book.

**Polymorphism:** PrintedBook and EBook override `getFormat()` and `getDeliveryFee()`. PrintedBook has Rs. 350 delivery; EBook has zero delivery.

**Abstraction:** User and Book are abstract classes.

**CRUD example:** BookServlet handles requests and BookDAO performs create/read/update/delete using PreparedStatement.

**Security:** passwords are SHA-256 hashed for this academic project; SQL statements use PreparedStatement; admin routes check session role.
