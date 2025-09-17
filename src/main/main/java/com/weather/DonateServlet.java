package com.weather;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/donate")
public class DonateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        String username = (session != null) ? (String) session.getAttribute("username") : null;

        if (username == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"status\":\"error\", \"message\":\"Not logged in\"}");
            return;
        }

        String placeIdStr = request.getParameter("placeId");
        String amountStr  = request.getParameter("amount");
        String email      = request.getParameter("email");
        String phone      = request.getParameter("phone");

        if (placeIdStr == null || amountStr == null || email == null || phone == null
                || placeIdStr.isEmpty() || amountStr.isEmpty() || email.isEmpty() || phone.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"error\", \"message\":\"All fields are required\"}");
            return;
        }

        int placeId;
        double amount;
        try {
            placeId = Integer.parseInt(placeIdStr.trim());
            amount = Double.parseDouble(amountStr.trim());
        } catch (NumberFormatException ex) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"error\", \"message\":\"Invalid number format for place or amount\"}");
            return;
        }

        // Validate phone number: must start with 09 and be 11 digits
        if (!phone.matches("^09\\d{9}$")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"error\", \"message\":\"Phone must start with 09 and be 11 digits\"}");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            int userId = -1;
            String dbEmail = null;
            try (PreparedStatement ps = conn.prepareStatement("SELECT id, email FROM users WHERE username=?")) {
                ps.setString(1, username);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("id");
                        dbEmail = rs.getString("email");
                    }
                }
            }
            if (userId == -1 || dbEmail == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\", \"message\":\"User not found\"}");
                return;
            }

            // Validate email matches logged-in user's email
            if (!dbEmail.equalsIgnoreCase(email.trim())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\", \"message\":\"Invalid email for this account\"}");
                return;
            }

            try (PreparedStatement ins = conn.prepareStatement(
                    "INSERT INTO history_donations(user_id, place_id, amount, donated_at, status, email, phone) " +
                    "VALUES (?, ?, ?, CURDATE(), 'pending', ?, ?)"
            )) {
                ins.setInt(1, userId);
                ins.setInt(2, placeId);
                ins.setDouble(3, amount);
                ins.setString(4, email.trim());
                ins.setString(5, phone.trim());

                int rows = ins.executeUpdate();
                if (rows > 0) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    out.print("{\"status\":\"success\", \"message\":\"Donation saved\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    out.print("{\"status\":\"error\", \"message\":\"Failed to save donation\"}");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"DB Error: " + e.getMessage().replace("\"","\\\"") + "\"}");
        }
    }
}
