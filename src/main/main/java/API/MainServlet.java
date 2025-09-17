package API;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.*;
import java.util.*;

public class MainServlet extends HttpServlet {
    private static final String API_KEY = "fc980b8bd67eeeaafa2ed2bc4af6251f";

    @SuppressWarnings("unchecked")
	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("\n=== New Request ===");
        System.out.println("Query String: " + request.getQueryString());

        // Handle radar tile requests first
        if (request.getServletPath() != null && request.getServletPath().contains("radar")) {
            handleRadarTile(request, response);
            return;
        }

        HttpSession session = request.getSession();

        String location = request.getParameter("location");
        String latStr   = request.getParameter("lat");
        String lonStr   = request.getParameter("lon");

        try {
            Map<String, Object> weatherData = null;
            List<Map<String, Object>> dailyData = null;
            Map<String, Object> pollutionData = null;
            // List<Map<String, String>> hourlyData = null;

            // ✅ Check if session already has cached data for the same location/coords
            boolean useCache = false;
            if (latStr != null && lonStr != null) {
                String cachedLat = (String) session.getAttribute("latStr");
                String cachedLon = (String) session.getAttribute("lonStr");
                if (latStr.equals(cachedLat) && lonStr.equals(cachedLon)) {
                    useCache = true;
                }
            } else if (location != null && !location.trim().isEmpty()) {
                String cachedLocation = (String) session.getAttribute("location");
                if (location.equals(cachedLocation)) {
                    useCache = true;
                }
            }

            if (useCache) {
                weatherData = (Map<String, Object>) session.getAttribute("weatherData");
                dailyData   = (List<Map<String, Object>>) session.getAttribute("dailyData");
                pollutionData = (Map<String, Object>) session.getAttribute("pollutionData");

                // Use lat/lon for JSP navbar
                Double lat = (Double) session.getAttribute("lat");
                Double lon = (Double) session.getAttribute("lon");
                request.setAttribute("lat", lat);
                request.setAttribute("lon", lon);
            } else {
                // ✅ Case 1: Use coordinates
                if (latStr != null && lonStr != null) {
                    double lat = Double.parseDouble(latStr);
                    double lon = Double.parseDouble(lonStr);
                    System.out.println("Using coordinates: " + lat + ", " + lon);

                    weatherData = CurrentWeatherApi.getCurrentWeatherByCoords(lat, lon);
                    dailyData   = DailyWeatherApi.getDailyForecastByCoords(lat, lon);
                    pollutionData = AirPollutionAPI.getAirPollution(lat, lon);
                    // hourlyData = HourlyAPI.getHourlyWeatherByCoords(lat, lon);

                    request.setAttribute("lat", lat);
                    request.setAttribute("lon", lon);

                    // ✅ Save to session
                    session.setAttribute("latStr", latStr);
                    session.setAttribute("lonStr", lonStr);
                    session.setAttribute("weatherData", weatherData);
                    session.setAttribute("dailyData", dailyData);
                    session.setAttribute("pollutionData", pollutionData);
                    // session.setAttribute("hourlyData", hourlyData);

                    session.setAttribute("lat", lat);  
                    session.setAttribute("lon", lon); 
                } else if (location != null && !location.trim().isEmpty()) {
                    // ✅ Case 2: Use city name
                    System.out.println("Using location: " + location);

                    weatherData = CurrentWeatherApi.getCurrentWeather(location);
                    dailyData   = DailyWeatherApi.getDailyForecast(location);
                    // hourlyData = HourlyAPI.getHourlyWeather(location);

                    double lat = (double) weatherData.get("lat");
                    double lon = (double) weatherData.get("lon");
                    pollutionData = AirPollutionAPI.getAirPollution(lat, lon);

                    request.setAttribute("lat", lat);
                    request.setAttribute("lon", lon);

                    // ✅ Save to session
                    session.setAttribute("location", location);
                    session.setAttribute("lat", lat);
                    session.setAttribute("lon", lon);
                    session.setAttribute("weatherData", weatherData);
                    session.setAttribute("dailyData", dailyData);
                    session.setAttribute("pollutionData", pollutionData);
                    // session.setAttribute("hourlyData", hourlyData);
                    session.setAttribute("lat", lat);   // ✅ add this
                    session.setAttribute("lon", lon); 

                } else {
                    // ✅ Case 3: Nothing provided → fallback default
                    System.out.println("No location provided, defaulting to Yangon");
                    weatherData = CurrentWeatherApi.getCurrentWeather("Yangon");
                    dailyData   = DailyWeatherApi.getDailyForecast("Yangon");
                    // hourlyData = HourlyAPI.getHourlyWeather("Yangon");

                    double lat = (double) weatherData.get("lat");
                    double lon = (double) weatherData.get("lon");
                    pollutionData = AirPollutionAPI.getAirPollution(lat, lon);

                    request.setAttribute("lat", lat);
                    request.setAttribute("lon", lon);

                    // ✅ Save to session
                    session.setAttribute("location", "Yangon");
                    session.setAttribute("lat", lat);
                    session.setAttribute("lon", lon);
                    session.setAttribute("weatherData", weatherData);
                    session.setAttribute("dailyData", dailyData);
                    session.setAttribute("pollutionData", pollutionData);
                    // session.setAttribute("hourlyData", hourlyData);
                    session.setAttribute("lat", lat);   // ✅ add this
                    session.setAttribute("lon", lon); 
                }
            }

            // Attach results for JSP
            request.setAttribute("weatherData", weatherData);
            request.setAttribute("dailyData", dailyData);
            request.setAttribute("pollutionData", pollutionData);
            // request.setAttribute("hourlyData", hourlyData);

         // Routing by ?page=...
            String page = request.getParameter("page");
            String jspPage;
            if ("today".equals(page)) {
                jspPage = "today_weather.jsp";
            } else if ("hourly".equals(page)) {
                jspPage = "hourly_weather.jsp";
            } else if ("daily".equals(page)) {
                jspPage = "daily_weather.jsp";
            } else if ("airquality".equals(page)) {
                jspPage = "air_quality.jsp";
            } else if ("radar".equals(page)) {
                jspPage = "radar.jsp";
            } else if ("health".equals(page)) {
                // ✅ CORRECT WAY: Forward to HealthServlet WITH location
                request.setAttribute("location", location);
                request.getRequestDispatcher("/health").forward(request, response);
                return; // Critical: stop further processing
            } else {
                jspPage = "today_weather.jsp"; // fallback
            }

            // Only forward for non-health pages
            if (!"health".equals(page)) {
                request.getRequestDispatcher(jspPage).forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching weather: " + e.getMessage());
            request.getRequestDispatcher("today_weather.jsp").forward(request, response);
        }
    }

    private void handleRadarTile(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET");

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.split("/").length < 5) {
            response.sendError(400, "Invalid tile path format");
            return;
        }

        String[] parts = pathInfo.split("/");
        String layer = parts[1];
        String z = parts[2];
        String x = parts[3];
        String y = parts[4].replace(".png", "");

        String urlStr = "https://tile.openweathermap.org/map/" +
                layer + "_new/" + z + "/" + x + "/" + y + ".png?appid=" + API_KEY;

        try {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            if (conn.getResponseCode() != 200) {
                response.sendError(502, "Failed to fetch tile");
                return;
            }

            response.setContentType("image/png");
            response.setHeader("Cache-Control", "public, max-age=300");

            try (InputStream in = conn.getInputStream();
                 OutputStream out = response.getOutputStream()) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
        } catch (Exception e) {
            response.sendError(500, "Tile fetch error: " + e.getMessage());
        }
    }
}
