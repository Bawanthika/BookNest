package controllers;

import dao.BookDAO;
import dao.ReviewDAO;
import models.Book;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/book")
public class BookDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id;
        try {
            id = Integer.parseInt(req.getParameter("id"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/catalog");
            return;
        }

        Book book = new BookDAO().byId(id);
        if (book == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        ReviewDAO reviewDAO = new ReviewDAO();
        req.setAttribute("book", book);
        req.setAttribute("reviews", reviewDAO.approvedByBook(id));
        req.setAttribute("averageRating", reviewDAO.averageRatingForBook(id));

        req.getRequestDispatcher("/book-details.jsp").forward(req, resp);
    }
}
