package API;

import org.json.JSONArray;
import org.json.JSONObject;
import java.io.*;
import java.net.*;
import java.util.*;

public class HourlyAPI {
    private static final String API_KEY = "VOrjsNcASF02kG1tzKE3pA72QVSloW1d"; // replace with valid AccuWeather API key

    // ✅ Existing method (cityName)
    public static List<Map<String, String>> getHourlyWeather(String cityName) throws Exception {
        String locationKey = getLocationKey(cityName);
        return fetchHourlyForecast(locationKey);
    }

    // ✅ New method (lat/lon)
    public static List<Map<String, String>> getHourlyWeatherByCoords(double lat, double lon) throws Exception {
        String locationKey = getLocationKeyByCoords(lat, lon);
        return fetchHourlyForecast(locationKey);
    }

    // 🔹 Fetch hourly forecast given a location key
    private static List<Map<String, String>> fetchHourlyForecast(String locationKey) throws Exception {
        String apiUrl = "https://dataservice.accuweather.com/forecasts/v1/hourly/12hour/" +
                locationKey + "?apikey=" + API_KEY + "&metric=true";

        HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
        conn.setRequestMethod("GET");

        if (conn.getResponseCode() != 200) {
            handleApiError(conn, "Forecast API");
        }

        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder content = new StringBuilder();
        String line;
        while ((line = in.readLine()) != null) {
            content.append(line);
        }
        in.close();

        JSONArray jsonArray = new JSONArray(content.toString());
        List<Map<String, String>> hourlyData = new ArrayList<>();

        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            Map<String, String> hourInfo = new HashMap<>();

            String dateTime = obj.getString("DateTime");
            String hour = dateTime.substring(11, 16); // HH:mm

            hourInfo.put("time", hour);
            hourInfo.put("icon", String.valueOf(obj.getInt("WeatherIcon")));
            hourInfo.put("iconPhrase", obj.getString("IconPhrase"));
            hourInfo.put("temp", String.format("%.0f", obj.getJSONObject("Temperature").getDouble("Value")));
            hourInfo.put("precip", String.valueOf(obj.getInt("PrecipitationProbability")));

            hourlyData.add(hourInfo);
        }

        return hourlyData;
    }

    // 🔹 Search location key by city
    private static String getLocationKey(String cityName) throws Exception {
        String encodedCity = URLEncoder.encode(cityName, "UTF-8");
        String searchUrl = "https://dataservice.accuweather.com/locations/v1/cities/search?q=" +
                encodedCity + "&apikey=" + API_KEY;

        HttpURLConnection conn = (HttpURLConnection) new URL(searchUrl).openConnection();
        conn.setRequestMethod("GET");

        if (conn.getResponseCode() != 200) {
            handleApiError(conn, "Location Search API");
        }

        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder content = new StringBuilder();
        String line;
        while ((line = in.readLine()) != null) {
            content.append(line);
        }
        in.close();

        JSONArray results = new JSONArray(content.toString());
        if (results.length() == 0) {
            throw new Exception("❌ No location found for: '" + cityName + "'");
        }
        return results.getJSONObject(0).getString("Key");
    }

    // 🔹 Search location key by lat/lon
    private static String getLocationKeyByCoords(double lat, double lon) throws Exception {
        String searchUrl = "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search" +
                "?apikey=" + API_KEY + "&q=" + lat + "," + lon;

        HttpURLConnection conn = (HttpURLConnection) new URL(searchUrl).openConnection();
        conn.setRequestMethod("GET");

        if (conn.getResponseCode() != 200) {
            handleApiError(conn, "Geoposition API");
        }

        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder content = new StringBuilder();
        String line;
        while ((line = in.readLine()) != null) {
            content.append(line);
        }
        in.close();

        JSONObject result = new JSONObject(content.toString());
        return result.getString("Key");
    }

    private static void handleApiError(HttpURLConnection conn, String apiName) throws IOException {
        BufferedReader err = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        StringBuilder errorMsg = new StringBuilder();
        String line;
        while ((line = err.readLine()) != null) {
            errorMsg.append(line);
        }
        err.close();
        throw new IOException(apiName + " Error (" + conn.getResponseCode() + "): " + conn.getResponseMessage() + " | " + errorMsg.toString());
    }

    // ✅ Test both methods
    public static void main(String[] args) {
        try {
            // By city name
            String city = "Sydney";
            List<Map<String, String>> forecastCity = getHourlyWeather(city);
            System.out.println("🌤️ Forecast for " + city + ": " + forecastCity.size() + " entries");

            // By coords
            double lat = -33.8688, lon = 151.2093; // Sydney coords
            List<Map<String, String>> forecastCoords = getHourlyWeatherByCoords(lat, lon);
            System.out.println("🌍 Forecast by coords (" + lat + "," + lon + "): " + forecastCoords.size() + " entries");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
