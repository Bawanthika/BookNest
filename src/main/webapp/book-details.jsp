<%@ page import="java.util.*,models.Book,models.Review" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Book b = (Book) request.getAttribute("book");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    Double avg = (Double) request.getAttribute("averageRating");
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title><%=b.getTitle()%> | BookNest</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
</head>
<body>
<nav class="nav">
    <a class="brand" href="<%=request.getContextPath()%>/catalog">Book<span>Nest</span></a>
    <div class="navlinks">
        <a href="<%=request.getContextPath()%>/catalog">Store</a>
        <% if(session.getAttribute("userId")!=null){ %>
        <% if(!"ADMIN".equals(session.getAttribute("userRole"))){ %>
        <a href="<%=request.getContextPath()%>/orders">My Orders</a>
        <a href="<%=request.getContextPath()%>/reviews">Reviews</a>
        <a href="<%=request.getContextPath()%>/profile">Profile</a>
        <% } else { %>
        <a href="<%=request.getContextPath()%>/admin/dashboard">Admin</a>
        <% } %>
        <a class="btn btn-light" href="<%=request.getContextPath()%>/logout">Logout</a>
        <% } else { %>
        <a href="<%=request.getContextPath()%>/login.jsp">Login</a>
        <a class="btn primary" href="<%=request.getContextPath()%>/register.jsp">Register</a>
        <% } %>
    </div>
</nav>

<main class="container">
    <a class="back-link" href="<%=request.getContextPath()%>/catalog">← Back to Store</a>

    <section class="book-detail-shell">
        <div class="book-detail-cover">
            <% if(b.getImageUrl()!=null && !b.getImageUrl().trim().isEmpty()){ %>
            <img src="<%=b.getImageUrl()%>" alt="<%=b.getTitle()%> cover" onerror="this.style.display='none';this.nextElementSibling.style.display='grid';">
            <div class="detail-cover-fallback" style="display:none;">📚</div>
            <% } else { %>
            <div class="detail-cover-fallback">📚</div>
            <% } %>
        </div>

        <div class="book-detail-content">
            <div class="detail-badges">
                <span class="format-badge-static"><%=b.getFormat()%></span>
                <span class="category-badge"><%=b.getCategoryName()%></span>
            </div>
            <h1><%=b.getTitle()%></h1>
            <p class="detail-author">by <strong><%=b.getAuthorName()%></strong></p>

            <div class="detail-rating">
                <span class="stars">★★★★★</span>
                <strong><%=String.format("%.1f", avg == null ? 0 : avg)%></strong>
                <span class="muted">(<%=reviews == null ? 0 : reviews.size()%> approved reviews)</span>
            </div>

            <p class="detail-description"><%=b.getDescription()==null || b.getDescription().trim().isEmpty() ? "No description available for this title." : b.getDescription()%></p>

            <div class="detail-meta-grid">
                <div><span>ISBN</span><strong><%=b.getIsbn()%></strong></div>
                <div><span>Format</span><strong><%=b.getFormat()%></strong></div>
                <div><span>Stock</span><strong><%=b.getStock()%></strong></div>
                <div><span>Delivery</span><strong>Rs. <%=b.getDeliveryFee()%></strong></div>
            </div>

            <div class="detail-purchase-row">
                <div>
                    <span class="price-label">Price</span>
                    <div class="detail-price">Rs. <%=b.getPrice()%></div>
                </div>

                <% if(session.getAttribute("userId")!=null && !"ADMIN".equals(session.getAttribute("userRole")) && b.getStock()>0){ %>
                <form class="detail-buy-form" action="<%=request.getContextPath()%>/orders" method="post">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="bookId" value="<%=b.getId()%>">
                    <input type="number" name="quantity" value="1" min="1" max="<%=b.getStock()%>" required>
                    <button class="btn primary">Buy Now</button>
                </form>
                <% } else if(session.getAttribute("userId")==null) { %>
                <a class="btn primary" href="<%=request.getContextPath()%>/login.jsp">Login to Buy</a>
                <% } %>
            </div>
        </div>
    </section>

    <section class="detail-review-section">
        <div class="section-title">
            <div>
                <span class="small-label">BOOK REVIEWS</span>
                <h2>What readers say</h2>
            </div>
        </div>

        <div class="review-grid">
            <% if(reviews != null && !reviews.isEmpty()) { for(Review v: reviews) { %>
            <article class="review-card">
                <div class="review-stars">
                    <% for(int i=1;i<=5;i++){ %><span class="<%=i<=v.getRating()?"":"empty-star"%>">★</span><% } %>
                </div>
                <p class="review-comment"><%=v.getComment()%></p>
                <div class="review-footer">
                    <div class="avatar"><%=v.getUserName()!=null&&!v.getUserName().isEmpty()?v.getUserName().substring(0,1).toUpperCase():"U"%></div>
                    <div><strong><%=v.getUserName()%></strong><small>BookNest reader</small></div>
                </div>
            </article>
            <% }} else { %>
            <div class="dashboard-empty">No approved reviews for this book yet.</div>
            <% } %>
        </div>
    </section>
</main>
</body>
</html>
