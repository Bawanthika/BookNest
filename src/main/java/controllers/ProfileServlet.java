package controllers;

import dao.OrderDAO;
import dao.ReviewDAO;
import dao.UserDAO;
import models.User;
import utils.AuthUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private Integer customerId(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        Integer userId = AuthUtil.userId(request);

        if (userId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return null;
        }

        // Admin must never open the customer profile page.
        if (AuthUtil.isAdmin(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/dashboard"
            );
            return null;
        }

        return userId;
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        Integer userId = customerId(request, response);

        if (userId == null) {
            return;
        }

        User user = new UserDAO().byId(userId);

        request.setAttribute("user", user);
        request.setAttribute(
                "orderCount",
                new OrderDAO().countByUser(userId)
        );
        request.setAttribute(
                "reviewCount",
                new ReviewDAO().countByUser(userId)
        );

        request.getRequestDispatcher(
                "/customer/profile.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        Integer userId = customerId(request, response);

        if (userId == null) {
            return;
        }

        UserDAO dao = new UserDAO();
        String action = request.getParameter("action");

        boolean ok = false;

        if ("updateProfile".equals(action)) {

            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");

            ok = dao.updateProfile(
                    userId,
                    fullName,
                    email
            );

            if (ok) {
                request.getSession()
                        .setAttribute(
                                "userName",
                                fullName.trim()
                        );
            }

        } else if ("changePassword".equals(action)) {

            String newPassword =
                    request.getParameter("newPassword");

            String confirmPassword =
                    request.getParameter("confirmPassword");

            if (
                    newPassword != null
                            &&
                            newPassword.equals(confirmPassword)
            ) {

                ok = dao.changePassword(
                        userId,
                        request.getParameter("currentPassword"),
                        newPassword
                );
            }
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/profile?"
                        + (ok ? "success=1" : "error=1")
        );
    }
}
