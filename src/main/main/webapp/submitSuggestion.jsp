<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String suggestion = request.getParameter("suggestion");
    String email = (String) session.getAttribute("email");

    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message;
    String type;

    if (suggestion != null && !suggestion.trim().isEmpty()) {
        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/weatherdonation", "root", "");
             PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO suggestion (email, message, send_time) VALUES (?, ?, NOW())")) {

            Class.forName("com.mysql.cj.jdbc.Driver");
            ps.setString(1, email);
            ps.setString(2, suggestion.trim());
            ps.executeUpdate();

            message = "✅ Thank you! Your suggestion has been submitted.";
            type = "success";
        } catch (Exception e) {
            e.printStackTrace();
            message = "❌ Error saving suggestion. Please try again.";
            type = "error";
        }
    } else {
        message = "⚠️ Please enter your suggestion.";
        type = "warning";
    }

    // store in session, not URL
    session.setAttribute("message", message);
    session.setAttribute("type", type);

    response.sendRedirect("index.jsp");
%>
