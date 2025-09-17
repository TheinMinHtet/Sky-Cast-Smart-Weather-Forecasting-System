<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Climate Info - SkyCast</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <style>
    :root {
      --primary-color: #2c7be5;
      --secondary-color: #6c757d;
      --accent-color: #00b4d8;
      --light-blue: #e6f2ff;
      --dark-blue: #0a2540;
      --success-color: #2ecc71;
    }
    
    body {
      font-family: "Segoe UI", Arial, sans-serif;
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      min-height: 100vh;
      margin: 0;
      padding: 0;
      color: #333;
      position: relative;
      /* REMOVED: overflow-x: hidden; */
    }
    
    .weather-background {
      position: relative;
      /* REMOVED: overflow: hidden; */
    }
    
    .weather-background::before {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1440 320'%3E%3Cpath fill='%232ecc71' fill-opacity='0.1' d='M0,224L48,213.3C96,203,192,181,288,160C384,139,480,117,576,122.7C672,128,768,160,864,170.7C960,181,1056,171,1152,165.3C1248,160,1344,160,1392,160L1440,160L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z'%3E%3C/path%3E%3C/svg%3E");
      background-size: cover;
      background-position: bottom;
      z-index: -1;
    }
    
    .climate-card {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
      backdrop-filter: blur(10px);
      padding: 2.5rem;
      margin: 2rem auto;
      transition: transform 0.3s ease;
      max-width: 900px;
    }
    
    .climate-card:hover {
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
      background: linear-gradient(90deg, var(--success-color), var(--accent-color));
      border-radius: 2px;
    }
    
    .btn-primary-custom {
      background: linear-gradient(135deg, var(--success-color), var(--accent-color));
      border: none;
      border-radius: 50px;
      padding: 0.75rem 2rem;
      font-weight: 600;
      transition: all 0.3s ease;
      box-shadow: 0 4px 15px rgba(46, 204, 113, 0.3);
      color: white;
      text-decoration: none;
      display: inline-block;
    }
    
    .btn-primary-custom:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 20px rgba(46, 204, 113, 0.4);
      color: white;
    }
    
    .cloud-animation {
      position: absolute;
      opacity: 0.7;
      z-index: -1;
    }
    
    .cloud1 {
      top: 10%;
      right: 5%;
      font-size: 3rem;
      color: var(--success-color);
      animation: float 15s infinite ease-in-out;
    }
    
    .cloud2 {
      bottom: 20%;
      left: 5%;
      font-size: 4rem;
      color: var(--accent-color);
      animation: float 18s infinite ease-in-out reverse;
    }
    
    @keyframes float {
      0%, 100% { transform: translateY(0) translateX(0); }
      50% { transform: translateY(-20px) translateX(20px); }
    }
    
    .info-section {
      margin: 2rem 0;
      padding: 1.5rem;
      border-radius: 10px;
      background: var(--light-blue);
    }
    
    .info-header {
      display: flex;
      align-items: center;
      margin-bottom: 1rem;
    }
    
    .info-icon {
      font-size: 1.8rem;
      color: var(--success-color);
      margin-right: 1rem;
    }
    
    .climate-fact {
      background: white;
      border-left: 4px solid var(--success-color);
      padding: 1rem 1.5rem;
      margin: 1.5rem 0;
      border-radius: 0 8px 8px 0;
      box-shadow: 0 4px 8px rgba(0,0,0,0.05);
    }
    
    .comparison-table {
      width: 100%;
      border-collapse: collapse;
      margin: 2rem 0;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      border-radius: 8px;
      overflow: hidden;
    }
    
    .comparison-table th, .comparison-table td {
      padding: 1rem;
      text-align: left;
      border-bottom: 1px solid #eee;
    }
    
    .comparison-table th {
      background: var(--success-color);
      color: white;
      font-weight: 600;
    }
    
    .comparison-table tr:last-child td {
      border-bottom: none;
    }
    
    .comparison-table tr:nth-child(even) {
      background: #f8f9fa;
    }
    
    .comparison-table tr:hover {
      background: #e9f7ef;
    }
  </style>
