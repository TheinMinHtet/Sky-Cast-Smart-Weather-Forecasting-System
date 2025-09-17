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
      <div class="card shadow" style="max-width: 600px; border-radius: 10px; margin-top:27px;">
		        <div class="card-header bg-white">
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
		            <div id="radar-map" style="height: 500px; width: 100%;"></div>
		        </div>
		    </div>
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