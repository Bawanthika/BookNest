package controllers.auth;
import jakarta.servlet.annotation.WebServlet; import jakarta.servlet.http.*; import java.io.IOException;
@WebServlet("/logout") public class LogoutServlet extends HttpServlet {protected void doGet(HttpServletRequest r,HttpServletResponse p)throws IOException{HttpSession s=r.getSession(false);if(s!=null)s.invalidate();p.sendRedirect("catalog");}}
