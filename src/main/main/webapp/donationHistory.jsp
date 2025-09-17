<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, com.weather.DBConnection" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String loginEmail = (String) session.getAttribute("email"); 
    if (username == null || loginEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // Format to date only
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Donation History • Weather Donation</title>
<style>
body { font-family: Arial, sans-serif; background:#f4f6f9; margin:0; }
header { background:#0275d8; color:#fff; padding:20px; text-align:center; }
nav { background:#2c3e50; padding:10px; text-align:center; }
nav a { color:#fff; text-decoration:none; margin:0 10px; padding:8px 15px; border-radius:5px; }
nav a:hover { background:#34495e; }
.container { padding:20px; }
h2 { color:#333; }
table { width:100%; border-collapse:collapse; margin-top:20px; }
th, td { border:1px solid #ddd; padding:10px; text-align:left; }
th { background:#0275d8; color:#fff; }
.message { background:#dff0d8; color:#3c763d; padding:15px; border-radius:8px; margin-bottom:20px; }
.no-data { text-align:center; color:#555; padding:15px; }
</style>
</head>
<body>
<header>
  <h1>Welcome, <%= username %></h1>
</header>
<nav>
  <a href="userHome.jsp">Back</a>
  <a href="logout">Logout</a>
</nav>

<div class="container">
  <h2>My Donation History</h2>
  <div class="message">
    🎉 Congratulations and thank you for your generous donations!
  </div>
  <table>
    <tr>
      <th>Amount</th><th>Email</th><th>Phone</th><th>Date</th><th>Place</th>
    </tr>
    <%
      try (Connection conn = DBConnection.getConnection()) {
          PreparedStatement ps = conn.prepareStatement(
            "SELECT h.*, p.name AS place_name " +
            "FROM history_donations h " +
            "JOIN places p ON h.place_id = p.id " +
            "WHERE h.email=? AND h.status='approved' " +
            "ORDER BY h.donated_at DESC"
          );
          ps.setString(1, loginEmail);
          ResultSet rs = ps.executeQuery();

          if (!rs.isBeforeFirst()) { // No rows
              out.println("<tr><td colspan='5' class='no-data'>You have not made any approved donations yet.</td></tr>");
          } else {
              while (rs.next()) {
                  java.sql.Timestamp ts = rs.getTimestamp("donated_at");
                  String dateOnly = ts != null ? sdf.format(ts) : "-";
    %>
    <tr>
      <td><%= rs.getBigDecimal("amount") != null ? rs.getBigDecimal("amount") : "0" %></td>
      <td><%= rs.getString("email") != null ? rs.getString("email") : "-" %></td>
      <td><%= rs.getString("phone") != null ? rs.getString("phone") : "-" %></td>
      <td><%= dateOnly %></td>
      <td><%= rs.getString("place_name") != null ? rs.getString("place_name") : "-" %></td>
    </tr>
    <%
              }
          }
          rs.close();
          ps.close();
      } catch (Exception e) {
          out.println("<tr><td colspan='5' style='color:red; text-align:center;'>"+e.getMessage()+"</td></tr>");
      }
    %>
  </table>
</div>
</body>
</html>
