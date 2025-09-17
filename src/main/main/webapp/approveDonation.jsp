<%@ page import="java.sql.*, com.weather.DBConnection" %>
<%
    String id = request.getParameter("id");
    if (id != null) {
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE history_donations SET status='approved' WHERE id=?"
            );
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
    response.sendRedirect("adminDashboard.jsp");
%>
