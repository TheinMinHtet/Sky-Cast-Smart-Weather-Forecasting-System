<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <title>Weather Result</title>
</head>

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
  <div class="row g-3 justify-content-center">
      <!-- Hourly Forecast Section -->
     <div class="col-lg-6 col-md-12">
     	<div style="max-width: 600px; border-radius: 10px;margin-top:5px;">
                <div class="card-header bg-white py-3 px-3">
                    <h6 class="mb-0 text-uppercase">5-DAY WEATHER FORECAST</h6>
                </div>
                <div class="list-group list-group-flush">
                    <c:forEach items="${dailyData}" var="day" varStatus="status">
					    <div class="weather-day-card mb-3 p-3 border rounded shadow-sm bg-white">
					        <!-- Header Row -->
					        <div class="d-flex justify-content-between align-items-center mb-2">
					            <div>
					                <div class="fw-bold text-uppercase fs-6">${status.index == 0 ? 'TONIGHT' : fn:substringBefore(day.date, ',')}</div>
					                <small class="text-muted">${fn:substringAfter(day.date, ',')}</small>
					            </div>
					            <div class="d-flex align-items-center gap-2">
					                <span class="text-muted"><i class="fas fa-cloud-rain"></i> ${day.rain}%</span>
					            </div>
					        </div>
					
					        <!-- Main Weather Info -->
					        <div class="d-flex align-items-center gap-3 mb-2">
					            <img src="https://openweathermap.org/img/wn/${day.icon}@2x.png"
					                 alt="${day.condition}" width="48" class="me-2">
					            <div class="flex-grow-1">
					                <div class="fs-2 fw-bold">${day.maxTemp}°</div>
					                <small class="text-muted">/ ${day.minTemp}°</small>
					            </div>
					        </div>
					
					        <!-- Condition -->
					        <div class="mb-2">
					            <div class="fw-medium">${day.condition}</div>
					            <small class="text-muted">${day.detailedForecast}</small>
					        </div>
					
					        <!-- Detailed Stats -->
					        <div class="row g-2 mt-2">
					            <div class="col-6">
					                <div class="d-flex justify-content-between">
					                    <span class="text-muted small">RealFeel®</span>
					                    <span class="fw-bold">${day.realFeel}°</span>
					                </div>
					            </div>
					            <div class="col-6">
					                <div class="d-flex justify-content-between">
					                    <span class="text-muted small">Wind</span>
					                    <span class="fw-bold">${day.windDirection} ${day.windSpeed} km/h</span>
					                </div>
					            </div>
					        </div>
					        <div class="row g-2 mt-1">
					            <div class="col-6">
					                <div class="d-flex justify-content-between">
					                    <span class="text-muted small">Cloud Cover</span>
					                    <span class="fw-bold">${day.cloudCover}%</span>
					                </div>
					            </div>
					            <div class="col-6">
					                <div class="d-flex justify-content-between">
					                    <span class="text-muted small">Wind Gusts</span>
					                    <span class="fw-bold">${day.windGust} km/h</span>
					                </div>
					            </div>
					        </div>
					    </div>
					</c:forEach>
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