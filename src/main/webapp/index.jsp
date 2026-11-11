<%@ page import="java.util.*,models.Book,models.Review" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
    >

    <title>BookNest | Online Book Store</title>

    <link
            rel="stylesheet"
            href="<%=request.getContextPath()%>/assets/css/style.css"
    >

</head>

<body>


<!-- ================= NAVBAR ================= -->

<nav class="nav">

    <a
            class="brand"
            href="<%=request.getContextPath()%>/catalog"
    >
        Book<span>Nest</span>
    </a>


    <div class="navlinks">

        <a href="<%=request.getContextPath()%>/catalog">Store</a>

        <% if(session.getAttribute("userId") != null) { %>

        <% if("ADMIN".equals(session.getAttribute("userRole"))) { %>

        <a href="<%=request.getContextPath()%>/admin/dashboard">Dashboard</a>
        <a href="<%=request.getContextPath()%>/orders">Orders</a>
        <a href="<%=request.getContextPath()%>/reviews">Reviews</a>

        <% } else { %>

        <a href="<%=request.getContextPath()%>/orders">My Orders</a>
        <a href="<%=request.getContextPath()%>/reviews">Reviews</a>
        <a href="<%=request.getContextPath()%>/profile">Profile</a>

        <% } %>

        <a class="btn btn-light" href="<%=request.getContextPath()%>/logout">Logout</a>

        <% } else { %>

        <a href="<%=request.getContextPath()%>/login.jsp">Login</a>
        <a class="btn primary" href="<%=request.getContextPath()%>/register.jsp">Register</a>

        <% } %>

    </div>

</nav>



<!-- ================= HERO ================= -->

<section class="hero">

    <div class="hero-content">

        <span class="hero-label">
            Welcome to BookNest
        </span>

        <h1>
            Find a book you'll
            <span>love to read.</span>
        </h1>

        <p>
            Browse your favourite titles, discover new authors
            and order books easily from BookNest.
        </p>


        <div class="hero-actions">

            <a
                    class="btn primary hero-btn"
                    href="#catalog"
            >
                Browse Books
            </a>


            <% if(session.getAttribute("userId") == null) { %>

            <a
                    class="btn hero-outline"
                    href="<%=request.getContextPath()%>/register.jsp"
            >
                Create Account
            </a>

            <% } %>

        </div>

    </div>


    <div class="hero-showcase">

        <div class="hero-book hero-book-one">
            <span>📘</span>
        </div>

        <div class="hero-book hero-book-two">
            <span>📕</span>
        </div>

        <div class="hero-book hero-book-three">
            <span>📗</span>
        </div>

        <div class="hero-info">

            <strong>
                Discover. Read. Enjoy.
            </strong>

            <small>
                Your next favourite book is waiting.
            </small>

        </div>

    </div>

</section>



<!-- ================= MAIN ================= -->

<main
        class="container"
        id="catalog"
