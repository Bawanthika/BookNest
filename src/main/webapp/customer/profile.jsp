<%@ page import="models.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User u = (User) request.getAttribute("user");
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>My Profile | BookNest</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
</head>
<body>
<nav class="nav">
    <a class="brand" href="<%=request.getContextPath()%>/catalog">Book<span>Nest</span></a>
    <div class="navlinks">
        <a href="<%=request.getContextPath()%>/catalog">Store</a>
        <a href="<%=request.getContextPath()%>/orders">My Orders</a>
        <a href="<%=request.getContextPath()%>/reviews">Reviews</a>
        <a href="<%=request.getContextPath()%>/profile">Profile</a>
        <a class="btn btn-light" href="<%=request.getContextPath()%>/logout">Logout</a>
    </div>
</nav>

<main class="container profile-page">
    <div class="profile-header">
        <div class="profile-avatar-large"><%=u!=null && u.getFullName()!=null && !u.getFullName().isEmpty()?u.getFullName().substring(0,1).toUpperCase():"U"%></div>
        <div>
            <span class="small-label">MY ACCOUNT</span>
            <h1><%=u.getFullName()%></h1>
            <p class="muted"><%=u.getEmail()%></p>
        </div>
    </div>

    <% if(request.getParameter("success")!=null){ %>
    <div class="alert-success">Account updated successfully.</div>
    <% } %>
    <% if(request.getParameter("error")!=null){ %>
    <div class="alert-error">Could not update your account. Check the details and try again.</div>
    <% } %>

    <div class="profile-stats">
        <div class="profile-stat"><span>🛒</span><strong><%=request.getAttribute("orderCount")%></strong><small>Orders</small></div>
        <div class="profile-stat"><span>⭐</span><strong><%=request.getAttribute("reviewCount")%></strong><small>Reviews</small></div>
        <div class="profile-stat"><span>👤</span><strong>Customer</strong><small>Account Type</small></div>
    </div>

    <div class="profile-grid">
        <section class="panel">
            <h2>Personal Information</h2>
            <p class="muted">Update your BookNest account details.</p>
            <form method="post" class="profile-form">
                <input type="hidden" name="action" value="updateProfile">
                <label>Full Name</label>
                <input name="fullName" value="<%=u.getFullName()%>" required>
                <label>Email</label>
                <input type="email" name="email" value="<%=u.getEmail()%>" required>
                <button class="btn primary">Save Changes</button>
            </form>
        </section>

        <section class="panel">
            <h2>Change Password</h2>
            <p class="muted">Use at least 6 characters for your new password.</p>
            <form method="post" class="profile-form">
                <input type="hidden" name="action" value="changePassword">
                <label>Current Password</label>
                <input type="password" name="currentPassword" required>
                <label>New Password</label>
                <input type="password" name="newPassword" minlength="6" required>
                <label>Confirm New Password</label>
                <input type="password" name="confirmPassword" minlength="6" required>
                <button class="btn primary">Change Password</button>
            </form>
        </section>
    </div>
</main>
</body>
</html>
