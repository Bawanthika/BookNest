<%@ page import="java.util.*,models.Book,models.Review" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    private String esc(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>
<%
    String ctx = request.getContextPath();
    boolean loggedIn = session.getAttribute("userId") != null;
    boolean adminUser = "ADMIN".equals(session.getAttribute("userRole"));
    List<Book> books = (List<Book>) request.getAttribute("books");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    int bookCount = books == null ? 0 : books.size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#17152b">
    <title>BookNest | Discover Your Next Favourite Book</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=ctx%>/assets/css/style.css">
    <style>
        :root{--bn-ink:#17152b;--bn-muted:#77768b;--bn-purple:#7046f5;--bn-purple2:#8c65ff;--bn-lilac:#f1edff;--bn-line:#e9e7f1;--bn-bg:#f8f8fc;--bn-white:#fff;--bn-shadow:0 18px 45px rgba(29,23,65,.08)}
        *{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;background:var(--bn-bg);color:var(--bn-ink);font-family:'DM Sans',sans-serif}a{text-decoration:none}
        .bn-nav{height:76px;padding:0 max(5.5%,calc((100% - 1320px)/2));display:flex;align-items:center;justify-content:space-between;background:rgba(255,255,255,.96);border-bottom:1px solid var(--bn-line);position:sticky;top:0;z-index:50;backdrop-filter:blur(14px)}
        .bn-brand{font:800 25px 'Manrope',sans-serif;letter-spacing:-1.2px;color:var(--bn-ink)}.bn-brand span{color:var(--bn-purple)}.bn-navlinks{display:flex;align-items:center;gap:27px}.bn-navlinks a{font-size:13px;font-weight:700;color:#555469;transition:.2s}.bn-navlinks a:hover{color:var(--bn-purple)}.bn-navlinks .bn-login{padding:11px 17px;border-radius:12px;background:#f2f0f8}.bn-navlinks .bn-register{padding:12px 19px;border-radius:12px;background:var(--bn-purple);color:#fff;box-shadow:0 8px 18px #7046f533}
        .bn-hero{position:relative;overflow:hidden;min-height:440px;background:radial-gradient(circle at 82% 42%,#5631b5 0,transparent 31%),linear-gradient(112deg,#17152b 0%,#251b52 58%,#5530ae 100%);color:#fff;display:grid;grid-template-columns:1.08fr .92fr;align-items:center;padding:65px max(8%,calc((100% - 1260px)/2));gap:35px}
        .bn-hero:before,.bn-hero:after{content:"";position:absolute;border:1px solid #ffffff13;border-radius:50%;pointer-events:none}.bn-hero:before{width:500px;height:500px;right:-120px;top:-250px}.bn-hero:after{width:360px;height:360px;right:6%;bottom:-260px}
        .bn-eyebrow{display:inline-flex;align-items:center;gap:8px;padding:8px 13px;border:1px solid #ffffff35;border-radius:30px;background:#ffffff12;color:#e9ddff;font-size:11px;font-weight:800;letter-spacing:.6px}.bn-eyebrow i{width:7px;height:7px;background:#b8a0ff;border-radius:50%;display:inline-block}.bn-hero h1{font:800 clamp(38px,5vw,64px)/1.08 'Manrope',sans-serif;letter-spacing:-2.7px;margin:22px 0 18px;max-width:650px}.bn-hero h1 span{color:#c6b4ff}.bn-hero p{font-size:15px;line-height:1.85;color:#d7d1ee;max-width:535px;margin:0}.bn-hero-actions{display:flex;gap:12px;margin-top:28px;flex-wrap:wrap}.bn-btn{border:0;display:inline-flex;align-items:center;justify-content:center;gap:8px;border-radius:12px;padding:13px 20px;font:700 13px 'DM Sans',sans-serif;cursor:pointer;transition:transform .2s,box-shadow .2s}.bn-btn:hover{transform:translateY(-2px)}.bn-btn-primary{background:linear-gradient(135deg,#8b5cff,#6b3df0);color:#fff;box-shadow:0 10px 22px #5424d94d}.bn-btn-outline{border:1px solid #ffffff4a;color:#fff;background:#ffffff0c}
        .bn-hero-art{height:285px;position:relative;display:flex;align-items:center;justify-content:center}.bn-orbit{position:absolute;width:300px;height:230px;border:1px solid #ffffff22;border-radius:50%;transform:rotate(-17deg)}.bn-book{position:absolute;width:132px;height:178px;border-radius:12px 15px 15px 12px;box-shadow:0 25px 45px #08051c55;display:flex;align-items:center;justify-content:center;border-left:8px solid #ffffff25}.bn-book:after{content:"";position:absolute;left:17px;right:17px;bottom:25px;height:3px;background:#ffffff77;border-radius:4px}.bn-book b{font:800 17px 'Manrope';text-align:center;color:#fff;max-width:90px;line-height:1.2}.bn-book-one{background:linear-gradient(145deg,#7752f4,#4e2db7);transform:translate(-85px,5px) rotate(-13deg)}.bn-book-two{background:linear-gradient(145deg,#ff8a56,#ed4f7a);z-index:2;transform:translate(0,-22px) rotate(2deg)}.bn-book-three{background:linear-gradient(145deg,#20c79a,#078b83);transform:translate(85px,7px) rotate(13deg)}.bn-art-note{position:absolute;bottom:2px;z-index:4;padding:13px 18px;background:#ffffff20;border:1px solid #ffffff35;border-radius:13px;backdrop-filter:blur(12px);box-shadow:0 12px 28px #09051b33}.bn-art-note strong{display:block;font-size:12px}.bn-art-note span{display:block;color:#e4ddff;font-size:10px;margin-top:4px}
        .bn-main{max-width:1260px;margin:0 auto;padding:58px 24px 75px}.bn-section-head{display:flex;align-items:flex-end;justify-content:space-between;gap:20px;margin-bottom:22px}.bn-kicker{font-size:10px;font-weight:800;letter-spacing:2px;color:var(--bn-purple)}.bn-section-head h2,.bn-review-head h2{font:800 29px 'Manrope',sans-serif;letter-spacing:-.8px;margin:8px 0 7px}.bn-section-head p,.bn-review-head p{color:var(--bn-muted);font-size:13px;margin:0}.bn-count{padding:9px 13px;background:#fff;border:1px solid var(--bn-line);border-radius:30px;font-size:11px;color:#656276;font-weight:700;white-space:nowrap}
        .bn-toolbar{display:grid;grid-template-columns:minmax(220px,1fr) 190px 190px;gap:10px;margin:25px 0 14px}.bn-search{position:relative}.bn-search span{position:absolute;left:16px;top:50%;transform:translateY(-50%);font-size:16px;color:#888}.bn-toolbar input,.bn-toolbar select{width:100%;height:48px;border:1px solid #e2dfec;border-radius:12px;background:#fff;color:#3d3a50;font:500 12px 'DM Sans';outline:none;padding:0 15px}.bn-toolbar input{padding-left:44px}.bn-toolbar input:focus,.bn-toolbar select:focus{border-color:#9a80ff;box-shadow:0 0 0 3px #7046f51a}
        .bn-delivery{display:flex;align-items:center;gap:13px;padding:14px 17px;background:linear-gradient(100deg,#f2efff,#faf9ff);border:1px solid #e2d9ff;border-radius:13px;margin-bottom:22px}.bn-delivery-icon{width:38px;height:38px;display:grid;place-items:center;background:#fff;border-radius:11px;font-size:19px}.bn-delivery strong{font-size:12px}.bn-delivery p{font-size:10px;color:#77728c;margin:4px 0 0}
        .bn-books{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:20px}
        .bn-card{overflow:hidden;background:#fff;border:1px solid var(--bn-line);border-radius:18px;box-shadow:0 8px 25px rgba(29,23,65,.035);transition:transform .25s,box-shadow .25s}
        .bn-card:hover{transform:translateY(-5px);box-shadow:var(--bn-shadow)}
        .bn-cover{height:220px;position:relative;display:flex;align-items:center;justify-content:center;overflow:hidden;background:linear-gradient(135deg,#f0eaff,#e4dcff)}
        .bn-cover:before{content:"";position:absolute;width:190px;height:190px;border-radius:50%;background:#ffffff5c;right:-50px;bottom:-105px}
        .bn-cover img{
            display:block;
            position:relative;
            z-index:1;
            width:auto;
            height:auto;
            max-width:min(78%, 170px);
            max-height:190px;
            object-fit:contain;
            object-position:center;
            filter:drop-shadow(0 12px 14px #30205a28);
            transition:transform .25s ease;
        }
        .bn-card:hover .bn-cover img{transform:scale(1.04)}
        .bn-cover-placeholder{font-size:65px;filter:drop-shadow(0 10px 12px #4a368c24);z-index:1}
        .bn-format,.bn-stock{position:absolute;top:13px;z-index:3;padding:6px 9px;border-radius:20px;background:#fff;font-size:9px;font-weight:800;letter-spacing:.3px}
        .bn-format{left:13px;color:var(--bn-purple)}
        .bn-stock{right:13px;color:#07865b;background:#e3fff3}
        .bn-stock.out{color:#b33b4d;background:#fff0f1}
        .bn-card-body{padding:18px}
        .bn-category{font-size:9px;font-weight:800;letter-spacing:1.1px;text-transform:uppercase;color:var(--bn-purple);margin:0 0 8px}
        .bn-card h3{font:800 17px 'Manrope';letter-spacing:-.3px;line-height:1.35;margin:0 0 7px;color:var(--bn-ink)}
        .bn-author{font-size:11px;color:#77768b;margin:0 0 12px}
        .bn-author strong{color:#4e4a62}
        .bn-description{font-size:11px;line-height:1.65;color:#858297;min-height:37px;margin:0 0 16px;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
        .bn-card-meta{display:flex;align-items:flex-end;justify-content:space-between;padding:13px 0;border-top:1px solid #f0eef5}
        .bn-price-label,.bn-stock-label{font-size:9px;color:#9995a8;display:block;margin-bottom:5px}
        .bn-price{font:800 17px 'Manrope';color:var(--bn-purple)}
        .bn-stock-number{font:800 13px 'Manrope';text-align:right;display:block}
        .bn-detail-link{width:100%;height:42px;border:1px solid #ded5ff;border-radius:10px;background:#f5f2ff;color:#6741e8;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:800;transition:.2s}
        .bn-detail-link:hover{background:var(--bn-purple);color:#fff}
        .bn-buy-form{display:flex;gap:8px;align-items:center;margin-top:9px}
        .bn-qty{display:flex;align-items:center;gap:5px;color:#777;font-size:10px}
        .bn-qty input{width:52px;height:38px;border:1px solid var(--bn-line);border-radius:9px;padding:5px}
        .bn-buy{flex:1;height:38px;border-radius:9px;background:var(--bn-purple);color:#fff;font-size:11px;font-weight:800}
        .bn-login-buy,.bn-disabled{display:flex;width:100%;height:38px;align-items:center;justify-content:center;border-radius:9px;margin-top:9px;font-size:11px;font-weight:800}
        .bn-login-buy{background:var(--bn-purple);color:#fff}
        .bn-disabled{background:#f1f0f5;color:#999}
        .bn-empty{grid-column:1/-1;text-align:center;background:#fff;border:1px dashed #d9d3ea;border-radius:18px;padding:48px 20px;color:#777}.bn-empty span{font-size:42px}.bn-empty h3{font:800 18px 'Manrope';color:var(--bn-ink);margin:12px 0 5px}.bn-empty p{font-size:12px;margin:0}.bn-no-results{text-align:center;padding:40px 15px;color:#777}.bn-no-results strong{display:block;color:var(--bn-ink);font:800 17px 'Manrope';margin:8px 0}
        .bn-reviews{margin-top:72px;padding-top:45px;border-top:1px solid var(--bn-line)}.bn-review-head{margin-bottom:22px}.bn-review-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:16px}.bn-review-card{position:relative;padding:22px;background:#fff;border:1px solid var(--bn-line);border-radius:16px;box-shadow:0 8px 24px #21164b08}.bn-quote{position:absolute;right:17px;top:5px;font:800 45px Georgia;color:#eee8ff}.bn-stars{color:#f3a51a;letter-spacing:2px;font-size:13px}.bn-stars .empty{color:#e6e3ec}.bn-review-comment{font-size:12px;line-height:1.7;color:#5f5b70;min-height:40px;margin:14px 0 18px}.bn-review-footer{display:flex;align-items:center;gap:10px}.bn-avatar{width:34px;height:34px;border-radius:50%;display:grid;place-items:center;background:#eee8ff;color:var(--bn-purple);font-weight:800;font-size:12px}.bn-review-footer strong{display:block;font-size:11px}.bn-review-footer small{display:block;font-size:9px;color:#9691a6;margin-top:3px}
        .bn-footer{background:#171629;color:#fff;padding:48px max(6%,calc((100% - 1260px)/2)) 20px}.bn-footer-grid{display:grid;grid-template-columns:2fr 1fr 1fr;gap:50px;padding-bottom:35px}.bn-footer .bn-brand{color:#fff;font-size:23px}.bn-footer p{font-size:12px;line-height:1.8;color:#b8b5ca;max-width:300px}.bn-footer h4{font-size:12px;margin:4px 0 15px}.bn-footer a:not(.bn-brand){display:block;color:#c4c1d4;font-size:11px;margin:10px 0}.bn-footer a:hover{color:#fff}.bn-footer-bottom{border-top:1px solid #ffffff19;padding-top:18px;text-align:center;color:#9692aa;font-size:10px}
        @media(max-width:900px){.bn-hero{padding:55px 6%;grid-template-columns:1fr .8fr}.bn-hero-art{transform:scale(.85)}.bn-books{grid-template-columns:repeat(2,minmax(0,1fr))}.bn-review-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}
        @media(max-width:640px){.bn-cover img{max-width:72%;max-height:190px}.bn-nav{height:auto;min-height:66px;padding:13px 18px;align-items:flex-start;gap:12px;flex-direction:column}.bn-navlinks{width:100%;gap:17px;overflow-x:auto;padding-bottom:3px}.bn-navlinks a{white-space:nowrap;font-size:11px}.bn-brand{font-size:23px}.bn-hero{display:block;padding:48px 23px 28px;min-height:0}.bn-hero h1{font-size:42px;letter-spacing:-1.8px}.bn-hero p{font-size:13px}.bn-hero-art{height:220px;margin-top:20px;transform:scale(.8)}.bn-main{padding:42px 16px 55px}.bn-section-head{align-items:flex-start}.bn-section-head h2,.bn-review-head h2{font-size:25px}.bn-toolbar{grid-template-columns:1fr 1fr}.bn-search{grid-column:1/-1}.bn-books{grid-template-columns:1fr;gap:14px}.bn-cover{height:220px}.bn-card-body{padding:17px}.bn-review-grid{grid-template-columns:1fr}.bn-footer{padding:38px 22px 18px}.bn-footer-grid{grid-template-columns:1fr 1fr;gap:25px}.bn-footer-grid>div:first-child{grid-column:1/-1}}
        @media(prefers-reduced-motion:reduce){*,*:before,*:after{scroll-behavior:auto!important;transition:none!important}}
    </style>
</head>
<body>
<nav class="bn-nav">
    <a class="bn-brand" href="<%=ctx%>/catalog">Book<span>Nest</span></a>
    <div class="bn-navlinks">
        <a href="<%=ctx%>/catalog">Store</a>
        <% if (loggedIn) { %>
        <% if (adminUser) { %>
        <a href="<%=ctx%>/admin/dashboard">Dashboard</a>
        <a href="<%=ctx%>/orders">Orders</a>
        <a href="<%=ctx%>/reviews">Reviews</a>
        <% } else { %>
        <a href="<%=ctx%>/orders">My Orders</a>
        <a href="<%=ctx%>/reviews">Reviews</a>
        <a href="<%=ctx%>/profile">Profile</a>
        <% } %>
        <a class="bn-login" href="<%=ctx%>/logout">Logout</a>
        <% } else { %>
        <a href="<%=ctx%>/login.jsp">Login</a>
        <a class="bn-register" href="<%=ctx%>/register.jsp">Create Account</a>
        <% } %>
    </div>
</nav>

<header class="bn-hero">
    <div>
        <span class="bn-eyebrow"><i></i> YOUR NEXT CHAPTER STARTS HERE</span>
        <h1>Find a book<br>you'll <span>love to read.</span></h1>
        <p>Explore thoughtful reads, discover inspiring authors and find your next favourite book — all in one place.</p>
        <div class="bn-hero-actions">
            <a class="bn-btn bn-btn-primary" href="#catalog">Explore the Collection <span aria-hidden="true">→</span></a>
            <% if (!loggedIn) { %><a class="bn-btn bn-btn-outline" href="<%=ctx%>/register.jsp">Join BookNest</a><% } %>
        </div>
    </div>
    <div class="bn-hero-art" aria-label="Colourful illustrated books">
        <div class="bn-orbit"></div>
        <div class="bn-book bn-book-one"><b>Stories<br>to Explore</b></div>
        <div class="bn-book bn-book-two"><b>Find Your<br>Next Chapter</b></div>
        <div class="bn-book bn-book-three"><b>Ideas<br>That Grow</b></div>
        <div class="bn-art-note"><strong>Discover. Read. Enjoy.</strong><span>Your next favourite book is waiting.</span></div>
    </div>
</header>

<main class="bn-main" id="catalog">
    <div class="bn-section-head">
        <div><span class="bn-kicker">THE BOOKNEST COLLECTION</span><h2>Explore Books</h2><p>Find a great read from our growing collection.</p></div>
        <span class="bn-count"><%=bookCount%> books in collection</span>
    </div>

    <section class="bn-toolbar" aria-label="Book search and filters">
        <div class="bn-search"><span aria-hidden="true">⌕</span><input type="search" id="bookSearch" placeholder="Search by title, author or category..." oninput="filterBooks()" aria-label="Search books"></div>
        <select id="categoryFilter" onchange="filterBooks()" aria-label="Filter by category"><option value="">All Categories</option></select>
        <select id="sortBooks" onchange="sortBooks()" aria-label="Sort books"><option value="default">Sort By</option><option value="low">Price: Low to High</option><option value="high">Price: High to Low</option><option value="az">Title: A - Z</option></select>
    </section>

    <div class="bn-delivery"><div class="bn-delivery-icon">🚚</div><div><strong>Delivery information</strong><p>Printed books include a Rs. 350 delivery fee. eBooks have no delivery fee.</p></div></div>

    <section class="bn-books" id="bookGrid" aria-label="Available books">
        <% if (books != null && !books.isEmpty()) { for (Book b : books) {
            String title = b.getTitle() == null ? "Untitled" : b.getTitle();
            String author = b.getAuthorName() == null ? "" : b.getAuthorName();
            String category = b.getCategoryName() == null ? "" : b.getCategoryName();
            String description = b.getDescription() == null ? "" : b.getDescription();
            String format = b.getFormat() == null ? "BOOK" : String.valueOf(b.getFormat());
            String imageUrl = b.getImageUrl() == null ? "" : b.getImageUrl().trim();
            String isbn = b.getIsbn() == null ? "" : b.getIsbn().replaceAll("[^0-9Xx]", "");
            String coverUrl = imageUrl;
            if (coverUrl.isEmpty() && !isbn.isEmpty()) {
                coverUrl = "https://covers.openlibrary.org/b/isbn/" + isbn + "-L.jpg";
            }
        %>
        <article class="bn-card book-card" data-title="<%=esc(title.toLowerCase(Locale.ROOT))%>" data-author="<%=esc(author.toLowerCase(Locale.ROOT))%>" data-category="<%=esc(category.toLowerCase(Locale.ROOT))%>" data-category-original="<%=esc(category)%>" data-price="<%=b.getPrice()%>">
            <div class="bn-cover">
                <span class="bn-format"><%=esc(format)%></span>
                <% if (b.getStock() > 0) { %><span class="bn-stock">In Stock</span><% } else { %><span class="bn-stock out">Out of Stock</span><% } %>
                <% if (!coverUrl.isEmpty()) { %>
                <img
                        src="<%=esc(coverUrl)%>"
                        alt="<%=esc(title)%> book cover"
                        loading="lazy"
                        decoding="async"
                        onerror="this.onerror=null;this.style.display='none';this.nextElementSibling.style.display='block';">
                <span class="bn-cover-placeholder" style="display:none" aria-hidden="true">📚</span>
                <% } else { %>
                <span class="bn-cover-placeholder" aria-hidden="true">📚</span>
                <% } %>
            </div>
            <div class="bn-card-body">
                <p class="bn-category"><%=esc(category.isEmpty() ? "Featured book" : category)%></p>
                <h3><%=esc(title)%></h3>
                <p class="bn-author">by <strong><%=esc(author.isEmpty() ? "Unknown author" : author)%></strong></p>
                <p class="bn-description"><%=esc(description)%></p>
                <div class="bn-card-meta"><div><span class="bn-price-label">PRICE</span><span class="bn-price">Rs. <%=String.format(Locale.US, "%,.2f", b.getPrice())%></span></div><div><span class="bn-stock-label">AVAILABLE</span><span class="bn-stock-number"><%=b.getStock()%></span></div></div>
                <a class="bn-detail-link" href="<%=ctx%>/book?id=<%=b.getId()%>">View Book Details <span aria-hidden="true">→</span></a>
                <% if (loggedIn && !adminUser) { %>
                <% if (b.getStock() > 0) { %>
                <form class="bn-buy-form" action="<%=ctx%>/orders" method="post">
                    <input type="hidden" name="action" value="create"><input type="hidden" name="bookId" value="<%=b.getId()%>">
                    <label class="bn-qty">Qty <input type="number" name="quantity" min="1" max="<%=b.getStock()%>" value="1" required></label>
                    <button class="bn-btn bn-buy" type="submit">Buy Now</button>
                </form>
                <% } else { %><button class="bn-disabled" type="button" disabled>Currently unavailable</button><% } %>
                <% } else if (!loggedIn) { %>
                <a class="bn-login-buy" href="<%=ctx%>/login.jsp">Login to Buy</a>
                <% } %>
            </div>
        </article>
        <% } } else { %>
        <div class="bn-empty"><span>📚</span><h3>Your next read is on its way</h3><p>There are no books available to display right now.</p></div>
        <% } %>
    </section>
    <div id="noSearchResult" class="bn-no-results" style="display:none"><span aria-hidden="true">⌕</span><strong>No books found</strong><span>Try a different title, author or category.</span></div>

    <section class="bn-reviews">
        <div class="bn-review-head"><span class="bn-kicker">READER COMMUNITY</span><h2>Words from our readers</h2><p>See what the BookNest community is saying.</p></div>
        <div class="bn-review-grid">
            <% if (reviews != null && !reviews.isEmpty()) { for (Review r : reviews) {
                String userName = r.getUserName() == null ? "Reader" : r.getUserName();
                String comment = r.getComment() == null ? "" : r.getComment();
                String bookTitle = r.getBookTitle() == null ? "a book" : r.getBookTitle();
                String avatar = userName.trim().isEmpty() ? "R" : userName.trim().substring(0,1).toUpperCase(Locale.ROOT);
            %>
            <article class="bn-review-card"><span class="bn-quote" aria-hidden="true">“</span><div class="bn-stars" aria-label="<%=r.getRating()%> out of 5 stars"><% for(int i=1;i<=5;i++){ %><span class="<%=i > r.getRating() ? "empty" : ""%>">★</span><% } %></div><p class="bn-review-comment"><%=esc(comment)%></p><div class="bn-review-footer"><div class="bn-avatar"><%=esc(avatar)%></div><div><strong><%=esc(userName)%></strong><small>Reviewed <%=esc(bookTitle)%></small></div></div></article>
            <% } } else { %><div class="bn-empty"><span>💬</span><h3>Be the first to share a review</h3><p>Reader reviews will appear here.</p></div><% } %>
        </div>
    </section>
</main>

<footer class="bn-footer">
    <div class="bn-footer-grid">
        <div><a class="bn-brand" href="<%=ctx%>/catalog">Book<span>Nest</span></a><p>A welcoming place to discover books, explore new ideas and enjoy your reading journey.</p></div>
        <div><h4>Explore</h4><a href="<%=ctx%>/catalog">Store</a><% if(loggedIn){ %><a href="<%=ctx%>/orders">My Orders</a><a href="<%=ctx%>/reviews">Reviews</a><% } %></div>
        <div><h4>Your Account</h4><% if(!loggedIn){ %><a href="<%=ctx%>/login.jsp">Login</a><a href="<%=ctx%>/register.jsp">Create Account</a><% } else { %><a href="<%=ctx%>/logout">Logout</a><% } %></div>
    </div>
    <div class="bn-footer-bottom">© 2026 BookNest. All rights reserved.</div>
</footer>

<script>
    (function () {
        const cards = Array.from(document.querySelectorAll('.book-card'));
        const categorySelect = document.getElementById('categoryFilter');
        const searchInput = document.getElementById('bookSearch');
        const sortSelect = document.getElementById('sortBooks');
        const noResults = document.getElementById('noSearchResult');
        const grid = document.getElementById('bookGrid');

        const categories = [...new Set(cards.map(card => card.dataset.categoryOriginal).filter(Boolean))].sort((a,b) => a.localeCompare(b));
        categories.forEach(category => {
            const option = document.createElement('option');
            option.value = category.toLocaleLowerCase();
            option.textContent = category;
            categorySelect.appendChild(option);
        });

        window.filterBooks = function () {
            const query = searchInput.value.toLocaleLowerCase().trim();
            const selectedCategory = categorySelect.value.toLocaleLowerCase();
            let visibleCount = 0;
            cards.forEach(card => {
                const matchesText = (card.dataset.title || '').includes(query) || (card.dataset.author || '').includes(query) || (card.dataset.category || '').includes(query);
                const matchesCategory = !selectedCategory || (card.dataset.category || '') === selectedCategory;
                const visible = matchesText && matchesCategory;
                card.hidden = !visible;
                if (visible) visibleCount++;
            });
            noResults.style.display = visibleCount === 0 && cards.length > 0 ? 'block' : 'none';
        };

        const originalOrder = [...cards];

        window.sortBooks = function () {
            const mode = sortSelect.value;
            const sorted = [...originalOrder];

            if (mode === 'low') {
                sorted.sort((a, b) => Number(a.dataset.price) - Number(b.dataset.price));
            } else if (mode === 'high') {
                sorted.sort((a, b) => Number(b.dataset.price) - Number(a.dataset.price));
            } else if (mode === 'az') {
                sorted.sort((a, b) =>
                    (a.dataset.title || '').localeCompare(b.dataset.title || '')
                );
            }

            sorted.forEach(card => grid.appendChild(card));
            window.filterBooks();
        };
    })();
</script>
</body>
</html>
