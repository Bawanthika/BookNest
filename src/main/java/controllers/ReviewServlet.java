package controllers;

import dao.BookDAO;
import dao.ReviewDAO;
import utils.AuthUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/reviews")
public class ReviewServlet extends HttpServlet {

 @Override
 protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {

  Integer userId = AuthUtil.userId(request);

  if (userId == null) {
   response.sendRedirect(request.getContextPath() + "/login.jsp");
   return;
  }

  ReviewDAO reviewDAO = new ReviewDAO();

  if (AuthUtil.isAdmin(request)) {
   request.setAttribute("reviews", reviewDAO.all());
   request.setAttribute("pendingCount", reviewDAO.countPending());
   request.setAttribute("approvedCount", reviewDAO.countApproved());

   request.getRequestDispatcher("/admin/reviews.jsp")
           .forward(request, response);
   return;
  }

  request.setAttribute("books", new BookDAO().all());
  request.setAttribute("reviews", reviewDAO.byUser(userId));

  request.getRequestDispatcher("/customer/reviews.jsp")
          .forward(request, response);
 }

 @Override
 protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws IOException {

  Integer userId = AuthUtil.userId(request);

  if (userId == null) {
   response.sendRedirect(request.getContextPath() + "/login.jsp");
   return;
  }

  ReviewDAO dao = new ReviewDAO();
  String action = request.getParameter("action");

  boolean ok = false;
  String message = "Action could not be completed.";

  try {

   if (AuthUtil.isAdmin(request)) {

    int id = Integer.parseInt(request.getParameter("id"));

    if ("approve".equals(action)) {

     ok = dao.approve(id);
     message = ok
             ? "Review approved successfully."
             : "Could not approve the review.";

    } else if ("pending".equals(action)) {

     ok = dao.setPending(id);
     message = ok
             ? "Review moved back to pending."
             : "Could not change the review status.";

    } else if ("update".equals(action)) {

     int rating = Integer.parseInt(request.getParameter("rating"));
     String comment = request.getParameter("comment");
     boolean approved = "on".equals(request.getParameter("approved"));

     ok = dao.update(id, rating, comment, approved);
     message = ok
             ? "Review updated successfully."
             : "Review update failed.";

    } else if ("delete".equals(action)) {

     ok = dao.delete(id);
     message = ok
             ? "Review deleted successfully."
             : "Review delete failed.";
    }

   } else {

    if ("create".equals(action)) {

     int bookId = Integer.parseInt(request.getParameter("bookId"));
     int rating = Integer.parseInt(request.getParameter("rating"));
     String comment = request.getParameter("comment");

     ok = dao.create(userId, bookId, rating, comment);

     message = ok
             ? "Review submitted successfully and is waiting for admin approval."
             : "Could not submit review.";

    } else if ("update".equals(action)) {

     int id = Integer.parseInt(request.getParameter("id"));
     int rating = Integer.parseInt(request.getParameter("rating"));
     String comment = request.getParameter("comment");

     ok = dao.updateByUser(id, userId, rating, comment);

     message = ok
             ? "Review updated. It is waiting for admin approval again."
             : "Could not update review.";

    } else if ("delete".equals(action)) {

     int id = Integer.parseInt(request.getParameter("id"));

     ok = dao.deleteByUser(id, userId);

     message = ok
             ? "Review deleted successfully."
             : "Could not delete review.";
    }
   }

  } catch (Exception e) {

   e.printStackTrace();

   ok = false;
   message = "Invalid review information.";
  }

  String encodedMessage =
          URLEncoder.encode(message, StandardCharsets.UTF_8);

  response.sendRedirect(
          request.getContextPath()
                  + "/reviews?ok="
                  + (ok ? "1" : "0")
                  + "&msg="
                  + encodedMessage
  );
 }
}
