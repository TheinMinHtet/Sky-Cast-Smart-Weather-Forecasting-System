<%@ page contentType="text/html;charset=UTF-8" session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Place • WeatherDonation</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            padding: 40px 20px;
        }
        .form-container {
            background: #fff;
            padding: 30px 25px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 500px;
        }
        .form-container h2 {
            margin-top: 0;
            text-align: center;
            color: #0275d8;
            margin-bottom: 25px;
        }
        .form-container label {
            display: block;
            margin: 12px 0 5px;
            font-weight: bold;
        }
        .form-container input[type="text"],
        .form-container textarea,
        .form-container input[type="file"] {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-container textarea { resize: vertical; min-height: 100px; }
        .form-container button {
            width: 100%;
            padding: 12px;
            background-color: #27ae60;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 20px;
            transition: 0.3s;
        }
        .form-container button:hover { background-color: #219150; }
        .form-container p { text-align: center; margin-top: 20px; }
        .form-container p a { color: #3498db; text-decoration: none; transition: 0.3s; }
        .form-container p a:hover { text-decoration: underline; }

        #imagePreview {
            display: block;
            margin: 15px auto;
            max-width: 200px;
            max-height: 200px;
            border-radius: 6px;
            object-fit: cover;
            border: 1px solid #ccc;
        }

        @media (max-width: 600px) {
            body { padding: 20px 10px; }
            .form-container { padding: 25px 15px; }
        }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Add Damaged Place</h2>
    <form action="<%= request.getContextPath() %>/addPlace" method="post" enctype="multipart/form-data">
        <label>Name:</label>
        <input type="text" name="name" required>

        <label>Description:</label>
        <textarea name="description" required></textarea>

        <label>Upload Image (optional):</label>
        <input type="file" name="image" accept="image/*" onchange="previewImage(event)">

        <!-- Image preview -->
        <img id="imagePreview" src="#" alt="Image Preview" style="display:none;">

        <button type="submit">Add Place</button>
    </form>
    <p><a href="adminDashboard.jsp">Back to Dashboard</a></p>
</div>

<script>
    function previewImage(event) {
        const preview = document.getElementById('imagePreview');
        const file = event.target.files[0];
        if(file) {
            preview.src = URL.createObjectURL(file);
            preview.style.display = 'block';
        } else {
            preview.src = '#';
            preview.style.display = 'none';
        }
    }
</script>
</body>
</html>