>


    <!-- ================= HEADING ================= -->

    <div class="catalog-heading">

        <div>

            <span class="small-label">
                OUR COLLECTION
            </span>

            <h2>
                Explore Books
            </h2>

            <p class="muted">
                Search and discover books from our growing collection.
            </p>

        </div>

    </div>



    <!-- ================= SEARCH / FILTER ================= -->

    <section class="book-toolbar">

        <div class="search-wrapper">

            <span class="search-icon">
                🔎
            </span>

            <input
                    type="text"
                    id="bookSearch"
                    placeholder="Search by title, author or category..."
                    onkeyup="filterBooks()"
            >

        </div>


        <select
                id="categoryFilter"
                onchange="filterBooks()"
        >

            <option value="">
                All Categories
            </option>

        </select>


        <select
                id="sortBooks"
                onchange="sortBooks()"
        >

            <option value="default">
                Sort By
            </option>

            <option value="low">
                Price: Low to High
            </option>

            <option value="high">
                Price: High to Low
            </option>

            <option value="az">
                Title: A - Z
            </option>

        </select>

    </section>



    <div class="delivery-message">

        <span>🚚</span>

        <div>

            <strong>
                Delivery Information
            </strong>

            <p>
                Printed books include a Rs. 350 delivery fee.
                eBooks have no delivery fee.
            </p>

        </div>

    </div>



    <!-- ================= BOOK GRID ================= -->

    <div
            class="books-grid"
            id="bookGrid"
    >

        <%
            List<Book> books =
                    (List<Book>) request.getAttribute("books");

            if (books != null && !books.isEmpty()) {

                for (Book b : books) {
        %>


        <article
                class="book-card"

                data-title="<%=b.getTitle().toLowerCase()%>"

                data-author="<%=b.getAuthorName() == null
                        ? ""
                        : b.getAuthorName().toLowerCase()%>"

                data-category="<%=b.getCategoryName() == null
                        ? ""
                        : b.getCategoryName().toLowerCase()%>"

                data-category-original="<%=b.getCategoryName()%>"

                data-price="<%=b.getPrice()%>"
        >


            <!-- COVER -->

            <div class="book-cover">

                <div class="cover-decoration"></div>

                <% if(b.getImageUrl() != null && !b.getImageUrl().trim().isEmpty()) { %>
                <img class="book-cover-image" src="<%=b.getImageUrl()%>" alt="<%=b.getTitle()%> cover" onerror="this.style.display='none';this.nextElementSibling.style.display='block';">
                <span class="book-icon book-icon-fallback" style="display:none;">📚</span>
                <% } else { %>
                <span class="book-icon">📚</span>
                <% } %>


                <span class="format-badge">
                    <%=b.getFormat()%>
                </span>


                <% if(b.getStock() > 0) { %>

                <span class="stock-badge available">
                    In Stock
                </span>

                <% } else { %>

                <span class="stock-badge unavailable">
                    Out of Stock
                </span>

                <% } %>

            </div>



            <!-- DETAILS -->

            <div class="book-content">

                <p class="book-category">
                    <%=b.getCategoryName()%>
                </p>


                <h3>
                    <%=b.getTitle()%>
                </h3>


                <p class="book-author">

                    by

                    <strong>
                        <%=b.getAuthorName()%>
                    </strong>

                </p>


                <p class="book-description">

                    <%=b.getDescription() == null
                            ? ""
                            : b.getDescription()%>

                </p>



                <div class="book-bottom">


                    <div>

                        <span class="price-label">
                            Price
                        </span>

                        <div class="price">
                            Rs. <%=b.getPrice()%>
                        </div>

                    </div>


                    <div class="stock-text">

                        <span>
                            Stock
                        </span>

                        <strong>
                            <%=b.getStock()%>
                        </strong>

                    </div>

                </div>



                <a class="btn view-details-button" href="<%=request.getContextPath()%>/book?id=<%=b.getId()%>">
                    View Details
                </a>

                <!-- CUSTOMER -->

                <%
                    if (
                            session.getAttribute("userId") != null
                                    &&
                                    !"ADMIN".equals(
                                            session.getAttribute("userRole")
                                    )
                    ) {
                %>


                <% if(b.getStock() > 0) { %>

                <form
                        class="buy-form"
                        action="<%=request.getContextPath()%>/orders"
                        method="post"
                >

                    <input
                            type="hidden"
                            name="action"
                            value="create"
                    >

                    <input
                            type="hidden"
                            name="bookId"
                            value="<%=b.getId()%>"
                    >


                    <div class="quantity-box">

                        <label>
                            Qty
                        </label>

                        <input
                                type="number"
                                name="quantity"
                                min="1"
                                max="<%=b.getStock()%>"
                                value="1"
                                required
                        >

                    </div>


                    <button
                            class="btn primary buy-button"
                            type="submit"
                    >
                        Buy Now
                    </button>

                </form>

                <% } else { %>

                <button
                        class="btn disabled-button"
                        disabled
                >
                    Out of Stock
                </button>

                <% } %>


                <%
                    }
                %>



                <!-- GUEST -->

                <%
                    if(session.getAttribute("userId") == null) {
                %>

                <a
                        class="btn primary login-buy-button"
                        href="<%=request.getContextPath()%>/login.jsp"
                >
                    Login to Buy
                </a>

                <%
                    }
                %>


            </div>

        </article>


        <%
            }

        } else {
        %>


        <div class="empty-state">

            <span>
                📚
            </span>

            <h3>
                No books available
            </h3>

        </div>


        <% } %>

    </div>



    <div
            id="noSearchResult"
            class="no-results"
            style="display:none;"
    >

        <span>
            🔍
        </span>

        <h3>
            No books found
        </h3>

        <p>
            Try another title, author or category.
        </p>

    </div>



    <!-- ================= REVIEWS ================= -->

    <section class="review-section">

        <div class="review-heading">

            <span class="small-label">
                READER COMMUNITY
            </span>

            <h2>
                Reader Reviews
            </h2>

            <p class="muted">
                See what our readers are saying.
            </p>

        </div>


        <div class="review-grid">

            <%
                List<Review> reviews =
                        (List<Review>) request.getAttribute("reviews");

                if (reviews != null && !reviews.isEmpty()) {

                    for (Review v : reviews) {
            %>


            <article class="review-card">

                <div class="quote-icon">
                    “
                </div>


                <div class="review-stars">

                    <%
                        for (
                                int i = 1;
                                i <= 5;
                                i++
                        ) {

                            if(i <= v.getRating()) {
                    %>

                    <span>★</span>

                    <%
                    } else {
                    %>

                    <span class="empty-star">
                        ★
                    </span>

                    <%
                            }
                        }
                    %>

                </div>


                <p class="review-comment">

                    <%=v.getComment()%>

                </p>


                <div class="review-footer">

                    <div class="avatar">

                        <%=v.getUserName() != null &&
                                !v.getUserName().isEmpty()
                                ? v.getUserName()
                                .substring(0,1)
                                .toUpperCase()
                                : "U"%>

                    </div>


                    <div>

                        <strong>
                            <%=v.getUserName()%>
                        </strong>

                        <small>
                            reviewed
                            <%=v.getBookTitle()%>
                        </small>

                    </div>

                </div>

            </article>


            <%
                }

            } else {
            %>


            <div class="empty-review">

                No reviews available yet.

            </div>


            <% } %>

        </div>

    </section>


