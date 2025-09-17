<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SkyCast</title>
    <link rel="stylesheet" type="text/css" href="css/header.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            color: #fff;
            text-align: center;
        }

        /* 🔹 Hero section (only background area) */
        .hero-section {
            padding: 50px 20px;
            transition: background 0.5s ease-in-out;
        }

        /* Background variants */
        .hero-section.morning {
		    background: url("./photo/sebastien-gabriel--IMlv9Jlb24-unsplash.jpg") no-repeat center center/cover;
		}
		.hero-section.afternoon {
		    background: url("./photo/grooveland-designs-zjoydJb17mE-unsplash.jpg") no-repeat center center/cover;
		}
		.hero-section.evening {
		    background: url("./photo/jason-mavrommatis-GPPAjJicemU-unsplash.jpg") no-repeat center center/cover;
		}
		.hero-section.night {
		    background: url("./photo/nathan-anderson-L95xDkSSuWw-unsplash.jpg") no-repeat center center/cover;
		}


    .search-container {
    margin-top: 30px;
    display: flex;
    justify-content: left;
    align-items: left;
    gap: 15px; /* spacing between elements */
    flex-wrap: wrap; /* wrap on smaller screens */
    margin-left:20px;
}

.search-form {
    display: flex;
    gap: 10px;
}

.search-form input[type="text"] {
    padding: 10px;
    width: 250px;
    border: none;
    border-radius: 10px;
    font-size: 16px;
    background: rgba(255, 255, 255, 0.3); /* subtle transparent background */
    color: #fff; /* white text */
    transition: background 0.3s, box-shadow 0.3s;
}

.search-form input[type="text"]::placeholder {
    color: #ccc; /* placeholder color */
}

.search-form input[type="text"]:focus {
    outline: none;
    background: rgba(255, 255, 255, 0.2); /* lighter on focus */
    box-shadow: 0 0 8px rgba(0, 123, 255, 0.7); /* subtle glow effect */
}

.search-form button,
.location-btn {
    padding: 10px 20px;
    border: none;
    border-radius: 20px;
    background: rgba(0, 0, 0, 0.6); /* semi-transparent black */
    color: white;
    font-size: 16px;
    cursor: pointer;
    transition: background 0.3s, transform 0.2s;
}

.search-form button:hover,
.location-btn:hover {
    background: rgba(0, 0, 0, 0.8); /* slightly darker on hover */
    transform: scale(1.05); /* subtle zoom effect */
}



        .weather-display {
        	margin-left:20px;
            margin-top: 40px;
            font-size: 22px;
        }

        .temp {
            font-size: 60px;
            font-weight: bold;
        }
.msg-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.4);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
}

/* Centered message box */
.msg-box {
    position: relative;
    width: 450px;   /* larger size */
    max-width: 90%;
    padding: 30px;
    border-radius: 12px;
    font-family: Arial, sans-serif;
    font-size: 18px;
    text-align: center;
    box-shadow: 0 6px 15px rgba(0,0,0,0.4);
    animation: fadeIn 0.3s ease-in-out;
}

/* Color variations */
.msg-box.success {
    background: #e6ffed;
    border: 2px solid #28a745;
    color: #155724;
}
.msg-box.error {
    background: #ffe6e6;
    border: 2px solid #dc3545;
    color: #721c24;
}
.msg-box.warning {
    background: #fff3cd;
    border: 2px solid #ffc107;
    color: #856404;
}

/* Close button */
.close-btn {
    position: absolute;
    right: 15px;
    top: 10px;
    font-size: 28px;
    font-weight: bold;
    color: #333;
    cursor: pointer;
}

@keyframes fadeIn {
    from {opacity: 0; transform: scale(0.8);}
    to {opacity: 1; transform: scale(1);}
}    </style>
    <script>
    function setBackgroundByTime() {
        let hero = document.querySelector(".hero-section");
        hero.className = "hero-section"; // reset

        let hour = new Date().getHours();

        if (hour >= 5 && hour < 12) {
            hero.classList.add("morning");
        } else if (hour >= 12 && hour < 17) {
            hero.classList.add("afternoon");
        } else if (hour >= 17 && hour < 20) {
            hero.classList.add("evening");
        } else {
            hero.classList.add("night");
        }
    }

    window.onload = setBackgroundByTime;

    function useCurrentLocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function (position) {
                    let lat = position.coords.latitude;
                    let lon = position.coords.longitude;
                    // Redirect to MainServlet with lat/lon
                    window.location.href = "MainServlet?lat=" + lat + "&lon=" + lon;
                },
                function (error) {
                    alert("Unable to retrieve location. Please allow GPS access.");
                }
            );
        } else {
            alert("Geolocation is not supported by this browser.");
        }
    }

