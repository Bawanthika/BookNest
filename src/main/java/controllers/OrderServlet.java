package controllers;

import dao.OrderDAO;
import utils.AuthUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {

 @Override
 protected void doGet(
         HttpServletRequest request,
         HttpServletResponse response
 ) throws ServletException, IOException {

  Integer userId = AuthUtil.userId(request);

  if (userId == null) {
   response.sendRedirect(
           request.getContextPath() + "/login.jsp"
   );
   return;
  }

  OrderDAO dao = new OrderDAO();

  if (AuthUtil.isAdmin(request)) {
   request.setAttribute("orders", dao.all());
   request.getRequestDispatcher(
           "/admin/orders.jsp"
   ).forward(request, response);

  } else {
   request.setAttribute(
           "orders",
           dao.byUser(userId)
   );
   request.getRequestDispatcher(
           "/customer/orders.jsp"
   ).forward(request, response);
  }
 }

 @Override
 protected void doPost(
         HttpServletRequest request,
         HttpServletResponse response
 ) throws IOException {

  Integer userId = AuthUtil.userId(request);

  if (userId == null) {
   response.sendRedirect(
           request.getContextPath() + "/login.jsp"
   );
   return;
  }

  OrderDAO dao = new OrderDAO();
  String action = request.getParameter("action");

  boolean success = false;
  String message = "Unable to process the request.";

  try {

   if ("create".equals(action)) {
    int bookId = Integer.parseInt(
            request.getParameter("bookId")
    );
    int quantity = Integer.parseInt(
            request.getParameter("quantity")
    );

    success = dao.create(
            userId,
            bookId,
            quantity
    );

    message = success
            ? "Order placed successfully."
            : "Unable to place order. Please check available stock.";
   }

   else if (
           AuthUtil.isAdmin(request)
                   && "update".equals(action)
   ) {
    int id = Integer.parseInt(
            request.getParameter("id")
    );
    int quantity = Integer.parseInt(
            request.getParameter("quantity")
    );
    String status =
            request.getParameter("status");

    success = dao.update(
            id,
            quantity,
            status
    );

    message = success
            ? "Order updated successfully."
            : "Order update failed. Check stock or order details.";
   }

   else if (
           AuthUtil.isAdmin(request)
                   && "delete".equals(action)
   ) {
    int id = Integer.parseInt(
            request.getParameter("id")
    );

    success = dao.delete(id);

    message = success
            ? "Order deleted successfully."
            : "Unable to delete order.";
   }

   else if ("customerUpdate".equals(action)) {
    int id = Integer.parseInt(
            request.getParameter("id")
    );
    int quantity = Integer.parseInt(
            request.getParameter("quantity")
    );

    success = dao.updateCustomerOrder(
            id,
            userId,
            quantity
    );

    message = success
            ? "Order quantity updated."
            : "Unable to update order. It may no longer be pending or stock may be insufficient.";
   }

   else if ("customerCancel".equals(action)) {
    int id = Integer.parseInt(
            request.getParameter("id")
    );

    success = dao.cancelCustomerOrder(
            id,
            userId
    );

    message = success
            ? "Order cancelled successfully."
            : "Unable to cancel order. Only pending orders can be cancelled.";
   }

  } catch (Exception e) {
   e.printStackTrace();
   success = false;
   message = "Something went wrong while processing the order.";
  }

  String target = request.getContextPath()
          + "/orders?ok="
          + (success ? "1" : "0")
          + "&msg="
          + URLEncoder.encode(
          message,
          StandardCharsets.UTF_8
  );

  response.sendRedirect(target);
 }
}
