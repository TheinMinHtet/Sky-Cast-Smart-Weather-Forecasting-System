<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Safety Guides - SkyCast</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <style>
    :root {
      --primary-color: #2c7be5;
      --secondary-color: #6c757d;
      --accent-color: #ff6b6b;
      --warning-color: #f9a826;
      --light-blue: #e6f2ff;
      --dark-blue: #0a2540;
    }
    
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(135deg, #f5f7fa 0%, #e6f2ff 100%);
      min-height: 100vh;
      margin: 0;
      padding: 0;
      color: #333;
      position: relative;
      overflow-x: hidden;
    }
    
    .weather-background::before {
      content: "";
      position: fixed; /* Changed from absolute to fixed */
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1440 320'%3E%3Cpath fill='%23ff6b6b' fill-opacity='0.1' d='M0,224L48,213.3C96,203,192,181,288,160C384,139,480,117,576,122.7C672,128,768,160,864,170.7C960,181,1056,171,1152,165.3C1248,160,1344,160,1392,160L1440,160L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z'%3E%3C/path%3E%3C/svg%3E");
      background-size: cover;
      background-position: bottom;
      z-index: -1;
      pointer-events: none; /* Allow clicks to pass through */
    }
    
    .safety-card {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
      backdrop-filter: blur(10px);
      padding: 2.5rem;
      margin: 2rem auto;
      transition: transform 0.3s ease;
      max-width: 1000px;
    }
    
    .safety-card:hover {
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
      background: linear-gradient(90deg, var(--accent-color), var(--warning-color));
      border-radius: 2px;
    }
    
    .btn-primary-custom {
      background: linear-gradient(135deg, var(--accent-color), var(--warning-color));
      border: none;
      border-radius: 50px;
      padding: 0.75rem 2rem;
      font-weight: 600;
      transition: all 0.3s ease;
      box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3);
      color: white;
      text-decoration: none;
      display: inline-block;
    }
    
    .btn-primary-custom:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 20px rgba(255, 107, 107, 0.4);
      color: white;
    }
    
    .warning-animation {
      position: fixed; /* Changed from absolute to fixed */
      opacity: 0.7;
      z-index: -1;
      pointer-events: none; /* Allow clicks to pass through */
    }
    
    .warning1 {
      top: 10%;
      right: 5%;
      font-size: 3rem;
      color: var(--accent-color);
      animation: pulse 2s infinite ease-in-out;
    }
    
    .warning2 {
      bottom: 20%;
      left: 5%;
      font-size: 4rem;
      color: var(--warning-color);
      animation: pulse 3s infinite ease-in-out reverse;
    }
    
    @keyframes pulse {
      0%, 100% { transform: scale(1); opacity: 0.7; }
      50% { transform: scale(1.1); opacity: 0.9; }
    }
    
    .safety-section {
      margin: 2rem 0;
      padding: 1.5rem;
      border-radius: 10px;
      background: #fff9f9;
      border-left: 4px solid var(--accent-color);
    }
    
    .safety-header {
      display: flex;
      align-items: center;
      margin-bottom: 1rem;
    }
    
    .safety-icon {
      font-size: 1.8rem;
      color: var(--accent-color);
      margin-right: 1rem;
      width: 50px;
      height: 50px;
      background: #ffecec;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    .safety-tip {
      background: white;
      border-left: 4px solid var(--warning-color);
      padding: 1rem 1.5rem;
      margin: 1rem 0;
      border-radius: 0 8px 8px 0;
      box-shadow: 0 4px 8px rgba(0,0,0,0.05);
      display: flex;
      align-items: flex-start;
    }
    
    .tip-icon {
      font-size: 1.5rem;
      margin-right: 1rem;
      color: var(--warning-color);
    }
    
    .emergency-kit {
      background: #fffaf0;
      border-radius: 10px;
      padding: 1.5rem;
      margin: 2rem 0;
      border: 1px dashed var(--warning-color);
    }
    
    .kit-item {
      display: flex;
      align-items: center;
      margin-bottom: 0.8rem;
    }
    
    .kit-icon {
      font-size: 1.2rem;
      color: var(--warning-color);
      margin-right: 0.8rem;
      width: 30px;
      text-align: center;
    }
    
    .weather-type {
      margin-bottom: 2rem;
    }
    
    .weather-type h4 {
      color: var(--accent-color);
      margin-bottom: 1rem;
      padding-bottom: 0.5rem;
      border-bottom: 2px solid #ffecec;
    }
    
    .alert-badge {
      background: var(--accent-color);
      color: white;
      padding: 0.3rem 0.8rem;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 600;
      margin-left: 1rem;
    }
    
    .tab-content {
      padding: 1.5rem 0;
    }
    
    .nav-tabs .nav-link {
      color: var(--secondary-color);
      font-weight: 500;
      border: none;
      padding: 0.8rem 1.5rem;
    }
    
    .nav-tabs .nav-link.active {
      color: var(--accent-color);
      background: transparent;
      border-bottom: 3px solid var(--accent-color);
    }
    
    .nav-tabs {
      border-bottom: 2px solid #eee;
    }
    
    /* Added content to demonstrate scrolling */
    .extra-content {
      margin-top: 2rem;
      padding: 1.5rem;
      background: rgba(255, 255, 255, 0.9);
      border-radius: 10px;
    }
  </style>
