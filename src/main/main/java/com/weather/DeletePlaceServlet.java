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
import jakarta.servlet.http.HttpSession;

@WebServlet("/deletePlace")
public class DeletePlaceServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("adminDashboard.jsp?msg=Invalid+Place+ID");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM places WHERE id=?")) {
                ps.setInt(1, id);
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    response.sendRedirect("adminDashboard.jsp?msg=Place+deleted+successfully");
                } else {
                    response.sendRedirect("adminDashboard.jsp?msg=Place+not+found");
                }
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("adminDashboard.jsp?msg=Invalid+Place+ID");
        } catch (SQLException e) {
            throw new ServletException("Database error while deleting place", e);
        }
    }
}
