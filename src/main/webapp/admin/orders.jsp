<%@ page import="java.util.*,models.Order" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Order Management | BookNest</title>

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
            Admin
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

    <aside class="side">

        <h3>Admin Panel</h3>

        <a href="<%=request.getContextPath()%>/admin/dashboard">
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

        <a
                class="active-side"
                href="<%=request.getContextPath()%>/orders"
        >
            Orders
        </a>

        <a href="<%=request.getContextPath()%>/reviews">
            Reviews
        </a>

    </aside>


    <main class="content dashboard-content">

        <%
            List<Order> orders =
                    (List<Order>) request.getAttribute("orders");

            int total = 0;
            int pending = 0;
            int paid = 0;
            int shipped = 0;
            int completed = 0;
            int cancelled = 0;

            if (orders != null) {
                total = orders.size();

                for (Order o : orders) {
                    String s = o.getStatus();

                    if ("PENDING".equalsIgnoreCase(s)) pending++;
                    else if ("PAID".equalsIgnoreCase(s)) paid++;
                    else if ("SHIPPED".equalsIgnoreCase(s)) shipped++;
                    else if ("COMPLETED".equalsIgnoreCase(s)) completed++;
                    else if ("CANCELLED".equalsIgnoreCase(s)) cancelled++;
                }
            }
        %>


        <div class="dashboard-header">

            <div>
                <span class="small-label">
                    ORDER CONTROL
                </span>

                <h1>
                    Order Management
                </h1>

                <p class="muted">
                    Track purchases, update order status and manage customer orders.
                </p>
            </div>

        </div>


        <% if(request.getParameter("msg") != null) { %>

        <div
                class="order-alert <%= "1".equals(request.getParameter("ok")) ? "order-alert-success" : "order-alert-error" %>"
        >
            <%=request.getParameter("msg")%>
        </div>

        <% } %>


        <section class="order-summary-grid">

            <div class="order-summary-card">
                <span>All Orders</span>
                <strong><%=total%></strong>
            </div>

            <div class="order-summary-card pending-card">
                <span>Pending</span>
                <strong><%=pending%></strong>
            </div>

            <div class="order-summary-card paid-card">
                <span>Paid</span>
                <strong><%=paid%></strong>
            </div>

            <div class="order-summary-card shipped-card">
                <span>Shipped</span>
                <strong><%=shipped%></strong>
            </div>

            <div class="order-summary-card completed-card">
                <span>Completed</span>
                <strong><%=completed%></strong>
            </div>

            <div class="order-summary-card cancelled-card">
                <span>Cancelled</span>
                <strong><%=cancelled%></strong>
            </div>

        </section>


        <section class="dashboard-panel">

            <div class="order-tools">

                <div class="search-wrapper">

                    <span class="search-icon">
                        🔎
                    </span>

                    <input
                            id="orderSearch"
                            type="text"
                            placeholder="Search order, customer or book..."
                            onkeyup="filterOrders()"
                    >

                </div>


                <select
                        id="statusFilter"
                        onchange="filterOrders()"
                >

                    <option value="">
                        All Statuses
                    </option>

                    <option value="pending">
                        Pending
                    </option>

                    <option value="paid">
                        Paid
                    </option>

                    <option value="shipped">
                        Shipped
                    </option>

                    <option value="completed">
                        Completed
                    </option>

                    <option value="cancelled">
                        Cancelled
                    </option>

                </select>

            </div>


            <div class="table-wrap">

                <table
                        class="dashboard-table admin-order-table"
                        id="ordersTable"
                >

                    <thead>

                    <tr>
                        <th>Order</th>
                        <th>Customer</th>
                        <th>Book</th>
                        <th>Qty</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>

                    </thead>

                    <tbody>

                    <%
                        if (orders != null && !orders.isEmpty()) {

                            for (Order o : orders) {
                    %>

                    <tr
                            class="order-row"
                            data-search="<%=("#" + o.getId() + " " + o.getCustomerName() + " " + o.getBookTitle()).toLowerCase()%>"
                            data-status="<%=o.getStatus().toLowerCase()%>"
                    >

                        <td>
                            <strong>#<%=o.getId()%></strong>
                        </td>

                        <td>
                            <%=o.getCustomerName()%>
                        </td>

                        <td>
                            <%=o.getBookTitle()%>
                        </td>

                        <td colspan="5" class="order-edit-cell">

                            <form
                                    method="post"
                                    action="<%=request.getContextPath()%>/orders"
                                    class="admin-order-form"
                            >

                                <input
                                        type="hidden"
                                        name="id"
                                        value="<%=o.getId()%>"
                                >


                                <div class="admin-order-field qty-field">

                                    <input
                                            type="number"
                                            name="quantity"
                                            min="1"
                                            value="<%=o.getQuantity()%>"
                                            required
                                    >

                                </div>


                                <div class="admin-order-total">

                                    Rs.
                                    <%=o.getTotal()%>

                                </div>


                                <div>

                                    <select name="status">

                                        <% for(String s :
                                                new String[]{
                                                        "PENDING",
                                                        "PAID",
                                                        "SHIPPED",
                                                        "COMPLETED",
                                                        "CANCELLED"
                                                }) {
                                        %>

                                        <option
                                                value="<%=s%>"
                                                <%=s.equalsIgnoreCase(o.getStatus()) ? "selected" : ""%>
                                        >
                                            <%=s%>
                                        </option>

                                        <% } %>

                                    </select>


                                    <span
                                            class="order-status status-<%=o.getStatus().toLowerCase()%>"
                                    >
                                        <%=o.getStatus()%>
                                    </span>

                                </div>


                                <div class="order-date">
                                    <%=o.getCreatedAt()%>
                                </div>


                                <div class="actions">

                                    <button
                                            class="btn success"
                                            type="submit"
                                            name="action"
                                            value="update"
                                    >
                                        Update
                                    </button>


                                    <button
                                            class="btn danger"
                                            type="submit"
                                            name="action"
                                            value="delete"
                                            onclick="return confirm('Delete order #<%=o.getId()%>?');"
                                    >
                                        Delete
                                    </button>

                                </div>

                            </form>

                        </td>

                    </tr>

                    <%
                        }

                    } else {
                    %>

                    <tr>
                        <td
                                colspan="8"
                                class="dashboard-empty"
                        >
                            No orders available.
                        </td>
                    </tr>

                    <% } %>

                    </tbody>

                </table>


                <div
                        id="noOrderResult"
                        class="dashboard-empty"
                        style="display:none;"
                >
                    No matching orders found.
                </div>

            </div>

        </section>

    </main>

</div>


<script>

    function filterOrders() {

        const search =
            document
                .getElementById("orderSearch")
                .value
                .toLowerCase()
                .trim();

        const status =
            document
                .getElementById("statusFilter")
                .value
                .toLowerCase();

        const rows =
            document
                .querySelectorAll(".order-row");

        let visible = 0;

        rows.forEach(row => {

            const matchSearch =
                row.dataset.search.includes(search);

            const matchStatus =
                status === ""
                ||
                row.dataset.status === status;

            if (matchSearch && matchStatus) {

                row.style.display = "";

                visible++;

            } else {

                row.style.display = "none";
            }

        });


        document.getElementById(
            "noOrderResult"
        ).style.display =
            visible === 0
                ? "block"
                : "none";
    }

</script>

</body>
</html>