</script>


</head>
<body>

      <!-- Header -->
<div class="navbar navbar-expand-xl bg-black sticky-top shadow">
      <a class="navbar-brand text-white ms-3" href="index.jsp"><i class="fa-solid fa-cloud me-2"></i>SkyCast</a>
      <a class="navbar-brand d-flex align-items-center" href="index.jsp">
      </a>
</div>

    <!-- 🔹 Hero Section with background -->
    <div class="hero-section">
		        <div class="search-container">
		    <!-- Search form -->
		    <form action="MainServlet" method="GET" class="search-form">
			    <input type="hidden" name="page" value="today">
			    <input type="text" name="location" placeholder="Search city" required>
			    <button type="submit">Search</button>
			</form>

		
		    <!-- Current location button (separate, not inside form) -->
		    <button type="button" onclick="useCurrentLocation()" class="location-btn" style="background: rgba(0,0,0,0.6);">
		        Use Current Location
		    </button>
</div>



       <c:set var="displayData" value="${not empty weatherData ? weatherData : sessionScope.lastWeatherData}" />

<c:if test="${not empty displayData}">
    <a href="MainServlet?location=${displayData.location}" 
       style="text-decoration: none; color: inherit;">
        <div style="display: inline-block; background: rgba(0,0,0,0.6); padding: 20px; border-radius: 15px; box-shadow: 0 4px 12px rgba(0,0,0,0.3); margin: 20px; width: 300px; cursor: pointer; transition: transform 0.2s, box-shadow 0.2s;"
             onmouseover="this.style.transform='scale(1.05)'; this.style.boxShadow='0 8px 20px rgba(0,0,0,0.5)';"
             onmouseout="this.style.transform='scale(1)'; this.style.boxShadow='0 4px 12px rgba(0,0,0,0.3)';">
            <h3 style="margin-bottom: 10px; font-weight: normal; color:white;">Recent Location</h3>
            <div style="font-size: 50px; font-weight: bold; color:white;">${displayData.temp}&deg;C</div>
            <div style="margin: 5px 0; color:white;" class="text-capitalize">${displayData.condition}</div>
            <div style="font-size: 18px; color:white;">${displayData.location}</div>
        </div>
    </a>
</c:if>

<c:if test="${empty displayData}">
    <div style="
        display: inline-block;
        background: rgba(0, 0, 0, 0.7); /* slightly darker */
        padding: 25px 20px;
        border-radius: 20px;
        box-shadow: 0 6px 15px rgba(0, 0, 0, 0.4);
        margin: 20px;
        width: 220px;
        text-align: center;
        transition: transform 0.2s, box-shadow 0.2s;
        cursor: default;
    "
    onmouseover="this.style.transform='scale(1.05)'; this.style.boxShadow='0 10px 25px rgba(0,0,0,0.6)';"
    onmouseout="this.style.transform='scale(1)'; this.style.boxShadow='0 6px 15px rgba(0,0,0,0.4)';">
        <div style="font-size: 50px; font-weight: bold; color: #fff;">--°C</div>
        <div style="font-size: 18px; color: #ddd; margin: 5px 0;">No data</div>
        <div style="font-size: 16px; color: #bbb;">Unknown</div>
    </div>
</c:if>




    </div>
    

    <jsp:include page="footer.jsp" />
<c:if test="${not empty sessionScope.message}">
    <div class="msg-overlay">
        <div class="msg-box ${sessionScope.type}">
            <span class="close-btn" onclick="document.querySelector('.msg-overlay').style.display='none';">&times;</span>
            <p>${sessionScope.message}</p>
        </div>
    </div>
    <c:remove var="message" scope="session"/>
    <c:remove var="type" scope="session"/>
</c:if>
</body>
</html>
