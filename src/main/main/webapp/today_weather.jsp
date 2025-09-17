<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
  	<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <title>Weather Result</title>
</head>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function () {
    const lat = ${lat != null ? lat : 20};
    const lon = ${lon != null ? lon : 0};
    const locationName = "${weatherData['location'] != null ? weatherData['location'] : 'Unknown'}";

    // Create map
    const map = L.map('radar-map').setView([lat, lon], 6);

    // Base map
    const osm = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; OpenStreetMap contributors'
    }).addTo(map);

    // Radar layers
    const precipitation = L.tileLayer('./radar/precipitation/{z}/{x}/{y}.png', {
        attribution: 'Radar: © OpenWeather',
        opacity: 0.6,
        maxZoom: 10
    });

    const clouds = L.tileLayer('./radar/clouds/{z}/{x}/{y}.png', {
        opacity: 0.6,
        maxZoom: 10
    });

    const temp = L.tileLayer('./radar/temp/{z}/{x}/{y}.png', {
        opacity: 0.6,
        maxZoom: 10
    });

    const wind = L.tileLayer('./radar/wind/{z}/{x}/{y}.png', {
        opacity: 0.6,
        maxZoom: 10
    });

    const pressure = L.tileLayer('./radar/pressure/{z}/{x}/{y}.png', {
        opacity: 0.6,
        maxZoom: 10
    });

    // ✅ Add default layer
    precipitation.addTo(map);

 // ✅ Put all layers in one object
    const layers = {
        precipitation,
        clouds,
        temp,
        wind,
        pressure
    };

    // ✅ Radio button logic
    document.querySelectorAll('input[name="radarLayer"]').forEach(radio => {
        radio.addEventListener("change", function () {
            // Remove all layers
            Object.values(layers).forEach(layer => map.removeLayer(layer));
            // Add selected layer
            layers[this.value].addTo(map);
        });
    });

    // ✅ Add marker
    const marker = L.marker([lat, lon]).addTo(map)
        .bindPopup("${weatherData != null ? weatherData.location : 'Unknown'}")
.openPopup();

    // ✅ Fit bounds or auto-zoom (see next section)
    map.setView([lat, lon], 10); // Good default for cities

    // Optional: Animate zoom
    map.flyTo([lat, lon], 10, {
        duration: 1.5,
        easeLinearity: 0.7
    });
});
</script>

<body>
<jsp:include page="header.jsp" />

<%-- Check for error --%>
<%
    String error = (String) request.getAttribute("error");
    if (error != null) {
%>
    <div class="alert alert-danger text-center mt-4">
        <i class="fas fa-exclamation-triangle"></i>
        <%= error %>
    </div>
    <jsp:include page="footer.jsp" />
<%
    return;
    }
%>

