package controllers;

import dao.BookDAO;
import dao.ReviewDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/catalog")
public class CatalogServlet extends HttpServlet {

 @Override
 protected void doGet(
         HttpServletRequest request,
         HttpServletResponse response
 ) throws ServletException, IOException {

  request.setAttribute(
          "books",
          new BookDAO().all()
  );

  request.setAttribute(
          "reviews",
          new ReviewDAO().approved()
  );

  request.getRequestDispatcher(
          "/index.jsp"
  ).forward(request, response);
 }
}