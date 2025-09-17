package com.weather;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.sql.*;
import java.util.Map;
import java.util.Properties;

public class WeatherEmailSender {

    private static final String USERNAME = "kphoophooaung@gmail.com";
    private static final String APP_PASSWORD = "yirkpodmerbyjrqg";

    // Send weather email for a specific recipient and city
    public static void sendWeatherEmail(String recipientEmail, String city) throws Exception {
        // SMTP setup
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, APP_PASSWORD);
            }
        });
        session.setDebug(true); // Enable SMTP debug

        // Create email
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(USERNAME));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
        message.setSubject("🌤 Daily Weather Update");

        // Get weather dynamically for user's city
        Map<String, Object> weather = API.CurrentWeatherApi.getCurrentWeather(city);

        double temp = ((Number) weather.get("temp")).doubleValue();
        String condition = (String) weather.get("condition");
        int humidity = ((Number) weather.get("humidity")).intValue();

     // Add advice based on weather
        String advice;
        String lowerCondition = condition.toLowerCase();

        if (lowerCondition.contains("rain") || lowerCondition.contains("drizzle") || lowerCondition.contains("shower") || lowerCondition.contains("cloud")) {
            advice = "☔ It's rainy today, better take an umbrella!";
        } else if (lowerCondition.contains("storm") || lowerCondition.contains("thunder")) {
            advice = "⚡ Thunderstorms expected — stay indoors if possible!";
        } else if (temp >= 35) {
            advice = "💧 It's very hot outside, drink plenty of water and avoid staying under the sun too long.";
        } else if (temp <= 15) {
            advice = "🧥 It's quite cold today, wear warm clothes if you're going out.";
        } else if (lowerCondition.contains("wind")) {
            advice = "🌬️ Strong winds today, be careful if you're outside.";
        } else {
            advice = "✅ Have a great day!";
        }


        String content = String.format(
            "Hello!\n\nToday's weather for %s:\nTemperature: %.1f°C\nCondition: %s\nHumidity: %d%%\n\n%s\n\nStay safe!\nSkyCast Team",
            weather.get("location"),
            temp,
            condition,
            humidity,
            advice
        );

        message.setText(content);

        // Send email
        Transport.send(message);
        System.out.println("✅ Email sent successfully to: " + recipientEmail + " (" + city + ")");
    }

    // Send emails to all users in the database
    public static void sendWeatherToAllUsers() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT email, city FROM users WHERE email IS NOT NULL")) {

            while (rs.next()) {
                String email = rs.getString("email");
                String city = rs.getString("city");
                try {
                    sendWeatherEmail(email, city);
                } catch (Exception e) {
                    System.out.println("❌ Failed to send email to " + email + " (" + city + ")");
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // For testing one email
    public static void main(String[] args) {
        try {
            sendWeatherEmail("khinphoophooaung413@gmail.com", "Yangon");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
