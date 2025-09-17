package API;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

public class AirPollutionAPI {
    private static final String API_KEY = "fc980b8bd67eeeaafa2ed2bc4af6251f"; // put your OpenWeather key here

    public static Map<String, Object> getAirPollution(double lat, double lon) {
        Map<String, Object> pollutionData = new HashMap<>();
        try {
            String apiUrl = String.format(
                "http://api.openweathermap.org/data/2.5/air_pollution?lat=%f&lon=%f&appid=%s",
                lat, lon, API_KEY
            );

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder content = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();
            conn.disconnect();

            JSONObject json = new JSONObject(content.toString());
            JSONArray list = json.getJSONArray("list");
            JSONObject main = list.getJSONObject(0).getJSONObject("main");

            int aqi = main.getInt("aqi"); // AQI: 1–5

            // Map AQI to category + description
            String category, description;
            switch (aqi) {
                case 1:
                    category = "Good";
                    description = "Air quality is considered satisfactory, and air pollution poses little or no risk.";
                    break;
                case 2:
                    category = "Fair";
                    description = "Air quality is generally acceptable, but sensitive groups may experience minor symptoms from long-term exposure.";
                    break;
                case 3:
                    category = "Moderate";
                    description = "Members of sensitive groups may experience health effects. The general public is less likely to be affected.";
                    break;
                case 4:
                    category = "Poor";
                    description = "Everyone may begin to experience health effects; members of sensitive groups may experience more serious effects.";
                    break;
                case 5:
                    category = "Very Poor";
                    description = "Health warnings of emergency conditions. The entire population is more likely to be affected.";
                    break;
                default:
                    category = "Unknown";
                    description = "No data available.";
            }

            JSONObject components = list.getJSONObject(0).getJSONObject("components");

            pollutionData.put("aqi", aqi);
            pollutionData.put("category", category);
            pollutionData.put("description", description);
            pollutionData.put("co", components.getDouble("co"));
            pollutionData.put("no2", components.getDouble("no2"));
            pollutionData.put("o3", components.getDouble("o3"));
            pollutionData.put("pm10", components.getDouble("pm10"));
            pollutionData.put("pm2_5", components.getDouble("pm2_5"));

        } catch (Exception e) {
            pollutionData.put("error", "Failed to fetch air pollution data: " + e.getMessage());
        }
        return pollutionData;
    }
}
