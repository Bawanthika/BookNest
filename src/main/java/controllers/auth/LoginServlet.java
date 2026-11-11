
package controllers.auth;

import dao.UserDAO;
import models.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

 protected void doPost(
         HttpServletRequest req,
         HttpServletResponse resp
 ) throws IOException {

  User u = new UserDAO().login(
          req.getParameter("email"),
          req.getParameter("password")
  );

  if (u == null) {
   resp.sendRedirect("login.jsp?error=1");
   return;
  }

  HttpSession s = req.getSession();

  s.setAttribute("userId", u.getId());
  s.setAttribute("userName", u.getFullName());
  s.setAttribute("userRole", u.getRole());

  resp.sendRedirect("catalog");
 }
}