</main>



<!-- ================= FOOTER ================= -->

<footer class="footer">

    <div class="footer-container">

        <div>

            <a
                    class="brand footer-brand"
                    href="<%=request.getContextPath()%>/catalog"
            >
                Book<span>Nest</span>
            </a>

            <p>
                Discover books, place your orders and
                enjoy your reading journey.
            </p>

        </div>


        <div>

            <h4>
                Quick Links
            </h4>

            <a href="<%=request.getContextPath()%>/catalog">
                Store
            </a>

            <% if(session.getAttribute("userId") != null) { %>

            <a href="<%=request.getContextPath()%>/orders">
                My Orders
            </a>

            <a href="<%=request.getContextPath()%>/reviews">
                Reviews
            </a>

            <% } %>

        </div>


        <div>

            <h4>
                Customer
            </h4>

            <% if(session.getAttribute("userId") == null) { %>

            <a href="<%=request.getContextPath()%>/login.jsp">
                Login
            </a>

            <a href="<%=request.getContextPath()%>/register.jsp">
                Register
            </a>

            <% } else { %>

            <a href="<%=request.getContextPath()%>/logout">
                Logout
            </a>

            <% } %>

        </div>

    </div>


    <div class="footer-bottom">

        © 2026 BookNest. All rights reserved.

    </div>

</footer>



<!-- ================= JAVASCRIPT ================= -->

<script>

    const cards =
        Array.from(
            document.querySelectorAll(".book-card")
        );


    const categorySelect =
        document.getElementById("categoryFilter");


    const categories = new Set();


    cards.forEach(card => {

        const category =
            card.dataset.categoryOriginal;

        if(category) {
            categories.add(category);
        }

    });


    Array.from(categories)
        .sort()
        .forEach(category => {

            const option =
                document.createElement("option");

            option.value =
                category.toLowerCase();

            option.textContent =
                category;

            categorySelect.appendChild(option);

        });



    function filterBooks() {

        const search =
            document
                .getElementById("bookSearch")
                .value
                .toLowerCase()
                .trim();


        const category =
            document
                .getElementById("categoryFilter")
                .value
                .toLowerCase();


        let visible = 0;


        cards.forEach(card => {

            const title =
                card.dataset.title || "";

            const author =
                card.dataset.author || "";

            const cardCategory =
                card.dataset.category || "";


            const searchMatch =
                title.includes(search)
                ||
                author.includes(search)
                ||
                cardCategory.includes(search);


            const categoryMatch =
                category === ""
                ||
                cardCategory === category;


            if(
                searchMatch
                &&
                categoryMatch
            ) {

                card.style.display = "";

                visible++;

            } else {

                card.style.display = "none";

            }

        });


        document.getElementById(
            "noSearchResult"
        ).style.display =
            visible === 0
                ? "block"
                : "none";

    }



    function sortBooks() {

        const value =
            document
                .getElementById("sortBooks")
                .value;


        const grid =
            document.getElementById("bookGrid");


        const sorted =
            [...cards];


        if(value === "low") {

            sorted.sort(
                (a,b) =>
                    parseFloat(a.dataset.price)
                    -
                    parseFloat(b.dataset.price)
            );

        }


        else if(value === "high") {

            sorted.sort(
                (a,b) =>
                    parseFloat(b.dataset.price)
                    -
                    parseFloat(a.dataset.price)
            );

        }


        else if(value === "az") {

            sorted.sort(
                (a,b) =>
                    a.dataset.title.localeCompare(
                        b.dataset.title
                    )
            );

        }


        sorted.forEach(
            card => grid.appendChild(card)
        );

    }

</script>


</body>

</html>