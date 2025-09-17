<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="API.HealthCard" %>
<%@ page import="API.HealthServlet" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Health & Activities</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            color: #333;
            line-height: 1.6;
        }
        
        
        /* Main Content Styles */
        .main-content {
            padding: 30px 20px;
        }
        
        .section {
            margin-bottom: 40px;
        }
        
        .section-header {
            margin-bottom: 20px;
        }
        
        .section-title {
            font-size: 24px;
            font-weight: 700;
            color: #111;
            margin-bottom: 8px;
        }
        
        .section-subtitle {
            font-size: 14px;
            color: #666;
        }
        
        /* Cards Grid */
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .card {
            background-color: #f8f8f8;
            border-radius: 12px;
            padding: 20px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        
        .card-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .card-icon {
            font-size: 24px;
            margin-right: 12px;
        }
        
        .card-title {
            font-size: 16px;
            font-weight: 600;
            color: #111;
        }
        
        .rating {
            display: flex;
            align-items: center;
        }
        
        .rating-bar {
            width: 80px;
            height: 8px;
            background-color: #ddd;
            border-radius: 4px;
            margin-right: 10px;
            overflow: hidden;
        }
        
        .rating-fill {
            height: 100%;
            border-radius: 4px;
            transition: width 0.5s ease;
        }
        
        .rating-poor { background-color: #dc2626; }
        .rating-low { background-color: #059669; }
        .rating-moderate { background-color: #d97706; }
        .rating-good { background-color: #0284c7; }
        .rating-great { background-color: #059669; }
        .rating-high { background-color: #dc2626; }
        .rating-extreme { background-color: #7c3aed; }
        
        .rating-text {
            font-size: 14px;
            font-weight: 600;
            color: #111;
        }
        
        /* Temperature Display */
        .temp-display {
            background-color: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .temp-value {
            font-size: 3rem;
            font-weight: 700;
            color: #ff6b00;
        }
        
        .temp-location {
            font-size: 1.2rem;
            color: #666;
            margin-bottom: 10px;
        }
        
        .temp-suggestion {
            font-size: 1rem;
            color: #333;
            font-style: italic;
        }
        
        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .cards-grid {
                grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
                gap: 15px;
            }
            
            .card {
                padding: 15px;
            }
            
            .section-title {
                font-size: 20px;
            }
            
            .header-content, .nav-content {
                flex-wrap: wrap;
            }
            
            .temp-value {
                font-size: 2.5rem;
            }
        }
        
        @media (max-width: 480px) {
            .cards-grid {
                grid-template-columns: 1fr;
            }
            
            .nav-item {
                padding: 15px 10px;
                font-size: 13px;
            }
        }
    </style>
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
        
        // Get temperature from servlet
        Double temperature = (Double) request.getAttribute("temperature");
String suggestion = (String) request.getAttribute("suggestion");

// Get location from attribute (set by HealthServlet)
String location = (String) request.getAttribute("location");

// If not available as attribute, try parameter (for direct access)
if (location == null || location.isEmpty()) {
    location = request.getParameter("location");
}

// Fallback to default
if (location == null || location.trim().isEmpty()) {
    location = "Yangon";
}
        
        // Default values if temperature is not available
        if (temperature == null) {
            temperature = 25.0; // Default temperature
            suggestion = "";
        }
    %>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Temperature Display -->
        <div class="temp-display">
            <div class="temp-location"><%= location %></div>
            <div class="temp-value"><%= String.format("%.1f", temperature) %>°C</div>
            <div class="temp-suggestion"><%= suggestion %></div>
        </div>
        <section class="intro-section mb-8">
    <h1 class="text-4xl font-bold text-center mb-4">Health & Activities</h1>
    <p class="text-lg text-center max-w-3xl mx-auto">
        Your health and daily plans are deeply affected by the weather. Whether it's heat, humidity, or cold,
        we analyze real-time conditions to give you personalized advice on staying safe and active.
    </p>
</section>

<section class="card-grid grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
<%
    List<HealthCard> cards = (List<HealthCard>) request.getAttribute("cards");
    if (cards != null) {
        for (HealthCard card : cards) {
%>
    <div class="card p-6 rounded-xl shadow-lg <%= card.getBgColor() %> <%= card.getTextColor() %>">
        <h3 class="text-xl font-bold"><%= card.getTitle() %></h3>
        <span class="inline-block mt-2 px-3 py-1 rounded-full text-sm font-semibold bg-white/30 backdrop-blur-sm">
            <%= card.getCategory() %>
        </span>
        <p class="mt-4"><%= card.getAdvice() %></p>
    </div>
<%
        }
    }
%>
</section>

        <!-- Health Section -->
        <div class="section">
            <div class="section-header">
                <h2 class="section-title">Health</h2>
                <p class="section-subtitle">How will the weather impact my health today?</p>
            </div>
            <div class="cards-grid">
                <%
                // Arthritis
                String arthritisStatus = "Moderate", arthritisFill = "rating-moderate";
                int arthritisWidth = 50;
                if (temperature < 10) { 
                    arthritisStatus = "High"; 
                    arthritisFill = "rating-high"; 
                    arthritisWidth = 80;
                } else if (temperature < 20) { 
                    arthritisStatus = "Moderate"; 
                    arthritisFill = "rating-moderate"; 
                    arthritisWidth = 50;
                } else { 
                    arthritisStatus = "Low"; 
                    arthritisFill = "rating-low"; 
                    arthritisWidth = 20;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🦵</span>
                        <h3 class="card-title">Arthritis</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= arthritisFill %>" style="width: <%= arthritisWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= arthritisStatus %></span>
                    </div>
                </div>
                
                <%
                // Sinus Pressure
                String sinusStatus = "Moderate", sinusFill = "rating-moderate";
                int sinusWidth = 50;
                if (temperature < 10 || temperature > 30) { 
                    sinusStatus = "High"; 
                    sinusFill = "rating-high"; 
                    sinusWidth = 80;
                } else if (temperature < 20) { 
                    sinusStatus = "Low"; 
                    sinusFill = "rating-low"; 
                    sinusWidth = 20;
                } else { 
                    sinusStatus = "Moderate"; 
                    sinusFill = "rating-moderate"; 
                    sinusWidth = 50;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">👃</span>
                        <h3 class="card-title">Sinus Pressure</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= sinusFill %>" style="width: <%= sinusWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= sinusStatus %></span>
                    </div>
                </div>
                
                <%
                // Common Cold
                String coldStatus = "Moderate", coldFill = "rating-moderate";
                int coldWidth = 50;
                if (temperature < 15) { 
                    coldStatus = "High"; 
                    coldFill = "rating-high"; 
                    coldWidth = 80;
                } else if (temperature < 25) { 
                    coldStatus = "Moderate"; 
                    coldFill = "rating-moderate"; 
                    coldWidth = 50;
                } else { 
                    coldStatus = "Low"; 
                    coldFill = "rating-low"; 
                    coldWidth = 20;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🤧</span>
                        <h3 class="card-title">Common Cold</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= coldFill %>" style="width: <%= coldWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= coldStatus %></span>
                    </div>
                </div>
                
                <%
                // Flu
                String fluStatus = "Moderate", fluFill = "rating-moderate";
                int fluWidth = 50;
                if (temperature < 15) { 
                    fluStatus = "High"; 
                    fluFill = "rating-high"; 
                    fluWidth = 80;
                } else if (temperature < 25) { 
                    fluStatus = "Moderate"; 
                    fluFill = "rating-moderate"; 
                    fluWidth = 50;
                } else { 
                    fluStatus = "Low"; 
                    fluFill = "rating-low"; 
                    fluWidth = 20;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🤒</span>
                        <h3 class="card-title">Flu</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= fluFill %>" style="width: <%= fluWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= fluStatus %></span>
                    </div>
                </div>
                
                <%
                // Migraine
                String migraineStatus = "Moderate", migraineFill = "rating-moderate";
                int migraineWidth = 50;
                if (temperature > 30) { 
                    migraineStatus = "High"; 
                    migraineFill = "rating-high"; 
                    migraineWidth = 80;
                } else if (temperature > 20) { 
                    migraineStatus = "Moderate"; 
                    migraineFill = "rating-moderate"; 
                    migraineWidth = 50;
                } else { 
                    migraineStatus = "Low"; 
                    migraineFill = "rating-low"; 
                    migraineWidth = 20;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🤕</span>
                        <h3 class="card-title">Migraine</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= migraineFill %>" style="width: <%= migraineWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= migraineStatus %></span>
                    </div>
                </div>
                
                <%
                // Asthma
                String asthmaStatus = "Moderate", asthmaFill = "rating-moderate";
                int asthmaWidth = 50;
                if (temperature < 10 || temperature > 35) { 
                    asthmaStatus = "High"; 
                    asthmaFill = "rating-high"; 
                    asthmaWidth = 80;
                } else if (temperature < 20) { 
                    asthmaStatus = "Low"; 
                    asthmaFill = "rating-low"; 
                    asthmaWidth = 20;
                } else { 
                    asthmaStatus = "Moderate"; 
                    asthmaFill = "rating-moderate"; 
                    asthmaWidth = 50;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">💨</span>
                        <h3 class="card-title">Asthma</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= asthmaFill %>" style="width: <%= asthmaWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= asthmaStatus %></span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Outdoor Activities Section -->
        <div class="section">
            <div class="section-header">
                <h2 class="section-title">Outdoor Activities</h2>
                <p class="section-subtitle">What should I do today?</p>
            </div>
            <div class="cards-grid">
                <%
                // Fishing
                String fishingStatus = "Moderate", fishingFill = "rating-moderate";
                int fishingWidth = 50;
                if (temperature >= 15 && temperature < 30) { 
                    fishingStatus = "Good"; 
                    fishingFill = "rating-good"; 
                    fishingWidth = 60;
                } else if (temperature >= 10 && temperature < 15) { 
                    fishingStatus = "Fair"; 
                    fishingFill = "rating-moderate"; 
                    fishingWidth = 50;
                } else if (temperature < 10) { 
                    fishingStatus = "Poor"; 
                    fishingFill = "rating-poor"; 
                    fishingWidth = 25;
                } else { 
                    fishingStatus = "Poor"; 
                    fishingFill = "rating-poor"; 
                    fishingWidth = 25;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🎣</span>
                        <h3 class="card-title">Fishing</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= fishingFill %>" style="width: <%= fishingWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= fishingStatus %></span>
                    </div>
                </div>
                
                <%
                // Running
                String runningStatus = "Moderate", runningFill = "rating-moderate";
                int runningWidth = 50;
                if (temperature >= 15 && temperature < 25) { 
                    runningStatus = "Excellent"; 
                    runningFill = "rating-great"; 
                    runningWidth = 85;
                } else if (temperature >= 10 && temperature < 15) { 
                    runningStatus = "Good"; 
                    runningFill = "rating-good"; 
                    runningWidth = 60;
                } else if (temperature < 10) { 
                    runningStatus = "Fair"; 
                    runningFill = "rating-moderate"; 
                    runningWidth = 50;
                } else if (temperature >= 25 && temperature < 35) { 
                    runningStatus = "Poor"; 
                    runningFill = "rating-poor"; 
                    runningWidth = 25;
                } else { 
                    runningStatus = "Extreme"; 
                    runningFill = "rating-extreme"; 
                    runningWidth = 90;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🏃‍♂️</span>
                        <h3 class="card-title">Running</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= runningFill %>" style="width: <%= runningWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= runningStatus %></span>
                    </div>
                </div>
                
                <%
// Hiking
String hikingStatus = "Moderate", hikingFill = "rating-moderate";
int hikingWidth = 50;
if (temperature >= 15 && temperature < 25) { 
    hikingStatus = "Excellent"; 
    hikingFill = "rating-great"; 
    hikingWidth = 85;
} else if (temperature >= 10 && temperature < 15) { 
    hikingStatus = "Good"; 
    hikingFill = "rating-good"; 
    hikingWidth = 60;
} else if (temperature < 10) { 
    hikingStatus = "Fair"; 
    hikingFill = "rating-moderate"; 
    hikingWidth = 50;
} else if (temperature >= 25 && temperature < 35) { 
    hikingStatus = "Poor"; 
    hikingFill = "rating-poor"; 
    hikingWidth = 25;
} else { 
    hikingStatus = "Extreme"; 
    hikingFill = "rating-extreme"; 
    hikingWidth = 90;
}
%>
<div class="card">
    <div class="card-header">
        <span class="card-icon">🥾</span>
        <h3 class="card-title">Hiking</h3>
    </div>
    <div class="rating">
        <div class="rating-bar">
            <div class="rating-fill <%= hikingFill %>" style="width: <%= hikingWidth %>%;"></div>
        </div>
        <span class="rating-text"><%= hikingStatus %></span>
    </div>
</div>
                
                <%
                // Golf
                String golfStatus = "Moderate", golfFill = "rating-moderate";
                int golfWidth = 50;
                if (temperature >= 18 && temperature < 30) { 
                    golfStatus = "Good"; 
                    golfFill = "rating-good"; 
                    golfWidth = 60;
                } else if (temperature >= 12 && temperature < 18) { 
                    golfStatus = "Fair"; 
                    golfFill = "rating-moderate"; 
                    golfWidth = 50;
                } else { 
                    golfStatus = "Poor"; 
                    golfFill = "rating-poor"; 
                    golfWidth = 25;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">⛳</span>
                        <h3 class="card-title">Golf</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= golfFill %>" style="width: <%= golfWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= golfStatus %></span>
                    </div>
                </div>
                
                <%
                // Biking & Cycling
                String bikingStatus = "Moderate", bikingFill = "rating-moderate";
                int bikingWidth = 50;
                if (temperature >= 15 && temperature < 30) { 
                    bikingStatus = "Good"; 
                    bikingFill = "rating-good"; 
                    bikingWidth = 60;
                } else if (temperature >= 10 && temperature < 15) { 
                    bikingStatus = "Fair"; 
                    bikingFill = "rating-moderate"; 
                    bikingWidth = 50;
                } else { 
                    bikingStatus = "Poor"; 
                    bikingFill = "rating-poor"; 
                    bikingWidth = 25;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🚴‍♂️</span>
                        <h3 class="card-title">Biking & Cycling</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= bikingFill %>" style="width: <%= bikingWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= bikingStatus %></span>
                    </div>
                </div>
                
                <%
                // Beach & Pool
                String beachPoolStatus = "Moderate", beachPoolFill = "rating-moderate";
                int beachPoolWidth = 50;
                if (temperature >= 28) { 
                    beachPoolStatus = "Excellent"; 
                    beachPoolFill = "rating-great"; 
                    beachPoolWidth = 85;
                } else if (temperature >= 22 && temperature < 28) { 
                    beachPoolStatus = "Good"; 
                    beachPoolFill = "rating-good"; 
                    beachPoolWidth = 60;
                } else if (temperature >= 18 && temperature < 22) { 
                    beachPoolStatus = "Fair"; 
                    beachPoolFill = "rating-moderate"; 
                    beachPoolWidth = 50;
                } else { 
                    beachPoolStatus = "Poor"; 
                    beachPoolFill = "rating-poor"; 
                    beachPoolWidth = 25;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🏖️</span>
                        <h3 class="card-title">Beach & Pool</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= beachPoolFill %>" style="width: <%= beachPoolWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= beachPoolStatus %></span>
                    </div>
                </div>
                
                <%
                // Stargazing
                String stargazingStatus = "Moderate", stargazingFill = "rating-moderate";
                int stargazingWidth = 50;
                if (temperature >= 15 && temperature < 25) { 
                    stargazingStatus = "Good"; 
                    stargazingFill = "rating-good"; 
                    stargazingWidth = 60;
                } else if (temperature >= 10 && temperature < 15) { 
                    stargazingStatus = "Fair"; 
                    stargazingFill = "rating-moderate"; 
                    stargazingWidth = 50;
                } else { 
                    stargazingStatus = "Poor"; 
                    stargazingFill = "rating-poor"; 
                    stargazingWidth = 25;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">✨</span>
                        <h3 class="card-title">Stargazing</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= stargazingFill %>" style="width: <%= stargazingWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= stargazingStatus %></span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Travel and Commute Section -->
<div class="section">
    <div class="section-header">
        <h2 class="section-title">Travel and Commute</h2>
        <p class="section-subtitle">How will weather affect your travel plans?</p>
    </div>
    <div class="cards-grid">
        <%
        // Air travel
        String airTravelStatus = "Moderate", airTravelFill = "rating-moderate";
        int airTravelWidth = 50;
        if (temperature >= 10 && temperature < 30) { 
            airTravelStatus = "Good"; 
            airTravelFill = "rating-good"; 
            airTravelWidth = 60;
        } else if (temperature >= 5 && temperature < 10) { 
            airTravelStatus = "Fair"; 
            airTravelFill = "rating-moderate"; 
            airTravelWidth = 50;
        } else if (temperature < 5) { 
            airTravelStatus = "Poor"; 
            airTravelFill = "rating-poor"; 
            airTravelWidth = 25;
        } else { 
            airTravelStatus = "Poor"; 
            airTravelFill = "rating-poor"; 
            airTravelWidth = 25;
        }
        %>
        <div class="card">
            <div class="card-header">
                <span class="card-icon">✈️</span>
                <h3 class="card-title">Air Travel</h3>
            </div>
            <div class="rating">
                <div class="rating-bar">
                    <div class="rating-fill <%= airTravelFill %>" style="width: <%= airTravelWidth %>%;"></div>
                </div>
                <span class="rating-text"><%= airTravelStatus %></span>
            </div>
        </div>
        
        <%
        // Driving
        String drivingStatus = "Moderate", drivingFill = "rating-moderate";
        int drivingWidth = 50;
        if (temperature >= 10 && temperature < 30) { 
            drivingStatus = "Good"; 
            drivingFill = "rating-good"; 
            drivingWidth = 60;
        } else if (temperature >= 5 && temperature < 10) { 
            drivingStatus = "Fair"; 
            drivingFill = "rating-moderate"; 
            drivingWidth = 50;
        } else if (temperature < 5) { 
            drivingStatus = "Poor"; 
            drivingFill = "rating-poor"; 
            drivingWidth = 25;
        } else if (temperature >= 30 && temperature < 35) { 
            drivingStatus = "Poor"; 
            drivingFill = "rating-poor"; 
            drivingWidth = 25;
        } else { 
            drivingStatus = "Extreme"; 
            drivingFill = "rating-extreme"; 
            drivingWidth = 90;
        }
        %>
        <div class="card">
            <div class="card-header">
                <span class="card-icon">🚗</span>
                <h3 class="card-title">Driving</h3>
            </div>
            <div class="rating">
                <div class="rating-bar">
                    <div class="rating-fill <%= drivingFill %>" style="width: <%= drivingWidth %>%;"></div>
                </div>
                <span class="rating-text"><%= drivingStatus %></span>
            </div>
        </div>
    </div>
</div>
        
        <!-- Home & Garden Section -->
        <div class="section">
            <div class="section-header">
                <h2 class="section-title">Home & Garden</h2>
                <p class="section-subtitle">What should I do around my home today?</p>
            </div>
            <div class="cards-grid">
                <%
                // Lawn Mowing
                String lawnMowingStatus = "Moderate", lawnMowingFill = "rating-moderate";
                int lawnMowingWidth = 50;
                if (temperature >= 15 && temperature < 30) { 
                    lawnMowingStatus = "Good"; 
                    lawnMowingFill = "rating-good"; 
                    lawnMowingWidth = 60;
                } else { 
                    lawnMowingStatus = "Poor"; 
                    lawnMowingFill = "rating-poor"; 
                    lawnMowingWidth = 25;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🪄</span>
                        <h3 class="card-title">Lawn Mowing</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= lawnMowingFill %>" style="width: <%= lawnMowingWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= lawnMowingStatus %></span>
                    </div>
                </div>
                
                <%
                // Composting
                String compostingStatus = "Moderate", compostingFill = "rating-moderate";
                int compostingWidth = 50;
                if (temperature >= 20 && temperature < 35) { 
                    compostingStatus = "Excellent"; 
                    compostingFill = "rating-great"; 
                    compostingWidth = 85;
                } else if (temperature >= 15 && temperature < 20) { 
                    compostingStatus = "Good"; 
                    compostingFill = "rating-good"; 
                    compostingWidth = 60;
                } else { 
                    compostingStatus = "Fair"; 
                    compostingFill = "rating-moderate"; 
                    compostingWidth = 50;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🌱</span>
                        <h3 class="card-title">Composting</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= compostingFill %>" style="width: <%= compostingWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= compostingStatus %></span>
                    </div>
                </div>
                
                <%
                // Outdoor Entertaining
                String outdoorEntertainingStatus = "Moderate", outdoorEntertainingFill = "rating-moderate";
                int outdoorEntertainingWidth = 50;
                if (temperature >= 20 && temperature < 30) { 
                    outdoorEntertainingStatus = "Excellent"; 
                    outdoorEntertainingFill = "rating-great"; 
                    outdoorEntertainingWidth = 85;
                } else if (temperature >= 15 && temperature < 20) { 
                    outdoorEntertainingStatus = "Good"; 
                    outdoorEntertainingFill = "rating-good"; 
                    outdoorEntertainingWidth = 60;
                } else { 
                    outdoorEntertainingStatus = "Poor"; 
                    outdoorEntertainingFill = "rating-poor"; 
                    outdoorEntertainingWidth = 25;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🎉</span>
                        <h3 class="card-title">Outdoor Entertaining</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= outdoorEntertainingFill %>" style="width: <%= outdoorEntertainingWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= outdoorEntertainingStatus %></span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Pests Section -->
        <div class="section">
            <div class="section-header">
                <h2 class="section-title">Pests</h2>
                <p class="section-subtitle">Will I be affected by pests today?</p>
            </div>
            <div class="cards-grid">
                <%
                // Mosquitoes
                String mosquitoesStatus = "Moderate", mosquitoesFill = "rating-moderate";
                int mosquitoesWidth = 50;
                if (temperature >= 25) { 
                    mosquitoesStatus = "Extreme"; 
                    mosquitoesFill = "rating-extreme"; 
                    mosquitoesWidth = 90;
                } else if (temperature >= 18) { 
                    mosquitoesStatus = "High"; 
                    mosquitoesFill = "rating-high"; 
                    mosquitoesWidth = 80;
                } else if (temperature >= 12) { 
                    mosquitoesStatus = "Moderate"; 
                    mosquitoesFill = "rating-moderate"; 
                    mosquitoesWidth = 50;
                } else { 
                    mosquitoesStatus = "Low"; 
                    mosquitoesFill = "rating-low"; 
                    mosquitoesWidth = 20;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🦟</span>
                        <h3 class="card-title">Mosquitoes</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= mosquitoesFill %>" style="width: <%= mosquitoesWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= mosquitoesStatus %></span>
                    </div>
                </div>
                
                <%
                // Indoor Pests
                String indoorPestsStatus = "Moderate", indoorPestsFill = "rating-moderate";
                int indoorPestsWidth = 50;
                if (temperature >= 30) { 
                    indoorPestsStatus = "High"; 
                    indoorPestsFill = "rating-high"; 
                    indoorPestsWidth = 80;
                } else if (temperature >= 20) { 
                    indoorPestsStatus = "Moderate"; 
                    indoorPestsFill = "rating-moderate"; 
                    indoorPestsWidth = 50;
                } else { 
                    indoorPestsStatus = "Low"; 
                    indoorPestsFill = "rating-low"; 
                    indoorPestsWidth = 20;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🕷️</span>
                        <h3 class="card-title">Indoor Pests</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= indoorPestsFill %>" style="width: <%= indoorPestsWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= indoorPestsStatus %></span>
                    </div>
                </div>
                
                <%
                // Outdoor Pests
                String outdoorPestsStatus = "Moderate", outdoorPestsFill = "rating-moderate";
                int outdoorPestsWidth = 50;
                if (temperature >= 25) { 
                    outdoorPestsStatus = "Extreme"; 
                    outdoorPestsFill = "rating-extreme"; 
                    outdoorPestsWidth = 90;
                } else if (temperature >= 18) { 
                    outdoorPestsStatus = "High"; 
                    outdoorPestsFill = "rating-high"; 
                    outdoorPestsWidth = 80;
                } else if (temperature >= 12) { 
                    outdoorPestsStatus = "Moderate"; 
                    outdoorPestsFill = "rating-moderate"; 
                    outdoorPestsWidth = 50;
                } else { 
                    outdoorPestsStatus = "Low"; 
                    outdoorPestsFill = "rating-low"; 
                    outdoorPestsWidth = 20;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🐛</span>
                        <h3 class="card-title">Outdoor Pests</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= outdoorPestsFill %>" style="width: <%= outdoorPestsWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= outdoorPestsStatus %></span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Allergies Section -->
        <div class="section">
            <div class="section-header">
                <h2 class="section-title">Allergies</h2>
                <p class="section-subtitle">How high are allergens today?</p>
            </div>
            <div class="cards-grid">
                <%
                // Tree Pollen
                String treePollenStatus = "Moderate", treePollenFill = "rating-moderate";
                int treePollenWidth = 50;
                if (temperature >= 20 && temperature < 30) { 
                    treePollenStatus = "High"; 
                    treePollenFill = "rating-high"; 
                    treePollenWidth = 80;
                } else if (temperature >= 15 && temperature < 20) { 
                    treePollenStatus = "Moderate"; 
                    treePollenFill = "rating-moderate"; 
                    treePollenWidth = 50;
                } else { 
                    treePollenStatus = "Low"; 
                    treePollenFill = "rating-low"; 
                    treePollenWidth = 20;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🌳</span>
                        <h3 class="card-title">Tree Pollen</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= treePollenFill %>" style="width: <%= treePollenWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= treePollenStatus %></span>
                    </div>
                </div>
                
                <%
                // Grass Pollen
                String grassPollenStatus = "Moderate", grassPollenFill = "rating-moderate";
                int grassPollenWidth = 50;
                if (temperature >= 20 && temperature < 30) { 
                    grassPollenStatus = "High"; 
                    grassPollenFill = "rating-high"; 
                    grassPollenWidth = 80;
                } else if (temperature >= 15 && temperature < 20) { 
                    grassPollenStatus = "Moderate"; 
                    grassPollenFill = "rating-moderate"; 
                    grassPollenWidth = 50;
                } else { 
                    grassPollenStatus = "Low"; 
                    grassPollenFill = "rating-low"; 
                    grassPollenWidth = 20;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🌾</span>
                        <h3 class="card-title">Grass Pollen</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= grassPollenFill %>" style="width: <%= grassPollenWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= grassPollenStatus %></span>
                    </div>
                </div>
                
                <%
                // Ragweed Pollen
                String ragweedPollenStatus = "Moderate", ragweedPollenFill = "rating-moderate";
                int ragweedPollenWidth = 50;
                if (temperature >= 25) { 
                    ragweedPollenStatus = "High"; 
                    ragweedPollenFill = "rating-high"; 
                    ragweedPollenWidth = 80;
                } else { 
                    ragweedPollenStatus = "Low"; 
                    ragweedPollenFill = "rating-low"; 
                    ragweedPollenWidth = 20;
                }
                %>
                <div class="card">
                    <div class="card-header">
                        <span class="card-icon">🌼</span>
                        <h3 class="card-title">Ragweed Pollen</h3>
                    </div>
                    <div class="rating">
                        <div class="rating-bar">
                            <div class="rating-fill <%= ragweedPollenFill %>" style="width: <%= ragweedPollenWidth %>%;"></div>
                        </div>
                        <span class="rating-text"><%= ragweedPollenStatus %></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>