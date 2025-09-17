<%@ page contentType="text/html;charset=UTF-8" session="true" %>
<%@ page import="java.sql.*, com.weather.DBConnection" %>
<%
    // Check admin login
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = null;
    int currentHour = 6;
    int currentMinute = 0;
    String currentAMPM = "AM";

    // Fetch current email time from DB
    try (Connection conn = DBConnection.getConnection()) {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT email_time FROM admin_settings WHERE id=1");
        if(rs.next()) {
            Time t = rs.getTime("email_time");
            currentHour = t.toLocalTime().getHour();
            currentMinute = t.toLocalTime().getMinute();
            if(currentHour == 0) { currentHour = 12; currentAMPM = "AM"; }
            else if(currentHour < 12) { currentAMPM = "AM"; }
            else if(currentHour == 12) { currentAMPM = "PM"; }
            else { currentHour -= 12; currentAMPM = "PM"; }
        }
    } catch(Exception e){ }

    // Handle form submission for updating email time
    if("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("hour") != null) {
        int hour = Integer.parseInt(request.getParameter("hour"));
        int minute = Integer.parseInt(request.getParameter("minute"));
        String ampm = request.getParameter("ampm");

        if("PM".equalsIgnoreCase(ampm) && hour != 12) hour += 12;
        if("AM".equalsIgnoreCase(ampm) && hour == 12) hour = 0;

        Time emailTime = Time.valueOf(String.format("%02d:%02d:00", hour, minute));

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("UPDATE admin_settings SET email_time=? WHERE id=1");
            ps.setTime(1, emailTime);
            ps.executeUpdate();
            message = "Email sending time updated to " + String.format("%02d:%02d %s", 
                        Integer.parseInt(request.getParameter("hour")), minute, ampm);
            currentHour = Integer.parseInt(request.getParameter("hour"));
            currentMinute = minute;
            currentAMPM = ampm;
        } catch(Exception e){ message = e.getMessage(); }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard • WeatherDonation</title>
    <link rel="stylesheet" href="assets/style.css">
    <style>
        body { margin:0; font-family: Arial,sans-serif; display:flex; min-height:100vh; background:#f4f6f9; }
        .sidebar { width:220px; background:#2c3e50; color:#fff; flex-shrink:0; display:flex; flex-direction:column; padding:20px 0; }
        .sidebar h2 { text-align:center; margin-bottom:30px; }
        .sidebar a { color:#fff; text-decoration:none; display:block; padding:12px 20px; transition:0.3s; }
        .sidebar a:hover { background:#34495e; }
        .main { flex-grow:1; padding:20px; display:flex; flex-direction:column; gap:20px; }
        header h2 { margin-top:0; color:#333; }
        .section { background:#fff; border-radius:10px; padding:15px; box-shadow:0 2px 12px rgba(0,0,0,0.1); }
        .section h3 { margin-top:0; color:#0275d8; }
        .scroll-table { width:100%; max-height:250px; overflow-y:auto; display:block; }
        .scroll-table table { width:100%; border-collapse:collapse; }
        .scroll-table th, .scroll-table td { text-align:left; padding:8px; border-bottom:1px solid #ddd; vertical-align:top; }
        .description { white-space: normal; }
        .btn { padding:6px 10px; border-radius:5px; font-size:12px; text-decoration:none; margin-right:3px; border:none; cursor:pointer; color:#fff; white-space: nowrap; }
        .btn-edit { background-color:#27ae60; }
        .btn-approve { background-color:#f39c12; }
        .btn:hover { opacity:0.9; }
        footer { margin-top:20px; text-align:center; color:#777; font-size:14px; }
        @media (max-width:900px) {
            body { flex-direction:column; }
            .sidebar { width:100%; display:flex; flex-direction:row; overflow-x:auto; }
            .sidebar a { flex:1; text-align:center; }
            .main { padding:10px; }
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Admin</h2>
    <a href="adminDashboard.jsp">Dashboard</a>
    <a href="suggestionShow.jsp">User Suggestion</a>
    <a href="logout">Logout</a>
</div>

<div class="main">
    <header>
        <h2>Welcome, <%= session.getAttribute("username") %></h2>
    </header>

    <!-- Email Settings -->
    <div class="section">
        <h3>Daily Weather Email Time</h3>
        <% if(message != null){ %>
            <p style="color:green;"><%= message %></p>
        <% } %>

        <form method="post">
            <label>Hour:</label>
            <input type="number" name="hour" min="1" max="12" value="<%= currentHour %>" required>
            <label>Minute:</label>
            <input type="number" name="minute" min="0" max="59" value="<%= currentMinute %>" required>
            <label>AM/PM:</label>
            <select name="ampm">
                <option value="AM" <%= "AM".equals(currentAMPM) ? "selected" : "" %>>AM</option>
                <option value="PM" <%= "PM".equals(currentAMPM) ? "selected" : "" %>>PM</option>
            </select>
            <button type="submit" class="btn btn-edit">Update Time</button>
        </form>
    </div>

    <!-- All Places -->
    <div class="section">
        <h3>All Places</h3>
        <div class="scroll-table">
            <table>
                <tr><th>ID</th><th>Name</th><th>Description</th><th>Image</th><th>Action</th></tr>
                <%
                    int placeCounter = 1;
                    try (Connection conn = DBConnection.getConnection()) {
                        Statement st = conn.createStatement();
                        ResultSet rs = st.executeQuery("SELECT * FROM places ORDER BY id DESC");
                        while(rs.next()){
                %>
                <tr>
                    <td><%= placeCounter++ %></td>
                    <td title="<%= rs.getString("name") %>"><%= rs.getString("name") %></td>
                    <td class="description"><%= rs.getString("description") %></td>
                    <td>
                        <img src="<%= (rs.getString("image_url") != null && !rs.getString("image_url").isEmpty()) 
                                    ? request.getContextPath() + "/showImage?file=" + rs.getString("image_url") 
                                    : request.getContextPath() + "/assets/default.jpg" %>" 
                             alt="img" style="width:50px;height:50px;border-radius:5px;">
                    </td>
                    <td>
                        <a class="btn btn-edit" href="deletePlace?id=<%= rs.getInt("id") %>">Delete</a>
                    </td>
                </tr>
                <%
                        }
                    } catch(Exception e){ out.println(e.getMessage()); }
                %>
            </table>
        </div>
        <p><a href="addPlace.jsp" class="btn btn-edit" style="margin-top:10px;">+ Add New Place</a></p>
    </div>

    <!-- All Donation History -->
    <div class="section">
        <h3>All Donation History</h3>
        <div class="scroll-table">
            <table>
                <tr><th>ID</th><th>User</th><th>Amount</th><th>Date</th><th>Place</th><th>Status</th></tr>
                <%
                    int historyCounter = 1;
                    try (Connection conn = DBConnection.getConnection()) {
                        Statement st = conn.createStatement();
                        ResultSet rs = st.executeQuery(
                            "SELECT u.username, d.amount, d.donated_at, p.name AS place_name, d.status " +
                            "FROM history_donations d " +
                            "JOIN users u ON d.user_id = u.id " +
                            "JOIN places p ON d.place_id = p.id " +
                            "ORDER BY d.donated_at DESC"
                        );
                        while(rs.next()){
                %>
                <tr>
                    <td><%= historyCounter++ %></td>
                    <td><%= rs.getString("username") %></td>
                    <td><%= rs.getDouble("amount") %> Ks</td>
                    <td><%= rs.getTimestamp("donated_at") %></td>
                    <td><%= rs.getString("place_name") %></td>
                    <td><%= rs.getString("status") %></td>
                </tr>
                <%
                        }
                    } catch(Exception e){ out.println(e.getMessage()); }
                %>
            </table>
        </div>
    </div>

    <!-- Pending Donations -->
    <div class="section">
        <h3>Pending Donations</h3>
        <div class="scroll-table">
            <table>
                <tr><th>ID</th><th>User</th><th>Amount</th><th>Date</th><th>Place</th><th>Action</th></tr>
                <%
                    int pendingCounter = 1;
                    try (Connection conn = DBConnection.getConnection()) {
                        Statement st = conn.createStatement();
                        ResultSet rs = st.executeQuery(
                            "SELECT d.id, u.username, d.amount, d.donated_at, p.name AS place_name " +
                            "FROM history_donations d " +
                            "JOIN users u ON d.user_id = u.id " +
                            "JOIN places p ON d.place_id = p.id " +
                            "WHERE d.status='pending' " +
                            "ORDER BY d.donated_at DESC"
                        );
                        while(rs.next()){
                %>
                <tr>
                    <td><%= pendingCounter++ %></td>
                    <td><%= rs.getString("username") %></td>
                    <td><%= rs.getDouble("amount") %> Ks</td>
                    <td><%= rs.getTimestamp("donated_at") %></td>
                    <td><%= rs.getString("place_name") %></td>
                    <td>
                        <a class="btn btn-approve" href="approveDonation.jsp?id=<%= rs.getInt("id") %>">Approve</a>
                    </td>
                </tr>
                <%
                        }
                    } catch(Exception e){ out.println(e.getMessage()); }
                %>
            </table>
        </div>
    </div>

    <footer>
        &copy; 2025 WeatherDonation
    </footer>
</div>

</body>
</html>
