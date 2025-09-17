<%@ page contentType="text/html;charset=UTF-8" session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login • WeatherDonation</title>
    <link rel="stylesheet" href="assets/style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .form-container {
            background: #fff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            width: 100%;
            max-width: 400px;
        }
        h2 {
            text-align: center;
            color: #0275d8;
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="email"], input[type="password"] {
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        button {
            margin-top: 20px;
            width: 100%;
            padding: 10px;
            background-color: #0275d8;
            border: none;
            border-radius: 5px;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background-color: #025aa5;
        }
        .error {
            color: #e74c3c;
            text-align: center;
            margin-bottom: 10px;
        }
        .success {
            color: #27ae60;
            text-align: center;
            margin-bottom: 10px;
        }
        p {
            text-align: center;
            margin-top: 15px;
        }
        p a {
            color: #0275d8;
            text-decoration: none;
        }
        p a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Login</h2>

        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } %>
        <% if (request.getParameter("logout") != null) { %>
            <p class="success">Logged out successfully.</p>
        <% } %>

        <form action="login" method="post">
            <label>Email:</label>
            <input type="email" name="email" required>

            <label>Password:</label>
            <input type="password" name="password" required>

            <button type="submit">Login</button>
        </form>

        <p>Don't have an account? <a href="register.jsp">Register here</a>.</p>
    </div>
</body>
</html>