</head>
<body class="weather-background">
  <!-- Animated elements -->
  <div class="cloud-animation cloud1">
    <i class="fas fa-leaf"></i>
  </div>
  <div class="cloud-animation cloud2">
    <i class="fas fa-cloud-rain"></i>
  </div>
  
  <div class="container py-5">
    <div class="row justify-content-center">
      <div class="col-lg-10">
        <div class="climate-card">
          <a href="today_weather.jsp" class="btn-primary-custom mb-4">
            <i class="fas fa-arrow-left me-2"></i>Back to Home
          </a>
          
          <div class="text-center mb-4">
            <h1 class="header-title text-success">🌍 Climate Information</h1>
          </div>
          
          <div class="info-section">
            <div class="info-header">
              <div class="info-icon">
                <i class="fas fa-globe-americas"></i>
              </div>
              <h3>Understanding Climate</h3>
            </div>
            <p>
              Climate refers to the long-term patterns of temperature, humidity, wind, and precipitation in a region. 
              Unlike weather, which changes daily, climate describes average conditions over 30+ years.
            </p>
            <div class="climate-fact">
              <p class="mb-0"><strong>Did you know?</strong> Climate patterns help scientists predict long-term environmental changes and their impacts on ecosystems and human societies.</p>
            </div>
          </div>
          
          <div class="info-section">
            <div class="info-header">
              <div class="info-icon">
                <i class="fas fa-chart-line"></i>
              </div>
              <h3>SkyCast's Climate Insights</h3>
            </div>
            <p>
              <strong>SkyCast</strong> provides comprehensive climate insights to help communities prepare for long-term 
              environmental changes such as global warming and seasonal trends. Our data helps:
            </p>
            <ul>
              <li>Farmers plan crop cycles</li>
              <li>City planners develop climate-resilient infrastructure</li>
              <li>Researchers track climate change patterns</li>
              <li>Businesses make informed decisions based on climate trends</li>
            </ul>
          </div>
          
          <div class="info-section">
            <div class="info-header">
              <div class="info-icon">
                <i class="fas fa-balance-scale-left"></i>
              </div>
              <h3>Weather vs. Climate</h3>
            </div>
            <p>Many people confuse weather with climate. Here's the difference:</p>
            
            <table class="comparison-table">
              <thead>
                <tr>
                  <th>Aspect</th>
                  <th>Weather</th>
                  <th>Climate</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td><strong>Definition</strong></td>
                  <td>Short-term atmospheric conditions</td>
                  <td>Long-term weather patterns</td>
                </tr>
                <tr>
                  <td><strong>Timeframe</strong></td>
                  <td>Minutes to weeks</td>
                  <td>Years to centuries</td>
                </tr>
                <tr>
                  <td><strong>Predictability</strong></td>
                  <td>Changes frequently</td>
                  <td>Remains relatively stable</td>
                </tr>
                <tr>
                  <td><strong>Measurement</strong></td>
                  <td>Current conditions</td>
                  <td>Statistical averages</td>
                </tr>
                <tr>
                  <td><strong>Example</strong></td>
                  <td>Today's rainstorm</td>
                  <td>Desert arid conditions</td>
                </tr>
              </tbody>
            </table>
          </div>
          
          <div class="info-section">
            <div class="info-header">
              <div class="info-icon">
                <i class="fas fa-hands-helping"></i>
              </div>
              <h3>How You Can Help</h3>
            </div>
            <p>Climate change is a global challenge that requires collective action. Here's how you can contribute:</p>
            <div class="row">
              <div class="col-md-6 mb-3">
                <div class="climate-fact">
                  <h6><i class="fas fa-bolt me-2"></i>Reduce Energy Consumption</h6>
                  <p class="mb-0 small">Use energy-efficient appliances and turn off lights when not in use.</p>
                </div>
              </div>
              <div class="col-md-6 mb-3">
                <div class="climate-fact">
                  <h6><i class="fas fa-recycle me-2"></i>Practice Recycling</h6>
                  <p class="mb-0 small">Proper waste separation reduces landfill and pollution.</p>
                </div>
              </div>
              <div class="col-md-6 mb-3">
                <div class="climate-fact">
                  <h6><i class="fas fa-tree me-2"></i>Support Conservation</h6>
                  <p class="mb-0 small">Protect forests and plant trees to absorb CO₂.</p>
                </div>
              </div>
              <div class="col-md-6 mb-3">
                <div class="climate-fact">
                  <h6><i class="fas fa-bus me-2"></i>Use Sustainable Transport</h6>
                  <p class="mb-0 small">Walk, bike, or use public transportation when possible.</p>
                </div>
              </div>
            </div>
          </div>
          
          <div class="text-center mt-4">
            <p class="mb-3">Explore more climate resources:</p>
            <a href="#" class="btn btn-outline-success me-2">Climate Trends</a>
            <a href="#" class="btn btn-outline-primary me-2">Seasonal Forecasts</a>
            <a href="#" class="btn btn-outline-info">Environmental Impact</a>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>