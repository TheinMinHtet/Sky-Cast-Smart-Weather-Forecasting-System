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
				
				    <div class="card p-3" style="max-width: 600px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); margin-top:27px;">
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