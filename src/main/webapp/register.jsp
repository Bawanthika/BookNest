
<%@ page contentType="text/html;charset=UTF-8" %>

<!doctype html>
<html>

<head>
    <title>Register</title>

    <link rel="stylesheet"
          href="<%=request.getContextPath()%>/assets/css/style.css">
</head>

<body class="auth">

<div class="authbox">

    <a class="brand" href="catalog">
        Book<span>Nest</span>
    </a>

    <h1>Create account</h1>

    <% if(request.getParameter("error") != null) { %>

    <div class="flash">
        Email already exists or registration failed.
    </div>

    <% } %>

    <form action="register" method="post">

        <p>
            <label>Full Name</label>
            <input name="fullName" required>
        </p>

        <p>
            <label>Email</label>
            <input type="email" name="email" required>
        </p>

        <p>
            <label>Password</label>
            <input type="password"
                   name="password"
                   minlength="6"
                   required>
        </p>

        <button class="btn primary" style="width:100%">
            Register
        </button>

    </form>

    <p>
        Already registered?
        <a href="login.jsp"
           style="color:#6d3df5;font-weight:800">
            Login
        </a>
    </p>

</div>

</body>
</html>
