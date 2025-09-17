package API;

import org.json.JSONObject;
import java.io.*;
import java.net.*;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class CurrentWeatherApi {
    private static final String API_KEY = "fc980b8bd67eeeaafa2ed2bc4af6251f";

    public static Map<String, Object> getCurrentWeather(String location) throws Exception {
        String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=" +
                URLEncoder.encode(location, "UTF-8") +
                "&appid=" + API_KEY +
                "&units=metric";
        return fetchWeather(apiUrl);
    }

    // ✅ Updated method for lat/lon with reverse geocoding
    public static Map<String, Object> getCurrentWeatherByCoords(double lat, double lon) throws Exception {
        String apiUrl = "https://api.openweathermap.org/data/2.5/weather?lat=" +
                lat + "&lon=" + lon +
                "&appid=" + API_KEY +
                "&units=metric";

        Map<String, Object> data = fetchWeather(apiUrl);

        // 🔹 Reverse geocoding with OpenStreetMap Nominatim API
        try {
            String nominatimUrl = "https://nominatim.openstreetmap.org/reverse?format=json&lat=" +
                    lat + "&lon=" + lon + "&zoom=18&addressdetails=1&accept-language=en";

            HttpURLConnection conn = (HttpURLConnection) new URL(nominatimUrl).openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("User-Agent", "Mozilla/5.0");

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder content = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) {
                content.append(line);
            }
            in.close();

            JSONObject json = new JSONObject(content.toString());
            JSONObject address = json.getJSONObject("address");

            // Try to get a township/locality name
            String township = "";
            if (address.has("suburb")) {
                township = address.getString("suburb");
            } else if (address.has("neighbourhood")) {
                township = address.getString("neighbourhood");
            } else if (address.has("city")) {
                township = address.getString("city");
            } else if (address.has("town")) {
                township = address.getString("town");
            }

            // Fallback to OpenWeather location name
            if (township.isEmpty()) {
                township = (String) data.get("location");
            }

            data.put("location", township);

        } catch (Exception e) {
            // If reverse geocoding fails, just keep OpenWeather name
            System.out.println("Reverse geocoding failed: " + e.getMessage());
        }

        return data;
    }

    // ✅ Shared fetch logic
    private static Map<String, Object> fetchWeather(String apiUrl) throws Exception {
        HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
        conn.setRequestMethod("GET");

        if (conn.getResponseCode() != 200) {
            throw new IOException("API Error: " + conn.getResponseMessage());
        }

        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder content = new StringBuilder();
        String line;
        while ((line = in.readLine()) != null) {
            content.append(line);
        }
        in.close();

        JSONObject json = new JSONObject(content.toString());
        JSONObject main = json.getJSONObject("main");
        JSONObject wind = json.getJSONObject("wind");
        JSONObject clouds = json.getJSONObject("clouds");
        JSONObject sys = json.getJSONObject("sys");

        long sunrise = sys.getLong("sunrise");
        long sunset = sys.getLong("sunset");

        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("h:mm a")
                .withZone(ZoneId.systemDefault());

        LocalDate today = LocalDate.now();
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEEE, MMMM d", Locale.ENGLISH);
        String formattedDate = today.format(dateFormatter);

        LocalTime now = LocalTime.now();
        DateTimeFormatter timeFormatter12h = DateTimeFormatter.ofPattern("h:mm a", Locale.ENGLISH);
        String formattedTime = now.format(timeFormatter12h);

        Map<String, Object> data = new HashMap<>();
        JSONObject coord = json.getJSONObject("coord");
        data.put("lat", coord.getDouble("lat"));
        data.put("lon", coord.getDouble("lon"));
        data.put("location", json.optString("name", "Unknown"));
        data.put("date", formattedDate);
        data.put("time", formattedTime);
        data.put("temp", main.getDouble("temp"));
        data.put("feelsLike", main.getDouble("feels_like"));
        data.put("humidity", main.getInt("humidity"));
        data.put("pressure", main.getInt("pressure"));
        data.put("grndLevelPressure", main.has("grnd_level") ? main.getDouble("grnd_level") : -1.0);
        data.put("condition", json.getJSONArray("weather").getJSONObject(0).getString("description"));
        data.put("windGust", wind.has("gust") ? wind.getDouble("gust") : 0.0);
        data.put("cloudCover", clouds.getInt("all"));
        data.put("visibility", json.has("visibility") ? json.getInt("visibility") / 1000.0 : 0.0);
        data.put("sunrise", timeFormatter.format(Instant.ofEpochSecond(sunrise)));
        data.put("sunset", timeFormatter.format(Instant.ofEpochSecond(sunset)));

        return data;
    }
}
