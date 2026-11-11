package controllers;

import dao.UserDAO;
import utils.AuthUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/users")
public class UserServlet extends HttpServlet {

 private boolean guard(HttpServletRequest r,
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

  if (!guard(r, p)) return;

  r.setAttribute("users", new UserDAO().all());

  r.getRequestDispatcher("/admin/users.jsp").forward(r, p);
 }

 protected void doPost(HttpServletRequest r,
                       HttpServletResponse p) throws IOException {

  if (!guard(r, p)) return;

  UserDAO d = new UserDAO();
  String a = r.getParameter("action");

  if ("create".equals(a)) {
   d.create(
           r.getParameter("fullName"),
           r.getParameter("email"),
           r.getParameter("password"),
           r.getParameter("role")
   );

  } else if ("update".equals(a)) {
   d.update(
           Integer.parseInt(r.getParameter("id")),
           r.getParameter("fullName"),
           r.getParameter("email"),
           r.getParameter("role")
   );

  } else if ("delete".equals(a)) {
   d.delete(Integer.parseInt(r.getParameter("id")));
  }

  p.sendRedirect(r.getContextPath() + "/admin/users");
 }
}