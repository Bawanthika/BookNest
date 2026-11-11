package controllers;

import dao.*;
import utils.AuthUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/books")
public class BookServlet extends HttpServlet {

 private boolean g(HttpServletRequest r,
                   HttpServletResponse p) throws IOException {

  if (!AuthUtil.isAdmin(r)) {
   p.sendRedirect(r.getContextPath() + "/login.jsp");
   return false;
  }

  return true;
 }

 protected void doGet(HttpServletRequest r,
                      HttpServletResponse p)
         throws ServletException, IOException {

  if (!g(r, p)) return;

  r.setAttribute("books", new BookDAO().all());
  r.setAttribute("authors", new AuthorDAO().all());
  r.setAttribute("categories", new CategoryDAO().all());

  r.getRequestDispatcher("/admin/books.jsp").forward(r, p);
 }

 protected void doPost(HttpServletRequest r,
                       HttpServletResponse p) throws IOException {

  if (!g(r, p)) return;

  BookDAO d = new BookDAO();
  String a = r.getParameter("action");

  if ("delete".equals(a)) {
   d.delete(Integer.parseInt(r.getParameter("id")));
  } else {
   String isbn = r.getParameter("isbn");
   String title = r.getParameter("title");
   String format = r.getParameter("format");
   String desc = r.getParameter("description");
   String img = r.getParameter("imageUrl");

   int au = Integer.parseInt(r.getParameter("authorId"));
   int cat = Integer.parseInt(r.getParameter("categoryId"));
   int stock = Integer.parseInt(r.getParameter("stock"));

   BigDecimal price = new BigDecimal(r.getParameter("price"));

   if ("create".equals(a)) {
    d.create(isbn, title, au, cat, price, stock,
            format, desc, img);
   } else {
    d.update(Integer.parseInt(r.getParameter("id")),
            isbn, title, au, cat, price, stock,
            format, desc, img);
   }
  }

  p.sendRedirect(r.getContextPath() + "/admin/books");
 }
}