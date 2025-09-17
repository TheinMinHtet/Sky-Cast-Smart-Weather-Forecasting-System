<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Weather Tips - SkyCast</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <style>
    :root {
      --primary-color: #2c7be5;
      --secondary-color: #6c757d;
      --accent-color: #6c5ce7;
      --sunny-color: #f9a826;
      --rainy-color: #0984e3;
      --cold-color: #74b9ff;
      --stormy-color: #636e72;
      --light-bg: #f8f9fa;
    }
    
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(135deg, #f5f7fa 0%, #dfe6e9 100%);
      min-height: 100vh;
      margin: 0;
      padding: 0;
      color: #333;
      position: relative;
      overflow-x: hidden; /* Re-enabled but with hidden only for x-axis */
    }
    
    .weather-background {
      position: relative;
      min-height: 100vh;
      overflow: visible; /* Changed from hidden to visible */
    }
    
    .weather-background::before {
      content: "";
      position: fixed; /* Changed to fixed to prevent overflow issues */
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1440 320'%3E%3Cpath fill='%232c7be5' fill-opacity='0.08' d='M0,224L48,213.3C96,203,192,181,288,160C384,139,480,117,576,122.7C672,128,768,160,864,170.7C960,181,1056,171,1152,165.3C1248,160,1344,160,1392,160L1440,160L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z'%3E%3C/path%3E%3C/svg%3E");
      background-size: cover;
      background-position: bottom;
      z-index: -1;
    }
    
    .tips-card {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
      backdrop-filter: blur(10px);
      padding: 2.5rem;
      margin: 2rem auto;
      transition: transform 0.3s ease;
      max-width: 1000px;
      overflow: visible;
    }
    
    .tips-card:hover {
      transform: translateY(-5px);
    }
    
    .header-title {
      position: relative;
      display: inline-block;
      margin-bottom: 2rem;
    }
    
    .header-title::after {
      content: "";
      position: absolute;
      bottom: -10px;
      left: 0;
      width: 60%;
      height: 4px;
      background: linear-gradient(90deg, var(--sunny-color), var(--rainy-color), var(--cold-color), var(--stormy-color));
      border-radius: 2px;
    }
    
    .btn-primary-custom {
      background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
      border: none;
      border-radius: 50px;
      padding: 0.75rem 2rem;
      font-weight: 600;
      transition: all 0.3s ease;
      box-shadow: 0 4px 15px rgba(44, 123, 229, 0.3);
      color: white;
      text-decoration: none;
      display: inline-block;
    }
    
    .btn-primary-custom:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 20px rgba(44, 123, 229, 0.4);
      color: white;
    }
    
    .weather-animation {
      position: fixed; /* Changed to fixed to prevent layout issues */
      opacity: 0.6;
      z-index: 0;
    }
    
    .sunny {
      top: 10%;
      right: 5%;
      font-size: 3rem;
      color: var(--sunny-color);
      animation: rotate 15s infinite linear;
    }
    
    .rainy {
      bottom: 20%;
      left: 5%;
      font-size: 4rem;
      color: var(--rainy-color);
      animation: bounce 5s infinite ease-in-out;
    }
    
    @keyframes rotate {
      from { transform: rotate(0deg); }
      to { transform: rotate(360deg); }
    }
    
    @keyframes bounce {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-20px); }
    }
    
    .weather-category {
      margin-bottom: 2.5rem;
      padding: 1.5rem;
      border-radius: 12px;
      transition: all 0.3s ease;
      position: relative;
      z-index: 1;
    }
    
    .weather-category:hover {
      transform: translateX(5px);
    }
    
    .sunny-bg {
      background: linear-gradient(to right, rgba(249, 168, 38, 0.1), transparent);
      border-left: 4px solid var(--sunny-color);
    }
    
    .rainy-bg {
      background: linear-gradient(to right, rgba(9, 132, 227, 0.1), transparent);
      border-left: 4px solid var(--rainy-color);
    }
    
    .cold-bg {
      background: linear-gradient(to right, rgba(116, 185, 255, 0.1), transparent);
      border-left: 4px solid var(--cold-color);
    }
    
    .stormy-bg {
      background: linear-gradient(to right, rgba(99, 110, 114, 0.1), transparent);
      border-left: 4px solid var(--stormy-color);
    }
    
    .category-header {
      display: flex;
      align-items: center;
      margin-bottom: 1.2rem;
    }
    
    .category-icon {
      font-size: 2rem;
      margin-right: 1rem;
      width: 60px;
      height: 60px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    .sunny-icon {
      background: rgba(249, 168, 38, 0.2);
      color: var(--sunny-color);
    }
    
    .rainy-icon {
      background: rgba(9, 132, 227, 0.2);
      color: var(--rainy-color);
    }
    
    .cold-icon {
      background: rgba(116, 185, 255, 0.2);
      color: var(--cold-color);
    }
    
    .stormy-icon {
      background: rgba(99, 110, 114, 0.2);
      color: var(--stormy-color);
    }
    
    .tip-item {
      display: flex;
      align-items: flex-start;
      margin-bottom: 1rem;
      padding: 1rem;
      background: white;
      border-radius: 8px;
      box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
      transition: all 0.3s ease;
      position: relative;
      z-index: 1;
    }
    
    .tip-item:hover {
      transform: translateY(-3px);
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    }
    
    .tip-icon {
      font-size: 1.5rem;
      margin-right: 1rem;
      min-width: 30px;
    }
    
    .sunny-tip { color: var(--sunny-color); }
    .rainy-tip { color: var(--rainy-color); }
    .cold-tip { color: var(--cold-color); }
    .stormy-tip { color: var(--stormy-color); }
    
    .tip-content {
      flex: 1;
    }
    
    .tip-content h5 {
      margin-bottom: 0.5rem;
      font-weight: 600;
    }
    
    .additional-tips {
      background: #f8f9fa;
      border-radius: 12px;
      padding: 1.5rem;
      margin: 2rem 0;
      position: relative;
      z-index: 1;
    }
    
    .tip-card {
      background: white;
      border-radius: 10px;
      padding: 1.2rem;
      margin-bottom: 1rem;
      box-shadow: 0 4px 8px rgba(0,0,0,0.05);
      border-top: 3px solid var(--primary-color);
    }
    
    .tip-card h5 {
      color: var(--primary-color);
      margin-bottom: 0.5rem;
    }
    
    .seasonal-section {
      margin-top: 2.5rem;
      position: relative;
      z-index: 1;
    }
    
    .seasonal-card {
      background: white;
      border-radius: 10px;
      padding: 1.5rem;
      margin-bottom: 1.5rem;
      box-shadow: 0 5px 15px rgba(0,0,0,0.08);
      border-left: 4px solid var(--accent-color);
    }
    
    .seasonal-card h4 {
      color: var(--accent-color);
      margin-bottom: 1rem;
    }
    
    .content-container {
      position: relative;
      z-index: 2;
    }
  </style>
</head>
<body class="weather-background">
  <!-- Animated weather elements -->
  <div class="weather-animation sunny">
    <i class="fas fa-sun"></i>
  </div>
  <div class="weather-animation rainy">
    <i class="fas fa-cloud-rain"></i>
  </div>
  
  <div class="container py-5 content-container">
    <div class="row justify-content-center">
      <div class="col-lg-10">
        <div class="tips-card">
          <a href="today_weather.jsp" class="btn-primary-custom mb-4">
            <i class="fas fa-arrow-left me-2"></i>Back to Home
          </a>
          
          <div class="text-center mb-4">
            <h1 class="header-title text-primary">🌤 Weather Tips</h1>
            <p class="lead">Practical advice to help you stay prepared and comfortable in any weather condition</p>
          </div>
          
          <div class="weather-category sunny-bg">
            <div class="category-header">
              <div class="category-icon sunny-icon">
                <i class="fas fa-sun"></i>
              </div>
              <h3 class="text-dark">Sunny & Hot Weather</h3>
            </div>
            
            <div class="tip-item">
              <div class="tip-icon sunny-tip">☀️</div>
              <div class="tip-content">
                <h5>Stay Hydrated</h5>
                <p class="mb-0">Drink plenty of water throughout the day, even if you don't feel thirsty. Avoid excessive caffeine and alcohol as they can contribute to dehydration.</p>
              </div>
            </div>
            
            <div class="tip-item">
              <div class="tip-icon sunny-tip">🧴</div>
              <div class="tip-content">
                <h5>Use Sun Protection</h5>
                <p class="mb-0">Apply broad-spectrum sunscreen with SPF 30 or higher 15-30 minutes before going outside. Reapply every 2 hours, or more often if swimming or sweating.</p>
              </div>
            </div>
            
            <div class="tip-item">
              <div class="tip-icon sunny-tip">👒</div>
              <div class="tip-content">
                <h5>Wear Appropriate Clothing</h5>
                <p class="mb-0">Choose lightweight, light-colored, and loose-fitting clothing. Wear a wide-brimmed hat to protect your face, neck, and ears from the sun.</p>
              </div>
            </div>
          </div>
          
          <div class="weather-category rainy-bg">
            <div class="category-header">
              <div class="category-icon rainy-icon">
                <i class="fas fa-cloud-rain"></i>
              </div>
              <h3 class="text-dark">Rainy & Wet Weather</h3>
            </div>
            
            <div class="tip-item">
              <div class="tip-icon rainy-tip">☔</div>
              <div class="tip-content">
                <h5>Carry Protection</h5>
                <p class="mb-0">Always keep a compact umbrella or waterproof jacket with you during rainy seasons. Consider waterproof bags for electronics and important items.</p>
              </div>
            </div>
            
            <div class="tip-item">
              <div class="tip-icon rainy-tip">👞</div>
              <div class="tip-content">
                <h5>Wear Proper Footwear</h5>
                <p class="mb-0">Choose waterproof or water-resistant shoes with good traction to prevent slipping on wet surfaces. Keep an extra pair of socks at work or in your car.</p>
              </div>
            </div>
            
            <div class="tip-item">
              <div class="tip-icon rainy-tip">🚗</div>
              <div class="tip-content">
                <h5>Drive Cautiously</h5>
                <p class="mb-0">Increase following distance, use headlights, and reduce speed on wet roads. Avoid driving through flooded areas - turn around, don't drown!</p>
              </div>
            </div>
          </div>
          
          <div class="weather-category cold-bg">
            <div class="category-header">
              <div class="category-icon cold-icon">
                <i class="fas fa-snowflake"></i>
              </div>
              <h3 class="text-dark">Cold & Winter Weather</h3>
            </div>
            
            <div class="tip-item">
              <div class="tip-icon cold-tip">❄️</div>
              <div class="tip-content">
                <h5>Layer Your Clothing</h5>
                <p class="mb-0">Wear multiple thin layers rather than one heavy layer. Start with moisture-wicking fabric next to skin, add insulating layers, and finish with a waterproof outer layer.</p>
              </div>
            </div>
            
            <div class="tip-item">
              <div class="tip-icon cold-tip">🧤</div>
              <div class="tip-content">
                <h5>Protect Extremities</h5>
                <p class="mb-0">Wear hats, gloves, scarves, and warm socks. Significant body heat is lost through the head, and extremities are vulnerable to frostbite.</p>
              </div>
            </div>
            
            <div class="tip-item">
              <div class="tip-icon cold-tip">🏠</div>
              <div class="tip-content">
                <h5>Winterize Your Home</h5>
                <p class="mb-0">Seal drafts around doors and windows, insulate pipes to prevent freezing, and ensure your heating system is serviced and working efficiently.</p>
              </div>
            </div>
          </div>
          
          <div class="weather-category stormy-bg">
            <div class="category-header">
              <div class="category-icon stormy-icon">
                <i class="fas fa-bolt"></i>
              </div>
              <h3 class="text-dark">Stormy & Severe Weather</h3>
            </div>
            
            <div class="tip-item">
              <div class="tip-icon stormy-tip">🌪️</div>
              <div class="tip-content">
                <h5>Seek Shelter Immediately</h5>
                <p class="mb-0">Go indoors during storms and avoid open areas, tall isolated trees, and metal objects. The safest place is an interior room on the lowest level of a sturdy building.</p>
              </div>
            </div>
            
            <div class="tip-item">
              <div class="tip-icon stormy-tip">📱</div>
              <div class="tip-content">
                <h5>Stay Informed</h5>
                <p class="mb-0">Monitor weather alerts and warnings through reliable sources. Have a battery-powered weather radio or enable emergency alerts on your phone.</p>
              </div>
            </div>
            
            <div class="tip-item">
              <div class="tip-icon stormy-tip">🛡️</div>
              <div class="tip-content">
                <h5>Prepare an Emergency Kit</h5>
                <p class="mb-0">Keep essentials like water, non-perishable food, flashlight, batteries, first aid supplies, and important documents readily accessible.</p>
              </div>
            </div>
          </div>
          
          <div class="seasonal-section">
            <h3 class="mb-4 text-center" style="color: var(--accent-color);">Seasonal Preparation Tips</h3>
            <div class="row">
              <div class="col-md-6">
                <div class="seasonal-card">
                  <h4><i class="fas fa-seedling me-2"></i>Spring Preparation</h4>
                  <ul class="mb-0">
                    <li>Check and clean gutters and downspouts</li>
                    <li>Inspect your roof for winter damage</li>
                    <li>Prepare for allergy season with necessary medications</li>
                    <li>Create an emergency plan for severe spring storms</li>
                  </ul>
                </div>
              </div>
              <div class="col-md-6">
                <div class="seasonal-card">
                  <h4><i class="fas fa-wind me-2"></i>Fall Preparation</h4>
                  <ul class="mb-0">
                    <li>Rake leaves regularly to prevent slippery surfaces</li>
                    <li>Check heating systems before cold weather arrives</li>
                    <li>Test smoke and carbon monoxide detectors</li>
                    <li>Store outdoor furniture and prepare for winter</li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
          
          <div class="additional-tips">
            <h4 class="mb-3"><i class="fas fa-lightbulb me-2" style="color: var(--sunny-color);"></i>Additional Weather Wisdom</h4>
            
            <div class="tip-card">
              <h5><i class="fas fa-cloud-sun me-2"></i>Check Forecasts Regularly</h5>
              <p class="mb-0">Make it a habit to check weather forecasts daily, especially if you have outdoor plans. Conditions can change rapidly.</p>
            </div>
            
            <div class="tip-card">
              <h5><i class="fas fa-car me-2"></i>Vehicle Preparedness</h5>
              <p class="mb-0">Keep an emergency kit in your car including blankets, water, snacks, flashlight, and basic tools regardless of the season.</p>
            </div>
            
            <div class="tip-card">
              <h5><i class="fas fa-house-user me-2"></i>Home Readiness</h5>
              <p class="mb-0">Weatherproof your home according to seasonal needs. This includes checking insulation, sealing drafts, and maintaining trees around your property.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>