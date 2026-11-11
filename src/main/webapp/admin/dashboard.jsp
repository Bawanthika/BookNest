<%@ page import="java.util.*,java.math.BigDecimal,models.Order,models.Book" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta
            name="viewport"
            content="width=device-width,initial-scale=1"
    >

    <title>
        BookNest Admin Dashboard
    </title>

    <link
            rel="stylesheet"
            href="<%=request.getContextPath()%>/assets/css/style.css"
    >

</head>


<body>


<nav class="nav">

    <a
            class="brand"
            href="<%=request.getContextPath()%>/catalog"
    >
        Book<span>Nest</span>
    </a>


    <div class="navlinks">

        <a href="<%=request.getContextPath()%>/catalog">
            Store
        </a>

        <a href="<%=request.getContextPath()%>/admin/dashboard">
            Dashboard
        </a>

        <a href="<%=request.getContextPath()%>/orders">
            Orders
        </a>

        <a href="<%=request.getContextPath()%>/reviews">
            Reviews
        </a>

        <a
                class="btn btn-light"
                href="<%=request.getContextPath()%>/logout"
        >
            Logout
        </a>

    </div>

</nav>



<div class="admin-shell">


    <!-- SIDEBAR -->

    <aside class="side">

        <h3>
            Admin Panel
        </h3>


        <a
                class="active-side"
                href="<%=request.getContextPath()%>/admin/dashboard"
        >
            Dashboard
        </a>


        <a href="<%=request.getContextPath()%>/admin/users">
            Users
        </a>


        <a href="<%=request.getContextPath()%>/admin/books">
            Books
        </a>


        <a href="<%=request.getContextPath()%>/admin/authors">
            Authors
        </a>


        <a href="<%=request.getContextPath()%>/admin/categories">
            Categories
        </a>


        <a href="<%=request.getContextPath()%>/orders">
            Orders
        </a>


        <a href="<%=request.getContextPath()%>/reviews">
            Reviews
        </a>

    </aside>



    <!-- DASHBOARD CONTENT -->

    <main class="content dashboard-content">


        <div class="dashboard-header">

            <div>

                <span class="small-label">
                    OVERVIEW
                </span>

                <h1>
                    Administrator Dashboard
                </h1>

                <p class="muted">
                    Monitor and manage BookNest from one place.
                </p>

            </div>


            <a
                    href="<%=request.getContextPath()%>/catalog"
                    class="btn primary"
            >
                View Store
            </a>

        </div>



        <!-- STAT CARDS -->

        <section class="dashboard-stats">


            <div class="dashboard-stat">

                <div class="stat-icon purple">
                    📚
                </div>

                <div>

                    <span>
                        Total Books
                    </span>

                    <strong>
                        <%=request.getAttribute("bookCount")%>
                    </strong>

                </div>

            </div>



            <div class="dashboard-stat">

                <div class="stat-icon blue">
                    👥
                </div>

                <div>

                    <span>
                        Customers
                    </span>

                    <strong>
                        <%=request.getAttribute("customerCount")%>
                    </strong>

                </div>

            </div>



            <div class="dashboard-stat">

                <div class="stat-icon green">
                    🛒
                </div>

                <div>

                    <span>
                        Total Orders
                    </span>

                    <strong>
                        <%=request.getAttribute("orderCount")%>
                    </strong>

                </div>

            </div>



            <div class="dashboard-stat">

                <div class="stat-icon orange">
                    ⏳
                </div>

                <div>

                    <span>
                        Pending Orders
                    </span>

                    <strong>
                        <%=request.getAttribute("pendingCount")%>
                    </strong>

                </div>

            </div>



            <div class="dashboard-stat">

                <div class="stat-icon pink">
                    ⭐
                </div>

                <div>

                    <span>
                        Reviews
                    </span>

                    <strong>
                        <%=request.getAttribute("reviewCount")%>
                    </strong>

                </div>

            </div>



            <div class="dashboard-stat revenue-stat">

                <div class="stat-icon teal">
                    💰
                </div>

                <div>

                    <span>
                        Revenue
                    </span>

                    <strong class="revenue-number">
                        Rs.
                        <%=request.getAttribute("revenue")%>
                    </strong>

                </div>

            </div>


        </section>



        <!-- MAIN DASHBOARD GRID -->

        <div class="dashboard-grid">


            <!-- RECENT ORDERS -->

            <section class="dashboard-panel recent-orders-panel">

                <div class="panel-heading">

                    <div>

                        <h2>
                            Recent Orders
                        </h2>

                        <p>
                            Latest customer purchases
                        </p>

                    </div>


                    <a
                            href="<%=request.getContextPath()%>/orders"
                    >
                        View All →
                    </a>

                </div>


                <div class="table-wrap">

                    <table class="dashboard-table">

                        <thead>

                        <tr>

                            <th>
                                Order
                            </th>

                            <th>
                                Customer
                            </th>

                            <th>
                                Book
                            </th>

                            <th>
                                Total
                            </th>

                            <th>
                                Status
                            </th>

                        </tr>

                        </thead>


                        <tbody>

                        <%
                            List<Order> recentOrders =
                                    (List<Order>)
                                            request.getAttribute(
                                                    "recentOrders"
                                            );

                            if (
                                    recentOrders != null
                                            &&
                                            !recentOrders.isEmpty()
                            ) {

                                for (Order o : recentOrders) {
                        %>


                        <tr>

                            <td>
                                #<%=o.getId()%>
                            </td>


                            <td>
                                <%=o.getCustomerName()%>
                            </td>


                            <td>
                                <%=o.getBookTitle()%>
                            </td>


                            <td>
                                Rs.
                                <%=o.getTotal()%>
                            </td>


                            <td>

                                <span
                                        class="order-status
                                        status-<%=o.getStatus().toLowerCase()%>"
                                >
                                    <%=o.getStatus()%>
                                </span>

                            </td>

                        </tr>


                        <%
                            }

                        } else {
                        %>


                        <tr>

                            <td
                                    colspan="5"
                                    class="dashboard-empty"
                            >
                                No orders available.
                            </td>

                        </tr>


                        <% } %>

                        </tbody>

                    </table>

                </div>

            </section>



            <!-- LOW STOCK -->

            <section class="dashboard-panel low-stock-panel">

                <div class="panel-heading">

                    <div>

                        <h2>
                            Low Stock
                        </h2>

                        <p>
                            Books that need attention
                        </p>

                    </div>

                </div>


                <div class="low-stock-list">

                    <%
                        List<Book> lowStockBooks =
                                (List<Book>)
                                        request.getAttribute(
                                                "lowStockBooks"
                                        );

                        if (
                                lowStockBooks != null
                                        &&
                                        !lowStockBooks.isEmpty()
                        ) {

                            for (Book b : lowStockBooks) {
                    %>


                    <div class="low-stock-item">

                        <div class="mini-book">
                            📚
                        </div>


                        <div class="low-stock-info">

                            <strong>
                                <%=b.getTitle()%>
                            </strong>

                            <small>
                                <%=b.getAuthorName()%>
                            </small>

                        </div>


                        <span class="low-stock-count">

                            <%=b.getStock()%>
                            left

                        </span>

                    </div>


                    <%
                        }

                    } else {
                    %>


                    <div class="dashboard-empty">

                        All books have sufficient stock.

                    </div>


                    <% } %>

                </div>

            </section>

        </div>





        <!-- PHASE 2 ANALYTICS -->
        <section class="dashboard-analytics-grid">
            <div class="dashboard-panel">
                <div class="panel-heading">
                    <div><h2>Order Status</h2><p>Current order distribution</p></div>
                </div>
                <%
                    Map<String,Integer> statusCounts = (Map<String,Integer>)request.getAttribute("statusCounts");
                    int maxStatus = 1;
                    if(statusCounts != null) for(Integer v: statusCounts.values()) if(v != null && v > maxStatus) maxStatus = v;
                    if(statusCounts != null) for(Map.Entry<String,Integer> e: statusCounts.entrySet()) {
                        int pct = (int)Math.round((e.getValue()*100.0)/maxStatus);
                %>
                <div class="chart-row">
                    <div class="chart-label"><span><%=e.getKey()%></span><strong><%=e.getValue()%></strong></div>
                    <div class="chart-track"><div class="chart-fill status-fill-<%=e.getKey().toLowerCase()%>" style="width:<%=pct%>%"></div></div>
                </div>
                <% } %>
            </div>

            <div class="dashboard-panel">
                <div class="panel-heading">
                    <div><h2>Monthly Revenue</h2><p>Revenue from active/fulfilled orders</p></div>
                </div>
                <%
                    Map<String,BigDecimal> monthly = (Map<String,BigDecimal>)request.getAttribute("monthlyRevenue");
                    BigDecimal maxRevenue = BigDecimal.ONE;
                    if(monthly != null) for(BigDecimal v: monthly.values()) if(v != null && v.compareTo(maxRevenue)>0) maxRevenue=v;
                    if(monthly != null && !monthly.isEmpty()) {
                        for(Map.Entry<String,BigDecimal> e: monthly.entrySet()) {
                            int pct = e.getValue().multiply(new BigDecimal("100")).divide(maxRevenue,0,java.math.RoundingMode.HALF_UP).intValue();
                %>
                <div class="chart-row">
                    <div class="chart-label"><span><%=e.getKey()%></span><strong>Rs. <%=e.getValue()%></strong></div>
                    <div class="chart-track"><div class="chart-fill revenue-fill" style="width:<%=pct%>%"></div></div>
                </div>
                <% }} else { %>
                <div class="dashboard-empty">Revenue chart will appear after paid/shipped/completed orders.</div>
                <% } %>
            </div>
        </section>

        <section class="dashboard-panel bestseller-panel">
            <div class="panel-heading">
                <div><h2>Best-Selling Books</h2><p>Top titles by ordered quantity</p></div>
                <a href="<%=request.getContextPath()%>/admin/books">Manage Books →</a>
            </div>
            <div class="bestseller-grid">
                <%
                    List<Map<String,Object>> best = (List<Map<String,Object>>)request.getAttribute("bestSellingBooks");
                    if(best != null && !best.isEmpty()) {
                        int rank=1;
                        for(Map<String,Object> row: best) {
                %>
                <div class="bestseller-card">
                    <div class="bestseller-rank">#<%=rank++%></div>
                    <div><strong><%=row.get("title")%></strong><small><%=row.get("sold")%> copies ordered</small></div>
                    <span>Rs. <%=row.get("revenue")%></span>
                </div>
                <% }} else { %>
                <div class="dashboard-empty">Best-selling data will appear after customers place orders.</div>
                <% } %>
            </div>
        </section>


        <!-- QUICK ACTIONS -->

        <section class="dashboard-panel quick-actions-panel">

            <div class="panel-heading">

                <div>

                    <h2>
                        Quick Actions
                    </h2>

                    <p>
                        Manage BookNest records
                    </p>

                </div>

            </div>


            <div class="quick-actions">


                <a
                        href="<%=request.getContextPath()%>/admin/books"
                        class="quick-action"
                >

                    <span>
                        📚
                    </span>

                    <strong>
                        Manage Books
                    </strong>

                    <small>
                        Add, edit and remove books
                    </small>

                </a>



                <a
                        href="<%=request.getContextPath()%>/admin/users"
                        class="quick-action"
                >

                    <span>
                        👥
                    </span>

                    <strong>
                        Manage Users
                    </strong>

                    <small>
                        View and manage users
                    </small>

                </a>



                <a
                        href="<%=request.getContextPath()%>/orders"
                        class="quick-action"
                >

                    <span>
                        🛒
                    </span>

                    <strong>
                        Manage Orders
                    </strong>

                    <small>
                        Update order status
                    </small>

                </a>



                <a
                        href="<%=request.getContextPath()%>/reviews"
                        class="quick-action"
                >

                    <span>
                        ⭐
                    </span>

                    <strong>
                        Review Moderation
                    </strong>

                    <small>
                        Approve customer reviews
                    </small>

                </a>


            </div>

        </section>


    </main>

</div>


</body>

</html>