<%@ page import="java.util.*,models.Review" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Review Management | BookNest</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
</head>

<body>

<nav class="nav">
    <a class="brand" href="<%=request.getContextPath()%>/catalog">
        Book<span>Nest</span>
    </a>

    <div class="navlinks">
        <a href="<%=request.getContextPath()%>/catalog">Store</a>
        <a href="<%=request.getContextPath()%>/admin/dashboard">Dashboard</a>
        <a href="<%=request.getContextPath()%>/orders">Orders</a>
        <a href="<%=request.getContextPath()%>/reviews">Reviews</a>
        <a class="btn btn-light" href="<%=request.getContextPath()%>/logout">Logout</a>
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

        <a href="<%=request.getContextPath()%>/orders">
            Orders
        </a>

        <a class="active-side" href="<%=request.getContextPath()%>/reviews">
            Reviews
        </a>
    </aside>


    <main class="content dashboard-content">

        <div class="dashboard-header">

            <div>
                <span class="small-label">MODERATION</span>
                <h1>Review Management</h1>
                <p class="muted">
                    Approve customer feedback, edit reviews or remove inappropriate content.
                </p>
            </div>

            <a class="btn primary"
               href="<%=request.getContextPath()%>/catalog">
                View Store
            </a>

        </div>


        <% if(request.getParameter("msg") != null) { %>

        <div class="<%= "1".equals(request.getParameter("ok")) ? "alert-success" : "alert-error" %>">
            <%=request.getParameter("msg")%>
        </div>

        <% } %>


        <section class="admin-review-stats">

            <div class="review-stat-card">
                <span>All Reviews</span>
                <strong>
                    <%
                        List<Review> reviewList =
                                (List<Review>) request.getAttribute("reviews");

                        out.print(
                                reviewList == null
                                        ? 0
                                        : reviewList.size()
                        );
                    %>
                </strong>
            </div>

            <div class="review-stat-card pending-card">
                <span>Pending</span>
                <strong><%=request.getAttribute("pendingCount")%></strong>
            </div>

            <div class="review-stat-card approved-card">
                <span>Approved</span>
                <strong><%=request.getAttribute("approvedCount")%></strong>
            </div>

        </section>


        <section class="dashboard-panel">

            <div class="admin-review-toolbar">

                <div class="search-wrapper">
                    <span class="search-icon">🔎</span>

                    <input
                            id="adminReviewSearch"
                            type="text"
                            placeholder="Search customer, book or comment..."
                            onkeyup="filterAdminReviews()"
                    >
                </div>

                <select
                        id="adminReviewStatus"
                        onchange="filterAdminReviews()"
                >
                    <option value="">All Statuses</option>
                    <option value="pending">Pending</option>
                    <option value="approved">Approved</option>
                </select>

            </div>


            <div class="table-wrap">

                <table class="dashboard-table admin-review-table">

                    <thead>

                    <tr>
                        <th>ID</th>
                        <th>Customer</th>
                        <th>Book</th>
                        <th>Rating</th>
                        <th>Comment</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>

                    </thead>

                    <tbody id="adminReviewBody">

                    <%
                        if (
                                reviewList != null
                                        &&
                                        !reviewList.isEmpty()
                        ) {

                            for (Review review : reviewList) {

                                String reviewStatus =
                                        review.isApproved()
                                                ? "approved"
                                                : "pending";
                    %>

                    <tr
                            class="admin-review-row"
                            data-status="<%=reviewStatus%>"
                            data-search="<%=
                                    (
                                            review.getUserName()
                                                    + " "
                                                    + review.getBookTitle()
                                                    + " "
                                                    + review.getComment()
                                    ).toLowerCase()
                            %>"
                    >

                        <td>
                            #<%=review.getId()%>
                        </td>

                        <td>
                            <strong><%=review.getUserName()%></strong>
                        </td>

                        <td>
                            <%=review.getBookTitle()%>
                        </td>

                        <td>
                            <span class="admin-stars">

                                <%
                                    for (
                                            int star = 1;
                                            star <= 5;
                                            star++
                                    ) {
                                %>

                                <span class="<%=star <= review.getRating() ? "" : "empty-star"%>">
                                    ★
                                </span>

                                <% } %>

                            </span>

                            <small class="muted">
                                <%=review.getRating()%>/5
                            </small>
                        </td>

                        <td class="review-comment-cell">
                            <%=review.getComment()%>
                        </td>

                        <td>

                            <span class="review-status <%=review.isApproved() ? "review-approved" : "review-pending"%>">

                                <%=review.isApproved() ? "Approved" : "Pending"%>

                            </span>

                        </td>

                        <td>

                            <div class="admin-review-actions">

                                <% if(!review.isApproved()) { %>

                                <form method="post">

                                    <input
                                            type="hidden"
                                            name="id"
                                            value="<%=review.getId()%>"
                                    >

                                    <button
                                            class="btn success"
                                            type="submit"
                                            name="action"
                                            value="approve"
                                    >
                                        Approve
                                    </button>

                                </form>

                                <% } else { %>

                                <form method="post">

                                    <input
                                            type="hidden"
                                            name="id"
                                            value="<%=review.getId()%>"
                                    >

                                    <button
                                            class="btn admin-pending-button"
                                            type="submit"
                                            name="action"
                                            value="pending"
                                    >
                                        Set Pending
                                    </button>

                                </form>

                                <% } %>


                                <details class="review-edit-details">

                                    <summary class="btn">
                                        Edit
                                    </summary>

                                    <form
                                            method="post"
                                            class="admin-review-edit-form"
                                    >

                                        <input
                                                type="hidden"
                                                name="id"
                                                value="<%=review.getId()%>"
                                        >

                                        <label>
                                            Rating
                                        </label>

                                        <input
                                                type="number"
                                                name="rating"
                                                min="1"
                                                max="5"
                                                value="<%=review.getRating()%>"
                                                required
                                        >

                                        <label>
                                            Comment
                                        </label>

                                        <textarea
                                                name="comment"
                                                required
                                        ><%=review.getComment()%></textarea>

                                        <label class="admin-review-check">
                                            <input
                                                    type="checkbox"
                                                    name="approved"
                                                <%=review.isApproved() ? "checked" : ""%>
                                            >

                                            Approved
                                        </label>

                                        <button
                                                class="btn primary"
                                                name="action"
                                                value="update"
                                                type="submit"
                                        >
                                            Save Review
                                        </button>

                                    </form>

                                </details>


                                <form
                                        method="post"
                                        onsubmit="return confirm('Permanently delete this review?');"
                                >

                                    <input
                                            type="hidden"
                                            name="id"
                                            value="<%=review.getId()%>"
                                    >

                                    <button
                                            class="btn danger"
                                            name="action"
                                            value="delete"
                                            type="submit"
                                    >
                                        Delete
                                    </button>

                                </form>

                            </div>

                        </td>

                    </tr>

                    <%
                        }

                    } else {
                    %>

                    <tr>
                        <td
                                colspan="7"
                                class="dashboard-empty"
                        >
                            No reviews available.
                        </td>
                    </tr>

                    <% } %>

                    </tbody>

                </table>

            </div>


            <div
                    id="noAdminReviewResults"
                    class="dashboard-empty"
                    style="display:none;"
            >
                No reviews match the selected search/filter.
            </div>

        </section>

    </main>

</div>


<script>

    function filterAdminReviews() {

        const search =
            document
                .getElementById("adminReviewSearch")
                .value
                .toLowerCase()
                .trim();

        const status =
            document
                .getElementById("adminReviewStatus")
                .value;

        const rows =
            document
                .querySelectorAll(".admin-review-row");

        let visible = 0;

        rows.forEach(row => {

            const matchesSearch =
                (row.dataset.search || "")
                    .includes(search);

            const matchesStatus =
                status === ""
                ||
                row.dataset.status === status;

            if (
                matchesSearch
                &&
                matchesStatus
            ) {

                row.style.display = "";
                visible++;

            } else {

                row.style.display = "none";
            }
        });

        document
            .getElementById("noAdminReviewResults")
            .style.display =
            visible === 0
                ? "block"
                : "none";
    }

</script>

</body>
</html>
