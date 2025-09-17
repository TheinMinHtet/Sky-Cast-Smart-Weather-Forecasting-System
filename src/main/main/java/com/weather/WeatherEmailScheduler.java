package com.weather;

import java.sql.*;
import java.time.*;
import java.util.concurrent.*;

public class WeatherEmailScheduler {

    private static final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

    // Start the daily email task
    public static void startDailyEmailTask() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT email_time FROM admin_settings WHERE id=1")) {

            if (rs.next()) {
                Time emailTime = rs.getTime("email_time");
                if (emailTime != null) {
                    LocalTime targetTime = emailTime.toLocalTime();
                    LocalDateTime now = LocalDateTime.now();
                    LocalDateTime nextRun = now.withHour(targetTime.getHour())
                                               .withMinute(targetTime.getMinute())
                                               .withSecond(0)
                                               .withNano(0);

                    // If target time passed today, schedule for tomorrow
                    if (now.isAfter(nextRun)) {
                        nextRun = nextRun.plusDays(1);
                    }

                    long initialDelay = Duration.between(now, nextRun).getSeconds();
                    long period = TimeUnit.DAYS.toSeconds(1); // repeat every 24 hours

                    // Schedule at fixed rate
                    scheduler.scheduleAtFixedRate(() -> sendWeatherToAllUsers(),
                            initialDelay, period, TimeUnit.SECONDS);

                    System.out.println("✅ Next email scheduled at: " + nextRun);
                }
            }
        } catch (Exception e) {
            System.err.println("❌ Failed to start daily email task:");
            e.printStackTrace();
        }
    }

    // Send email to all users with their chosen city
    public static void sendWeatherToAllUsers() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT email, city FROM users WHERE email IS NOT NULL")) {

            while (rs.next()) {
                String userEmail = rs.getString("email");
                String city = rs.getString("city"); // user-chosen city
                try {
                    WeatherEmailSender.sendWeatherEmail(userEmail, city); // send email with city
                    System.out.println("✅ Email sent to: " + userEmail + " (" + city + ")");
                } catch (Exception e) {
                    System.err.println("❌ Failed to send to " + userEmail + " (" + city + ")");
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            System.err.println("❌ Failed to send weather emails to all users:");
            e.printStackTrace();
        }
    }

    // Stop scheduler gracefully
    public static void stopScheduler() {
        scheduler.shutdown();
        try {
            if (!scheduler.awaitTermination(5, TimeUnit.SECONDS)) {
                scheduler.shutdownNow();
            }
        } catch (InterruptedException e) {
            scheduler.shutdownNow();
        }
    }

    // For testing manually
    public static void main(String[] args) {
        startDailyEmailTask(); // Starts the scheduler
    }
}
