package API;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.net.URL;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/health")
public class HealthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // ⚠️ Replace with your real OpenWeatherMap API key
    private static final String API_KEY = "fc980b8bd67eeeaafa2ed2bc4af6251f";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. Try request parameter (?location=...)
        String location = request.getParameter("location");

        // 2. If missing, try session
        if ((location == null || location.isBlank()) && session != null) {
            location = (String) session.getAttribute("location");
        }

        // 3. If still missing, default
        if (location == null || location.isBlank()) {
            location = "Yangon";
        }

        // 4. Fetch temperature
        Double temperature = null;
        try {
            temperature = fetchTemperature(location);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 5. Store attributes for JSP
        request.setAttribute("location", location);
        request.setAttribute("temperature", temperature);

        // (Optional) Add suggestion or activity cards
        if (temperature != null) {
            request.setAttribute("suggestion", suggest(temperature));
            //request.setAttribute("cards", buildCards(temperature));
        }

        // 6. Forward to JSP
        request.getRequestDispatcher("health.jsp").forward(request, response);
    }
    
    private String suggest(double temperature) {
        if (temperature < 15) {
            return "It's cold. Wear warm clothes and do light indoor exercises.";
        } else if (temperature < 25) {
            return "Perfect weather! Go jogging, cycling, or play outdoor sports.";
        } else if (temperature < 35) {
            return "It's warm. Drink water and do light outdoor activities.";
        } else {
            return "Too hot! Stay indoors, drink water, and avoid heavy exercise.";
        }
    }
    
    private double fetchUVIndex(double lat, double lon) throws IOException {
        String uvUrl = "https://api.openweathermap.org/data/2.5/onecall?lat=" + lat +
                "&lon=" + lon + "&appid=" + API_KEY;

        URL url = new URL(uvUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        if (conn.getResponseCode() != 200) {
            return 0; // fallback
        }

        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            StringBuilder result = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                result.append(line);
            }
            JSONObject json = new JSONObject(result.toString());
            return json.getJSONArray("current").getJSONObject(0).getDouble("uvi");
        }
    }
    
    private HealthCard getColdRiskCard(double temp) {
        if (temp < 10) {
            return new HealthCard("Cold Exposure", "High", "bg-red-100", "text-red-800",
                    "It's very cold. Wear warm layers and limit outdoor time to avoid hypothermia.");
        } else if (temp < 15) {
            return new HealthCard("Cold Exposure", "Moderate", "bg-yellow-100", "text-yellow-800",
                    "It's chilly. Wear a jacket and stay warm, especially if you have respiratory issues.");
        } else {
            return new HealthCard("Cold Exposure", "Low", "bg-green-100", "text-green-800",
                    "Temperature is comfortable. No cold-related risks today.");
        }
    }

    private HealthCard getHeatRiskCard(double temp) {
        if (temp > 35) {
            return new HealthCard("Heat Risk", "Extreme", "bg-red-100", "text-red-800",
                    "Extreme heat! Stay indoors, drink water, and avoid exertion.");
        } else if (temp > 30) {
            return new HealthCard("Heat Risk", "High", "bg-orange-100", "text-orange-800",
                    "Hot weather. Stay hydrated and avoid midday sun.");
        } else if (temp > 25) {
            return new HealthCard("Heat Risk", "Moderate", "bg-yellow-100", "text-yellow-800",
                    "Warm day. Drink water and take breaks in shade if active.");
        } else {
            return new HealthCard("Heat Risk", "Low", "bg-green-100", "text-green-800",
                    "No heat concerns today.");
        }
    }

    private HealthCard getHumidityRiskCard(double humidity) {
        if (humidity > 80) {
            return new HealthCard("Humidity", "High", "bg-orange-100", "text-orange-800",
                    "High humidity can make breathing harder. Those with asthma should take precautions.");
        } else if (humidity > 60) {
            return new HealthCard("Humidity", "Moderate", "bg-yellow-100", "text-yellow-800",
                    "Humid conditions may feel sticky. Stay cool and hydrated.");
        } else {
            return new HealthCard("Humidity", "Low", "bg-green-100", "text-green-800",
                    "Humidity is comfortable.");
        }
    }

    private HealthCard getWindRiskCard(double windSpeed) {
        if (windSpeed > 20) {
            return new HealthCard("Wind", "High", "bg-orange-100", "text-orange-800",
                    "Windy conditions. Secure loose objects and avoid cycling.");
        } else if (windSpeed > 10) {
            return new HealthCard("Wind", "Moderate", "bg-yellow-100", "text-yellow-800",
                    "Breezy today. A light jacket will help.");
        } else {
            return new HealthCard("Wind", "Low", "bg-green-100", "text-green-800",
                    "Calm winds. Great for outdoor activities.");
        }
    }

    private HealthCard getUVRiskCard(double uvIndex) {
        if (uvIndex >= 11) {
            return new HealthCard("UV Index", "Extreme", "bg-red-100", "text-red-800",
                    "Extreme UV radiation. Avoid sun between 10am–4pm. Use SPF 50+.");
        } else if (uvIndex >= 8) {
            return new HealthCard("UV Index", "Very High", "bg-red-100", "text-red-800",
                    "Very high UV. Wear sunscreen, hat, and sunglasses.");
        } else if (uvIndex >= 6) {
            return new HealthCard("UV Index", "High", "bg-orange-100", "text-orange-800",
                    "High UV risk. Apply SPF 30+ and seek shade at midday.");
        } else if (uvIndex >= 3) {
            return new HealthCard("UV Index", "Moderate", "bg-yellow-100", "text-yellow-800",
                    "Moderate UV. Wear sunscreen if outside for more than 30 minutes.");
        } else {
            return new HealthCard("UV Index", "Low", "bg-green-100", "text-green-800",
                    "Low UV exposure. Sun protection generally not required.");
        }
    }
    
    private JSONObject fetchWeatherData(String city) throws IOException {
        String encodedCity = URLEncoder.encode(city, "UTF-8");
        String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=" +
                encodedCity + "&appid=" + API_KEY + "&units=metric";

        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        if (conn.getResponseCode() != 200) {
            throw new IOException("Failed to fetch weather data: HTTP " + conn.getResponseCode());
        }

        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            StringBuilder result = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                result.append(line);
            }
            return new JSONObject(result.toString());
        }
    }

    private Double fetchTemperature(String location) throws IOException {
        String encodedCity = URLEncoder.encode(location, "UTF-8");
        String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q="
                + encodedCity + "&appid=" + API_KEY + "&units=metric";

        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        if (conn.getResponseCode() != 200) {
            throw new IOException("Failed to fetch weather data: HTTP " + conn.getResponseCode());
        }

        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            StringBuilder result = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                result.append(line);
            }

            JSONObject json = new JSONObject(result.toString());
            return json.getJSONObject("main").getDouble("temp");
        }
    }
}
