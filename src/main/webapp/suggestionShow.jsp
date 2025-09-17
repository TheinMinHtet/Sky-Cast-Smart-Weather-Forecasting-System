<%@ page contentType="text/html;charset=UTF-8" session="true" %>
<%@ page import="java.sql.*, com.weather.DBConnection" %>
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
    <title>Admin Dashboard • User Suggestions</title>
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
        .scroll-table { width:100%; max-height:400px; overflow-y:auto; display:block; }
        .scroll-table table { width:100%; border-collapse:collapse; }
        .scroll-table th, .scroll-table td { text-align:left; padding:8px; border-bottom:1px solid #ddd; vertical-align:top; }
        .scroll-table th { background:#f2f2f2; }
        .description { white-space: normal; }
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

    <div class="section">
        <h3>All User Suggestions</h3>
        <div class="scroll-table">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Email</th>
                        <th>Suggestion</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int count = 1;
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        try {
                            conn = DBConnection.getConnection();
                            // Let DB return date-only to avoid timezone shifts
                            ps = conn.prepareStatement(
                                "SELECT email, message, DATE(send_time) AS send_date " +
                                "FROM suggestion ORDER BY send_time DESC"
                            );
                            rs = ps.executeQuery();
                            boolean hasData = false;
                            while(rs.next()) {
                                hasData = true;
                    %>
                    <tr>
                        <td><%= count++ %></td>
                        <td title="<%= rs.getString("email") %>"><%= rs.getString("email") %></td>
                        <td class="description"><%= rs.getString("message") %></td>
                        <td><%= rs.getString("send_date") %></td>
                    </tr>
                    <%
                            }
                            if (!hasData) {
                    %>
                    <tr>
                        <td colspan="4" style="text-align:center;">No suggestions found.</td>
                    </tr>
                    <%
                            }
                        } catch(Exception e) { 
                            out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if(rs != null) try { rs.close(); } catch(Exception ex) {}
                            if(ps != null) try { ps.close(); } catch(Exception ex) {}
                            if(conn != null) try { conn.close(); } catch(Exception ex) {}
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <footer>
        &copy; 2025 WeatherDonation
    </footer>
</div>

</body>
</html>