<%-- Weather Display --%>
<div class="container mt-3 mb-3">
  
  <!-- Row 1: Current Weather + Top Stories -->
  <div class="row g-3 mb-3 justify-content-center">

    <!-- Current Weather -->
    <div class="col-lg-6 col-md-12">
      <div class="weather-container mb-4 mt-0">
        <p class="mb-1 text-center">${weatherData.date}</p>
        <div class="shadow">
          <div class="weather-header bg-custom-header rounded-top-2 d-flex justify-content-between align-items-center px-3">
            <h6 class="mb-0 py-2 text-dark">Current Weather</h6>
            <p class="mb-0 text-dark">${weatherData.time}</p>
          </div>

          <div class="weather-summary ">
            <div class="weather-icon">
              <i class="fas 
                <% 
                  String condition = (String) request.getAttribute("condition");
                  if (condition != null && condition.toLowerCase().contains("clear")) {
                      out.print("fa-sun");
                  } else if (condition != null && condition.toLowerCase().contains("cloud")) {
                      out.print("fa-cloud");
                  } else if (condition != null && condition.toLowerCase().contains("rain")) {
                      out.print("fa-cloud-rain");
                  } else {
                      out.print("fa-smog");
                  }
                %>
              "></i>
            </div>
            <div class="ms-4">
              <p class="fs-3 ps-2">${weatherData.location}</p>
              <p class="weather-temp">${weatherData.temp}°C</p>
              <p class="weather-condition ps-2">${weatherData.condition}</p>
              <p class="realfeel ps-2">RealFeel ~ ${weatherData.feelsLike}°</p>
            </div>
          </div>

          <div class="card-body">
            <table class="table weather-detail-table mb-0">
              <tr>
                <th>Wind Gusts</th>
                <td>${weatherData.windGust} km/h</td>
                <th>Pressure</th>
                <td>${weatherData.pressure} mb</td>
              </tr>
              <tr>
                <th>Humidity</th>
                <td>${weatherData.humidity}%</td>
                <th>Cloud Cover</th>
                <td>${weatherData.cloudCover}%</td>
              </tr>
              <tr>
                <th>Visibility</th>
                <td>${weatherData.visibility} km</td>
                <th>Ground-Level-Pressure</th>
                <td>${weatherData.grndLevelPressure} hPa</td>
              </tr>
            </table>
          </div>
        </div>
      </div>
      <div class="card mb-4 shadow mt-4" style="max-width: 600px;">
        <div class="card-header bg-custom-header">Sun</div>

			<!-- Sunrise and Sunset Information -->
            <ul class="list-group list-group-flush">
              
              <!-- Sunrise -->
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <div>
                  <i class="fa-solid fa-sun pe-2 text-warning"></i> Sunrise
                </div>
                <span>${weatherData.sunrise}</span>
              </li>

              <!-- Sunset -->
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <div>
                  <i class="fa-solid fa-moon pe-2 ps-1 text-primary"></i> Sunset
                </div>
                <span>${weatherData.sunset}</span>
              </li>

            </ul>
          </div>
    
    <!-- Hourly Forecast Section -->
	<div class="card mb-4 shadow mt-4" style="max-width: 600px; border-radius: 10px;">
    <div class="card-header bg-custom-header">Hourly Weather</div>
    <div class="d-flex overflow-auto">
        <c:forEach var="hour" items="${hourlyData}">
            <div class="hourly-card text-center mx-2 p-3">
                <p class="mb-1 fw-semibold">${hour.time}</p>

                <c:set var="iconCode" value="${hour.icon lt 10 ? '0' : ''}${hour.icon}" />
                <img src="https://developer.accuweather.com/sites/default/files/${iconCode}-s.png"
                     alt="${hour.iconPhrase}"
                     class="weather-icon-1 mb-2"
                     width="32" height="24">


                <p class="mb-1 fs-5 fw-bold">${hour.temp}°C</p>
                <p class="small text-muted mb-0">
                    <i class="bi bi-droplet"></i> ${hour.precip}%
                </p>
            </div>
        </c:forEach>
    </div>