</head>
<body class="weather-background">
  <!-- Animated warning elements -->
  <div class="warning-animation warning1">
    <i class="fas fa-exclamation-triangle"></i>
  </div>
  <div class="warning-animation warning2">
    <i class="fas fa-house-damage"></i>
  </div>
  
  <div class="container py-5">
    <div class="row justify-content-center">
      <div class="col-lg-10">
        <div class="safety-card">
          <a href="today_weather.jsp" class="btn-primary-custom mb-4">
            <i class="fas fa-arrow-left me-2"></i>Back to Home
          </a>
          
          <div class="text-center mb-4">
            <h1 class="header-title text-danger">⚠️ Weather Safety Guides</h1>
            <p class="lead">Essential safety measures to protect yourself during severe weather events</p>
          </div>
          
          <ul class="nav nav-tabs" id="safetyTabs" role="tablist">
            <li class="nav-item" role="presentation">
              <button class="nav-link active" id="thunderstorm-tab" data-bs-toggle="tab" data-bs-target="#thunderstorm" type="button" role="tab">Thunderstorms</button>
            </li>
            <li class="nav-item" role="presentation">
              <button class="nav-link" id="flood-tab" data-bs-toggle="tab" data-bs-target="#flood" type="button" role="tab">Floods</button>
            </li>
            <li class="nav-item" role="presentation">
              <button class="nav-link" id="heatwave-tab" data-bs-toggle="tab" data-bs-target="#heatwave" type="button" role="tab">Heatwaves</button>
            </li>
            <li class="nav-item" role="presentation">
              <button class="nav-link" id="cyclone-tab" data-bs-toggle="tab" data-bs-target="#cyclone" type="button" role="tab">Cyclones</button>
            </li>
          </ul>
          
          <div class="tab-content" id="safetyTabsContent">
            <div class="tab-pane fade show active" id="thunderstorm" role="tabpanel">
              <div class="safety-section">
                <div class="safety-header">
                  <div class="safety-icon">
                    <i class="fas fa-bolt"></i>
                  </div>
                  <h3>Thunderstorm Safety <span class="alert-badge">Danger: Lightning</span></h3>
                </div>
                
                <div class="safety-tip">
                  <div class="tip-icon">⚡</div>
                  <div>
                    <h5>Avoid Electrical Appliances</h5>
                    <p class="mb-0">Unplug electronic equipment before the storm arrives. Avoid using corded phones, computers, and other electrical devices that put you in direct contact with electricity.</p>
                  </div>
                </div>
                
                <div class="safety-tip">
                  <div class="tip-icon">🏠</div>
                  <div>
                    <h5>Seek Shelter Immediately</h5>
                    <p class="mb-0">Go inside a sturdy building or hard-top automobile. Do not take shelter in small sheds, under isolated trees, or in convertible automobiles.</p>
                  </div>
                </div>
                
                <div class="safety-tip">
                  <div class="tip-icon">🚫</div>
                  <div>
                    <h5>Avoid Water Sources</h5>
                    <p class="mb-0">Avoid bathing, showering, or washing dishes during a thunderstorm as lightning can travel through plumbing.</p>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="tab-pane fade" id="flood" role="tabpanel">
              <div class="safety-section">
                <div class="safety-header">
                  <div class="safety-icon">
                    <i class="fas fa-water"></i>
                  </div>
                  <h3>Flood Safety <span class="alert-badge">Danger: Rising Water</span></h3>
                </div>
                
                <div class="safety-tip">
                  <div class="tip-icon">🌊</div>
                  <div>
                    <h5>Move to Higher Ground</h5>
                    <p class="mb-0">If flooding occurs, get to higher ground immediately. Avoid areas subject to flooding such as dips, low spots, valleys, and drainage ditches.</p>
                  </div>
                </div>
                
                <div class="safety-tip">
                  <div class="tip-icon">🚗</div>
                  <div>
                    <h5>Never Drive Through Floodwaters</h5>
                    <p class="mb-0">Turn around, don't drown! Just 6 inches of moving water can knock you down, and 2 feet of water can sweep your vehicle away.</p>
                  </div>
                </div>
                
                <div class="safety-tip">
                  <div class="tip-icon">📱</div>
                  <div>
                    <h5>Stay Informed</h5>
                    <p class="mb-0">Monitor NOAA Weather Radio or local alerting systems for current flood information and forecasts.</p>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="tab-pane fade" id="heatwave" role="tabpanel">
              <div class="safety-section">
                <div class="safety-header">
                  <div class="safety-icon">
                    <i class="fas fa-sun"></i>
                  </div>
                  <h3>Heatwave Safety <span class="alert-badge">Danger: Overheating</span></h3>
                </div>
                
                <div class="safety-tip">
                  <div class="tip-icon">🔥</div>
                  <div>
                    <h5>Stay Indoors</h5>
                    <p class="mb-0">During extreme heat, stay indoors in air-conditioned facilities. Avoid strenuous activities and exercise during the hottest part of the day (typically 10am-4pm).</p>
                  </div>
                </div>
                
                <div class="safety-tip">
                  <div class="tip-icon">💧</div>
                  <div>
                    <h5>Stay Hydrated</h5>
                    <p class="mb-0">Drink plenty of water even if you don't feel thirsty. Avoid alcoholic beverages and liquids high in sugar or caffeine.</p>
                  </div>
                </div>
                
                <div class="safety-tip">
                  <div class="tip-icon">👕</div>
                  <div>
                    <h5>Wear Appropriate Clothing</h5>
                    <p class="mb-0">Choose lightweight, light-colored, and loose-fitting clothing. A wide-brimmed hat can provide shade and keep you cooler.</p>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="tab-pane fade" id="cyclone" role="tabpanel">
              <div class="safety-section">
                <div class="safety-header">
                  <div class="safety-icon">
                    <i class="fas fa-wind"></i>
                  </div>
                  <h3>Cyclone Safety <span class="alert-badge">Danger: High Winds</span></h3>
                </div>
                
                <div class="safety-tip">
                  <div class="tip-icon">🌪</div>
                  <div>
                    <h5>Prepare an Emergency Kit</h5>
                    <p class="mb-0">Always keep an emergency kit ready with essentials like water, non-perishable food, flashlight, batteries, first aid supplies, and important documents.</p>
                  </div>
                </div>
                
                <div class="safety-tip">
                  <div class="tip-icon">🏠</div>
                  <div>
                    <h5>Secure Your Property</h5>
                    <p class="mb-0">Install storm shutters or board up windows with plywood. Secure outdoor objects that could blow away and cause damage.</p>
                  </div>
                </div>
                
                <div class="safety-tip">
                  <div class="tip-icon">🛌</div>
                  <div>
                    <h5>Know Your Shelter</h5>
                    <p class="mb-0">Identify a safe room in your home, usually an interior room, basement, or storm cellar without windows on the lowest level.</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div class="emergency-kit">
            <h4><i class="fas fa-first-aid me-2"></i>Emergency Preparedness Kit</h4>
            <p>Every household should have a basic emergency kit that includes:</p>
            <div class="row">
              <div class="col-md-6">
                <div class="kit-item">
                  <div class="kit-icon"><i class="fas fa-tint"></i></div>
                  <div>Water (1 gallon per person per day for 3 days)</div>
                </div>
                <div class="kit-item">
                  <div class="kit-icon"><i class="fas fa-utensils"></i></div>
                  <div>3-day supply of non-perishable food</div>
                </div>
                <div class="kit-item">
                  <div class="kit-icon"><i class="fas fa-first-aid"></i></div>
                  <div>First aid kit</div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="kit-item">
                  <div class="kit-icon"><i class="fas fa-flashlight"></i></div>
                  <div>Flashlight and extra batteries</div>
                </div>
                <div class="kit-item">
                  <div class="kit-icon"><i class="fas fa-broadcast-tower"></i></div>
                  <div>Battery-powered weather radio</div>
                </div>
                <div class="kit-item">
                  <div class="kit-icon"><i class="fas fa-file-alt"></i></div>
                  <div>Important documents in waterproof container</div>
                </div>
              </div>
            </div>
          </div>
          
          <div class="alert alert-warning mt-4">
            <h5><i class="fas fa-exclamation-circle me-2"></i>Important Reminder</h5>
            <p class="mb-0">Always follow evacuation orders from local authorities. Your safety is more important than property. Stay informed through official weather channels and have multiple ways to receive warnings.</p>
          </div>
          
          <!-- Additional content to demonstrate scrolling -->
          <div class="extra-content">
            <h4>Additional Weather Safety Information</h4>
            <p>Being prepared for severe weather is crucial for your safety and the safety of your loved ones. Here are some additional tips:</p>
            
            <h5>Create a Family Emergency Plan</h5>
            <p>Discuss with your family what to do in different emergency situations. Identify safe spots in your home for each type of disaster and establish a meeting place in case you get separated.</p>
            
            <h5>Stay Informed</h5>
            <p>Download weather apps from trusted sources like the National Weather Service or your local meteorological agency. Enable emergency alerts on your phone to receive timely warnings.</p>
            
            <h5>Practice Drills</h5>
            <p>Regularly practice emergency drills with your family so everyone knows what to do when severe weather strikes. This is especially important for children.</p>
            
            <h5>Check on Neighbors</h5>
            <p>After a severe weather event, check on neighbors, especially the elderly, those with disabilities, and others who might need assistance.</p>
            
            <h5>Review Insurance Coverage</h5>
            <p>Regularly review your insurance policies to ensure you have adequate coverage for different types of weather-related damage common in your area.</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>