
package controllers.auth;

import dao.UserDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

 protected void doPost(
         HttpServletRequest req,
         HttpServletResponse resp
 ) throws IOException {

  boolean ok = new UserDAO().create(
          req.getParameter("fullName"),
          req.getParameter("email"),
          req.getParameter("password"),
          "CUSTOMER"
  );

  resp.sendRedirect(
          ok ? "login.jsp?registered=1" : "register.jsp?error=1"
  );
 }
}
