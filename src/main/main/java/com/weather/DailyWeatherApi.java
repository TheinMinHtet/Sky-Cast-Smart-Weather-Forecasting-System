package com.weather;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

public class DailyWeatherApi {

    private static final String API_KEY = "fc980b8bd67eeeaafa2ed2bc4af6251f";

    // ✅ Forecast by city name
    public static List<Map<String, Object>> getDailyForecast(String cityName) throws Exception {
        double[] coords = getCoordinates(cityName);
        return getDailyForecastByCoords(coords[0], coords[1]);
    }

    // ✅ Forecast by coordinates
    public static List<Map<String, Object>> getDailyForecastByCoords(double lat, double lon) throws Exception {
        String apiUrl = "https://api.openweathermap.org/data/2.5/forecast?" +
                "lat=" + lat + "&lon=" + lon + "&appid=" + API_KEY + "&units=metric";

        System.out.println("Fetching forecast from: " + apiUrl);

        HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
        conn.setRequestMethod("GET");

        if (conn.getResponseCode() != 200) {
            throw new IOException("API Error: " + conn.getResponseMessage());
        }

        // Read and parse response
        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String response = bufferedReader.lines().collect(Collectors.joining());
        JSONObject json = new JSONObject(response);
        JSONArray list = json.getJSONArray("list");

        // Group forecasts by date
        Map<LocalDate, List<JSONObject>> dailyGroups = new HashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        for (int i = 0; i < list.length(); i++) {
            JSONObject item = list.getJSONObject(i);
            LocalDate date = LocalDate.parse(item.getString("dt_txt"), formatter);
            dailyGroups.computeIfAbsent(date, k -> new ArrayList<>()).add(item);
        }

        // Process each day's data
        List<Map<String, Object>> forecast = new ArrayList<>();
        DateTimeFormatter outFormatter = DateTimeFormatter.ofPattern("EEEE, MMM d", Locale.ENGLISH);

        int dayCount = 0;
        for (Map.Entry<LocalDate, List<JSONObject>> entry : dailyGroups.entrySet()) {
            if (dayCount >= 5) break;

            List<JSONObject> dayItems = entry.getValue();
            Map<String, Object> dayData = processDayData(dayItems, entry.getKey(), outFormatter);
            forecast.add(dayData);
            dayCount++;
        }

        return forecast;
    }

    private static Map<String, Object> processDayData(List<JSONObject> dayItems, LocalDate date,
                                                      DateTimeFormatter formatter) {
        Map<String, Object> dayData = new HashMap<>();

        // Basic info
        dayData.put("date", date.format(formatter));

        // Temperature stats
        JSONObject firstMain = dayItems.get(0).getJSONObject("main");
        double maxTemp = dayItems.stream()
                .mapToDouble(d -> d.getJSONObject("main").getDouble("temp_max"))
                .max().orElse(firstMain.getDouble("temp"));
        double minTemp = dayItems.stream()
                .mapToDouble(d -> d.getJSONObject("main").getDouble("temp_min"))
                .min().orElse(firstMain.getDouble("temp"));

        dayData.put("maxTemp", (int) Math.round(maxTemp));
        dayData.put("minTemp", (int) Math.round(minTemp));

        // Weather condition
        JSONObject weather = dayItems.get(0).getJSONArray("weather").getJSONObject(0);
        dayData.put("condition", capitalize(weather.getString("description")));
        dayData.put("icon", weather.getString("icon"));

        // Precipitation
        double totalRain = dayItems.stream()
                .filter(d -> d.has("rain"))
                .mapToDouble(d -> d.getJSONObject("rain").optDouble("3h", 0))
                .sum();
        double totalSnow = dayItems.stream()
                .filter(d -> d.has("snow"))
                .mapToDouble(d -> d.getJSONObject("snow").optDouble("3h", 0))
                .sum();

        dayData.put("rain", Math.round(totalRain * 10) / 10.0);
        dayData.put("snow", Math.round(totalSnow * 10) / 10.0);

        // Wind (convert m/s to km/h)
        double avgWindMps = dayItems.stream()
                .mapToDouble(d -> d.getJSONObject("wind").getDouble("speed"))
                .average().orElse(0);
        double avgWindKph = avgWindMps * 3.6;
        dayData.put("windSpeed", String.format("%.1f", avgWindKph));

        // Wind Direction (compass)
        String windDir = dayItems.stream()
                .mapToDouble(d -> {
                    JSONObject wind = d.getJSONObject("wind");
                    return wind.has("deg") ? wind.getDouble("deg") : -1;
                })
                .filter(deg -> deg >= 0)
                .average()
                .stream()
                .mapToObj(DailyWeatherApi::getWindDirectionFromDegrees)
                .findFirst()
                .orElse("Varies");
        dayData.put("windDirection", windDir); // ✅ FIXED: now included

        // RealFeel (feels_like)
        double avgRealFeel = dayItems.stream()
                .mapToDouble(d -> d.getJSONObject("main").getDouble("feels_like"))
                .average().orElse(firstMain.getDouble("temp"));
        dayData.put("realFeel", (int) Math.round(avgRealFeel));

        // Cloud Cover (%)
        double avgCloudCover = dayItems.stream()
                .mapToDouble(d -> d.getJSONObject("clouds").getInt("all"))
                .average().orElse(0);
        dayData.put("cloudCover", (int) Math.round(avgCloudCover));

        // Wind Gusts (max gust in m/s → convert to km/h)
        double maxWindGustMps = dayItems.stream()
                .filter(d -> d.getJSONObject("wind").has("gust"))
                .mapToDouble(d -> d.getJSONObject("wind").getDouble("gust"))
                .max().orElse(0);
        double maxWindGustKph = maxWindGustMps * 3.6;
        dayData.put("windGust", String.format("%.1f", maxWindGustKph));

        // Detailed forecast description
        dayData.put("detailedForecast", generateDailyDescription(dayItems));
        dayData.put("tempTrend", getTempTrend(dayItems));

        // Probability of precipitation
        double pop = dayItems.stream()
                .mapToDouble(d -> d.getDouble("pop") * 100)
                .average().orElse(0);
        dayData.put("precipProbability", (int) Math.round(pop));

        return dayData;
    }

