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
  <div class="row g-3 mb-3 justify-content-center">
      <!-- Hourly Forecast Section -->
     <div class="col-lg-6 col-md-12">
     	<div class="card shadow" style="border-radius: 10px; margin-top: 27px; width: 600px; max-width: 100%;">
    <div class="card-header bg-custom-header text-white fw-bold text-center">
        Hourly Weather
    </div>
       <div class="card-body p-3" style="overflow-x: auto; white-space: nowrap; max-width: 600px;">
        <div class="d-flex gap-2 justify-content-start align-items-stretch" style="min-width: 560px;">
            <c:forEach var="hour" items="${hourlyData}">
                <div class="text-center" style="flex: 0 0 auto; width: 80px;">
                    <p class="mb-1 small fw-semibold text-secondary">${hour.time}</p>

                    <c:set var="iconCode" value="${hour.icon lt 10 ? '0' : ''}${hour.icon}" />
                    <img 
                        src="https://developer.accuweather.com/sites/default/files/${iconCode}-s.png" 
                        alt="${hour.iconPhrase}" 
                        class="mb-1" 
                        width="40" 
                        height="40" 
                        style="object-fit: contain;"
                    >

                    <p class="mb-1 fs-6 fw-bold">${hour.temp}°C</p>
                    <p class="small text-muted mb-0">
                        <i class="bi bi-droplet"></i> ${hour.precip}%
                    </p>
                </div>
            </c:forEach>
        </div>
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