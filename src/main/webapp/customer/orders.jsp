<%@ page import="java.util.*,models.Order" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">

    <title>My Orders | BookNest</title>

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

        <a href="<%=request.getContextPath()%>/orders">
            My Orders
        </a>

        <a href="<%=request.getContextPath()%>/reviews">
            Reviews
        </a>
        <a href="<%=request.getContextPath()%>/profile">Profile</a>

        <a
                class="btn btn-light"
                href="<%=request.getContextPath()%>/logout"
        >
            Logout
        </a>

    </div>

</nav>


<main class="container">

    <div class="customer-page-header">

        <div>

            <span class="small-label">
                PURCHASE HISTORY
            </span>

            <h1>
                My Orders
            </h1>

            <p class="muted">
                Track your purchases and manage pending orders.
            </p>

        </div>

        <a
                href="<%=request.getContextPath()%>/catalog"
                class="btn primary"
        >
            Continue Shopping
        </a>

    </div>


    <% if(request.getParameter("msg") != null) { %>

    <div
            class="order-alert <%= "1".equals(request.getParameter("ok")) ? "order-alert-success" : "order-alert-error" %>"
    >
        <%=request.getParameter("msg")%>
    </div>

    <% } %>


    <%
        List<Order> orders =
                (List<Order>) request.getAttribute("orders");
    %>


    <div class="customer-orders-list">

        <%
            if (orders != null && !orders.isEmpty()) {

                for (Order o : orders) {
        %>

        <article class="customer-order-card">

            <div class="customer-order-top">

                <div>

                    <span class="order-number">
                        Order #<%=o.getId()%>
                    </span>

                    <h3>
                        <%=o.getBookTitle()%>
                    </h3>

                </div>


                <span
                        class="order-status status-<%=o.getStatus().toLowerCase()%>"
                >
                    <%=o.getStatus()%>
                </span>

            </div>


            <div class="customer-order-meta">

                <div>

                    <span>
                        Quantity
                    </span>

                    <strong>
                        <%=o.getQuantity()%>
                    </strong>

                </div>


                <div>

                    <span>
                        Total
                    </span>

                    <strong class="customer-order-price">
                        Rs. <%=o.getTotal()%>
                    </strong>

                </div>


                <div>

                    <span>
                        Ordered On
                    </span>

                    <strong>
                        <%=o.getCreatedAt()%>
                    </strong>

                </div>

            </div>


            <% if ("PENDING".equalsIgnoreCase(o.getStatus())) { %>

            <div class="customer-order-actions">

                <form
                        method="post"
                        action="<%=request.getContextPath()%>/orders"
                        class="order-quantity-form"
                >

                    <input
                            type="hidden"
                            name="id"
                            value="<%=o.getId()%>"
                    >

                    <label>
                        Update Quantity
                    </label>


                    <div class="order-quantity-controls">

                        <input
                                type="number"
                                name="quantity"
                                min="1"
                                value="<%=o.getQuantity()%>"
                                required
                        >

                        <button
                                type="submit"
                                name="action"
                                value="customerUpdate"
                                class="btn success"
                        >
                            Update
                        </button>

                    </div>

                </form>


                <form
                        method="post"
                        action="<%=request.getContextPath()%>/orders"
                        onsubmit="return confirm('Are you sure you want to cancel order #<%=o.getId()%>?');"
                >

                    <input
                            type="hidden"
                            name="id"
                            value="<%=o.getId()%>"
                    >

                    <button
                            type="submit"
                            name="action"
                            value="customerCancel"
                            class="btn danger"
                    >
                        Cancel Order
                    </button>

                </form>

            </div>

            <% } else if ("CANCELLED".equalsIgnoreCase(o.getStatus())) { %>

            <div class="order-info-note">
                This order has been cancelled.
            </div>

            <% } else { %>

            <div class="order-info-note">
                This order is being processed and can no longer be edited.
            </div>

            <% } %>

        </article>

        <%
            }

        } else {
        %>

        <div class="customer-empty-state">

            <div>
                📚
            </div>

            <h2>
                No orders yet
            </h2>

            <p>
                Browse the store and place your first order.
            </p>

            <a
                    href="<%=request.getContextPath()%>/catalog"
                    class="btn primary"
            >
                Browse Books
            </a>

        </div>

        <% } %>

    </div>

</main>

</body>
</html>
