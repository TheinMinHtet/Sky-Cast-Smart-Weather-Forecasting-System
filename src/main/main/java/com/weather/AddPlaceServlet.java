package com.weather;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/addPlace")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1MB
    maxFileSize = 1024 * 1024 * 5,    // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class AddPlaceServlet extends HttpServlet {

    // Persistent folder outside webapp
    private static final String UPLOAD_DIR = "C:/WeatherUploads"; // <-- Change path as needed

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");

        Part filePart = request.getPart("image");
        String fileName = null;

        if (filePart != null && filePart.getSize() > 0) {
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String submittedFileName = filePart.getSubmittedFileName();
            fileName = System.currentTimeMillis() + "_" + submittedFileName;

            File file = new File(uploadDir, fileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
        }

        // Save filename in DB
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO places(name, description, image_url) VALUES (?,?,?)"
            );
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setString(3, fileName);
            ps.executeUpdate();

            response.sendRedirect("adminDashboard.jsp?msg=Place+added+successfully");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
