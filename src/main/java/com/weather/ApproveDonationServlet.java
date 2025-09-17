package com.weather;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/approveDonation")
public class ApproveDonationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String donationId = request.getParameter("id");
        if (donationId == null || donationId.isEmpty()) {
            response.sendRedirect("adminDashboard.jsp?error=Invalid+donation+id");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE history_donations SET status='approved' WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(donationId));
            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("adminDashboard.jsp?success=Donation+Approved");
            } else {
                response.sendRedirect("adminDashboard.jsp?error=Donation+not+found");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("adminDashboard.jsp?error=Database+error");
        }
    }
}
