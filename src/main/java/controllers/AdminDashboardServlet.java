package controllers;

import dao.*;
import utils.AuthUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AuthUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        UserDAO userDAO = new UserDAO();
        BookDAO bookDAO = new BookDAO();
        OrderDAO orderDAO = new OrderDAO();
        ReviewDAO reviewDAO = new ReviewDAO();

        request.setAttribute("customerCount", userDAO.countCustomers());
        request.setAttribute("bookCount", bookDAO.countBooks());
        request.setAttribute("orderCount", orderDAO.countOrders());
        request.setAttribute("pendingCount", orderDAO.countPendingOrders());
        request.setAttribute("reviewCount", reviewDAO.all().size());
        request.setAttribute("revenue", orderDAO.totalRevenue());
        request.setAttribute("recentOrders", orderDAO.recentOrders());
        request.setAttribute("lowStockBooks", bookDAO.lowStockBooks());

        // Phase 2 analytics
        request.setAttribute("statusCounts", orderDAO.orderStatusCounts());
        request.setAttribute("monthlyRevenue", orderDAO.monthlyRevenue());
        request.setAttribute("bestSellingBooks", orderDAO.bestSellingBooks());

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