    private static String generateDailyDescription(List<JSONObject> dayItems) {
        Map<String, Double> precip = new HashMap<>();
        dayItems.forEach(item -> {
            if (item.has("rain")) {
                precip.merge("Rain", item.getJSONObject("rain").optDouble("3h", 0), Double::sum);
            }
            if (item.has("snow")) {
                precip.merge("Snow", item.getJSONObject("snow").optDouble("3h", 0), Double::sum);
            }
        });

        Map<String, Integer> windFreq = new HashMap<>();
        dayItems.forEach(item -> {
            double speed = item.getJSONObject("wind").getDouble("speed") * 3.6;
            String desc = getWindDescription(speed);
            windFreq.merge(desc, 1, Integer::sum);
        });

        List<String> parts = new ArrayList<>();
        if (!precip.isEmpty()) {
            String precipDesc = precip.entrySet().stream()
                    .map(e -> {
                        String intensity = getPrecipIntensity(e.getValue());
                        return intensity + " " + e.getKey().toLowerCase() +
                                String.format(" (%.1fmm)", e.getValue());
                    })
                    .collect(Collectors.joining(", "));
            parts.add(precipDesc);
        }

        if (!windFreq.isEmpty()) {
            String windDesc = windFreq.entrySet().stream()
                    .max(Map.Entry.comparingByValue())
                    .map(Map.Entry::getKey)
                    .orElse("");
            parts.add(windDesc.toLowerCase() + " winds");
        }

        if (parts.isEmpty()) {
            String conditions = dayItems.stream()
                    .map(item -> item.getJSONArray("weather").getJSONObject(0)
                            .getString("description"))
                    .distinct()
                    .collect(Collectors.joining("/"));
            parts.add("mostly " + conditions.toLowerCase());
        }

        return String.join(", ", parts);
    }

    private static String getPrecipIntensity(double amount) {
        if (amount > 7.5) return "Heavy";
        if (amount > 2.5) return "Moderate";
        if (amount > 0.1) return "Light";
        return "Trace";
    }

    private static String getWindDescription(double speed) {
        if (speed < 1.5) return "Calm";
        if (speed < 5.5) return "Light";
        if (speed < 12) return "Gentle";
        if (speed < 19) return "Moderate";
        if (speed < 28) return "Fresh";
        if (speed < 38) return "Strong";
        if (speed < 49) return "Near gale";
        if (speed < 61) return "Gale";
        if (speed < 74) return "Strong gale";
        if (speed < 88) return "Storm";
        return "Hurricane";
    }

    private static String getTempTrend(List<JSONObject> dayItems) {
        if (dayItems.size() < 2) return "steady";
        double first = dayItems.get(0).getJSONObject("main").getDouble("temp");
        double last = dayItems.get(dayItems.size() - 1).getJSONObject("main").getDouble("temp");
        return last - first > 2 ? "rising" : first - last > 2 ? "falling" : "steady";
    }

    private static double[] getCoordinates(String cityName) throws Exception {
        String encodedCity = URLEncoder.encode(cityName, StandardCharsets.UTF_8);
        String apiUrl = "http://api.openweathermap.org/geo/1.0/direct?q=" +
                encodedCity + "&limit=1&appid=" + API_KEY;

        HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
        conn.setRequestMethod("GET");

        if (conn.getResponseCode() != 200) {
            throw new IOException("Geocoding failed: " + conn.getResponseMessage());
        }

        String response = new BufferedReader(new InputStreamReader(conn.getInputStream()))
                .lines().collect(Collectors.joining());
        JSONArray results = new JSONArray(response);

        if (results.length() == 0) {
            throw new Exception("Location not found: " + cityName);
        }

        JSONObject location = results.getJSONObject(0);
        return new double[]{location.getDouble("lat"), location.getDouble("lon")};
    }

    private static String capitalize(String str) {
        return str.isEmpty() ? str : str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
    }

    private static String getWindDirectionFromDegrees(double degrees) {
        String[] directions = {"N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"};
        int index = (int) ((degrees + 11.25) / 22.5) % 16;
        return directions[index];
    }

    // ✅ Example usage
    public static void main(String[] args) {
        try {
            String city = "London";
            List<Map<String, Object>> forecastByCity = getDailyForecast(city);

            System.out.println("\n5-Day Forecast for " + city + ":");
            forecastByCity.forEach(DailyWeatherApi::printForecast);

            double lat = 40.7128, lon = -74.0060; // New York
            List<Map<String, Object>> forecastByCoords = getDailyForecastByCoords(lat, lon);

            System.out.println("\n5-Day Forecast for Coordinates (" + lat + ", " + lon + "):");
            forecastByCoords.forEach(DailyWeatherApi::printForecast);

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static void printForecast(Map<String, Object> day) {
        System.out.printf(
                "%s | %s°/%s° | %s | RealFeel: %s° | Cloud: %s%% | Wind: %s km/h (%s) | Gust: %s km/h | POP: %d%% | %s\n",
                day.get("date"),
                day.get("maxTemp"),
                day.get("minTemp"),
                day.get("condition"),
                day.get("realFeel"),
                day.get("cloudCover"),
                day.get("windSpeed"),
                day.get("windDirection"),
                day.get("windGust"),
                day.get("precipProbability"),
                day.get("detailedForecast")
        );
    }
}
