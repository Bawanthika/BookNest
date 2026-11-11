package controllers;
import dao.CategoryDAO; import utils.AuthUtil; import jakarta.servlet.*; import jakarta.servlet.annotation.WebServlet; import jakarta.servlet.http.*; import java.io.IOException;
@WebServlet("/admin/categories") public class CategoryServlet extends HttpServlet {
 private boolean g(HttpServletRequest r,HttpServletResponse p)throws IOException{if(!AuthUtil.isAdmin(r)){p.sendRedirect(r.getContextPath()+"/login.jsp");return false;}return true;}
 protected void doGet(HttpServletRequest r,HttpServletResponse p)throws ServletException,IOException{if(!g(r,p))return;r.setAttribute("categories",new CategoryDAO().all());r.getRequestDispatcher("/admin/categories.jsp").forward(r,p);}
 protected void doPost(HttpServletRequest r,HttpServletResponse p)throws IOException{if(!g(r,p))return;CategoryDAO d=new CategoryDAO();String a=r.getParameter("action");if("create".equals(a))d.create(r.getParameter("name"),r.getParameter("description"));else if("update".equals(a))d.update(Integer.parseInt(r.getParameter("id")),r.getParameter("name"),r.getParameter("description"));else if("delete".equals(a))d.delete(Integer.parseInt(r.getParameter("id")));p.sendRedirect(r.getContextPath()+"/admin/categories");}
}