</div>
	<!-- Daily Forecast (New Card) -->
            <div class="card shadow" style="max-width: 600px; border-radius: 10px;">
                <div class="card-header bg-white py-3 px-3 bg-custom-header">
                    <h6 class="mb-0 text-uppercase">5-DAY WEATHER FORECAST</h6>
                </div>
                <div class="list-group list-group-flush">
                    <c:forEach items="${dailyData}" var="day" varStatus="status">
                        <div class="list-group-item px-4 py-3 border-bottom">
                            <div class="row align-items-center">
                                <div class="col-3">
                                    <c:choose>
                                        <c:when test="${status.index == 0}">
                                            <div class="fw-bold">TONIGHT</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="fw-bold">${fn:substringBefore(day.date, ',')}</div>
                                        </c:otherwise>
                                    </c:choose>
                                    <small class="text-muted">${fn:substringAfter(day.date, ',')}</small>
                                </div>
                                <div class="col-1 d-flex align-items-center">
                                    <img src="https://openweathermap.org/img/wn/${day.icon}@2x.png"
                                         alt="${day.condition}" width="32">
                                </div>
                                <div class="col-2">
                                    <span class="fs-4 fw-bold">${day.maxTemp}°</span>
                                    <small class="text-muted">${day.minTemp}°</small>
                                </div>
                                <div class="col-4">
                                    <div class="fw-medium">${day.condition}</div>
                                    <small class="text-muted">${day.detailedForecast}</small>
                                </div>
                                <div class="col-2 text-end">
                                    <i class="fas fa-cloud-rain"></i> <small>${day.rain}%</small>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
	       </div>
	       <!-- Radar Map Card -->

		    <div class="card shadow mt-4" style="max-width: 600px; border-radius: 10px;">
		        <div class="card-header bg-custom-header">
		            <h6 class="mb-0 text-uppercase fw-bold">Weather Radar</h6>
		        </div>
		        <div class="card-body p-0">
		        	<div id="radar-controls" 
					     style="background:white; padding:10px; border-radius:8px; position:absolute; top:40px; right:10px; z-index:1000; box-shadow:0 2px 6px rgba(0,0,0,0.2);">
					  <label><input type="radio" name="radarLayer" value="precipitation" checked> 🌧️ Precipitation</label><br>
					  <label><input type="radio" name="radarLayer" value="clouds"> ☁️ Clouds</label><br>
					  <label><input type="radio" name="radarLayer" value="temp"> 🌡️ Temperature</label><br>
					  <label><input type="radio" name="radarLayer" value="wind"> 💨 Wind Speed</label><br>
					  <label><input type="radio" name="radarLayer" value="pressure"> 🔽 Pressure</label>
					</div>
		            <div id="radar-map" style="height: 400px; width: 100%;"></div>
		        </div>
		    </div>
		    
		    	<c:if test="${not empty pollutionData}">

				    <!-- Set dynamic color -->
				    <c:choose>
				        <c:when test='${pollutionData.aqi == 1}'>
				            <c:set var="aqiColor" value="#28a745"/> <!-- Green -->
				        </c:when>
				        <c:when test='${pollutionData.aqi == 2}'>
				            <c:set var="aqiColor" value="#5cb85c"/> <!-- Light Green -->
				        </c:when>
				        <c:when test='${pollutionData.aqi == 3}'>
				            <c:set var="aqiColor" value="#f0ad4e"/> <!-- Orange -->
				        </c:when>
				        <c:when test='${pollutionData.aqi == 4}'>
				            <c:set var="aqiColor" value="#d9534f"/> <!-- Red -->
				        </c:when>
				        <c:when test='${pollutionData.aqi == 5}'>
				            <c:set var="aqiColor" value="#6f42c1"/> <!-- Purple -->
				        </c:when>
				        <c:otherwise>
				            <c:set var="aqiColor" value="#999"/> <!-- Default Grey -->
				        </c:otherwise>
				    </c:choose>
				
				    <div class="card p-3 mt-4" style="max-width: 600px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
				        <h3 class="text-center mb-3">Current Air Quality</h3>
				        
				        <!-- AQI Circle -->
				        <div style="display: flex; align-items: center; justify-content: center; flex-direction: column; margin-bottom: 20px;">
				            <div style="
				                width: 120px; height: 120px; border-radius: 50%;
				                border: 10px solid ${aqiColor};
				                display: flex; align-items: center; justify-content: center;
				                font-size: 32px; font-weight: bold; color: #333;">
				                ${pollutionData.aqi}
				            </div>
				            <p style="margin-top: 10px; font-size: 18px; font-weight: bold; color:${aqiColor};">
				                ${pollutionData.category}
				            </p>
				        </div>
				
				       <!-- Description -->
						<p class="text-muted text-center mb-4" style="font-size: 14px;">
						    ${pollutionData.description}
						</p>
						
						<!-- Pollutants -->
						<div>
						    <h5 class="mb-3">Pollutants (µg/m³)</h5>
						    <ul class="list-group list-group-flush">
						        <li class="list-group-item d-flex justify-content-between align-items-center">
						            CO <span class="badge bg-secondary rounded-pill">${pollutionData.co}</span>
						        </li>
						        <li class="list-group-item d-flex justify-content-between align-items-center">
						            NO₂ <span class="badge bg-secondary rounded-pill">${pollutionData.no2}</span>
						        </li>
						        <li class="list-group-item d-flex justify-content-between align-items-center">
						            O₃ <span class="badge bg-secondary rounded-pill">${pollutionData.o3}</span>
						        </li>
						        <li class="list-group-item d-flex justify-content-between align-items-center">
						            PM10 <span class="badge bg-secondary rounded-pill">${pollutionData.pm10}</span>
						        </li>
						        <li class="list-group-item d-flex justify-content-between align-items-center">
						            PM2.5 <span class="badge bg-secondary rounded-pill">${pollutionData.pm2_5}</span>
						        </li>
						    </ul>
						</div>
				    </div>
				</c:if>
    </div>

    <!-- Top Stories -->
    <div class="col-lg-auto col-md-12 d-flex flex-column align-items-start">
  <div class="row fs-5" style="margin-top:27px; margin-left:1px;">
    <div class="card text-center fw-bold py-2" style="width: 23rem;">Top Stories</div>
  </div>

  <div class="row mb-0">
    <a href="https://www.nbcnews.com/news/weather/hurricane-erin-east-coast-forecast-rcna192234" target="_blank" class="text-decoration-none text-dark">
      <div class="card" style="width: 23rem;">
        <small class="ms-3 mt-2 text-black-50">Hurricane</small>
        <div class="card-body d-flex align-items-center">
          <p class="card-text flex-grow-1 mb-0">Hurricane Erin moving away from the East Coast as Category 2 storm</p>
          <img src="https://media-cldnry.s-nbcnews.com/image/upload/t_fit-760w,f_auto,q_auto:best/rockcms/2025-08/250821-erin-mb-1234-1bf209.jpg" alt="Hurricane Erin" class="ms-3" style="width: 100px; height: auto;">
        </div>
      </div>
    </a>
  </div>

  <div class="row mb-0">
    <a href="https://www.nbcnews.com/news/weather/california-wildfire-danger-heat-wave-rcna192132" target="_blank" class="text-decoration-none text-dark">
      <div class="card" style="width: 23rem;">
        <small class="ms-3 mt-2 text-black-50">Wildfire</small>
        <div class="card-body d-flex align-items-center">
          <p class="card-text flex-grow-1 mb-0">Dangerous heat and wildfire conditions take hold across the West</p>
          <img src="https://media-cldnry.s-nbcnews.com/image/upload/t_fit-560w,f_auto,q_auto:best/rockcms/2025-08/250820-fire-risk-california-ew-1138a-d61ba9.jpg" alt="Wildfire" class="ms-3" style="width: 100px; height: auto;">
        </div>
      </div>
    </a>
  </div>

  <div class="row mb-0">
    <a href="https://www.nbcnews.com/news/weather/hurricane-erin-east-coast-warning-rcna192122" target="_blank" class="text-decoration-none text-dark">
      <div class="card" style="width: 23rem;">
        <small class="ms-3 mt-2 text-black-50">Hurricane</small>
        <div class="card-body d-flex align-items-center">
          <p class="card-text flex-grow-1 mb-0">'Don’t go into the water': Warnings issued on East Coast as Hurricane Erin moves in Atlantic</p>
          <img src="https://media-cldnry.s-nbcnews.com/image/upload/t_focal-200x100,f_auto,q_auto:best/rockcms/2025-08/250819-New-Jersey-rs-612df6.jpg" alt="Atlantic Hurricane Erin" class="ms-3" style="width: 100px; height: auto;">
        </div>
      </div>
    </a>
  </div>

  <div class="row mb-0">
    <a href="https://www.nbcnews.com/news/weather/extreme-heat-wave-southwest-rcna192198" target="_blank" class="text-decoration-none text-dark">
      <div class="card" style="width: 23rem;">
        <small class="ms-3 mt-2 text-black-50">U.S. News</small>
        <div class="card-body d-flex align-items-center">
          <p class="card-text flex-grow-1 mb-0">Extreme heat wave with temperatures above 110 for some looms for Southwest</p>
          <img src="https://media-cldnry.s-nbcnews.com/image/upload/t_fit-560w,f_auto,q_auto:best/rockcms/2025-08/250820-la-rs-f5bc56.jpg" alt="Heat Wave" class="ms-3" style="width: 100px; height: auto;">
        </div>
      </div>
    </a>
  </div>

  <div class="row mb-0">
    <a href="https://www.nbcnews.com/news/weather/california-wildfires-homeowners-insurance-rcna192087" target="_blank" class="text-decoration-none text-dark">
      <div class="card" style="width: 23rem;">
        <small class="ms-3 mt-2 text-black-50">Western Wildfires</small>
        <div class="card-body d-flex align-items-center">
          <p class="card-text flex-grow-1 mb-0">California Legislature passes bill to give interest on insurance payouts to homeowners</p>
          <img src="https://media-cldnry.s-nbcnews.com/image/upload/t_fit-560w,f_auto,q_auto:best/rockcms/2025-08/250819-california-widlfires-homes-insurance-se-132p-b4c77d.jpg" alt="California Insurance Bill" class="ms-3" style="width: 100px; height: auto;">
        </div>
      </div>
    </a>
  </div>

  <div class="row" style="margin-left:125px;">
    <a href="https://www.nbcnews.com/news/weather" target="_blank" class="text-decoration-underline text-dark">More Stories</a>
  </div>
</div>
</div>
  </div>

   
<jsp:include page="footer.jsp" />
</body>
</html>