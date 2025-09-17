<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Our Mission - SkyCast</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <style>
    :root {
      --primary-color: #2c7be5;
      --secondary-color: #6c757d;
      --accent-color: #00b4d8;
      --light-blue: #e6f2ff;
      --dark-blue: #0a2540;
    }
    
    body {
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      min-height: 100vh;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      position: relative;
    }
    
    .weather-background {
      position: relative;
      overflow: visible; /* Changed from hidden to visible */
      min-height: 100vh;
    }
    
    .weather-background::before {
      content: "";
      position: absolute; /* Changed back to absolute */
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1440 320'%3E%3Cpath fill='%232c7be5' fill-opacity='0.1' d='M0,224L48,213.3C96,203,192,181,288,160C384,139,480,117,576,122.7C672,128,768,160,864,170.7C960,181,1056,171,1152,165.3C1248,160,1344,160,1392,160L1440,160L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z'%3E%3C/path%3E%3C/svg%3E");
      background-size: cover;
      background-position: bottom;
      z-index: -1;
      pointer-events: none;
    }
    
    .mission-card {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
      backdrop-filter: blur(10px);
      padding: 2.5rem;
      margin: 2rem 0;
      transition: transform 0.3s ease;
    }
    
    .mission-card:hover {
      transform: translateY(-5px);
    }
    
    .mission-icon {
      font-size: 2.5rem;
      color: var(--accent-color);
      margin-bottom: 1rem;
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
      background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
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
    }
    
    .btn-primary-custom:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 20px rgba(44, 123, 229, 0.4);
    }
    
    .cloud-animation {
      position: absolute; /* Changed back to absolute */
      opacity: 0.7;
      z-index: -1;
      pointer-events: none;
    }
    
    .cloud1 {
      top: 10%;
      right: 5%;
      font-size: 3rem;
      animation: float 15s infinite ease-in-out;
    }
    
    .cloud2 {
      bottom: 20%;
      left: 5%;
      font-size: 4rem;
      animation: float 18s infinite ease-in-out reverse;
    }
    
    @keyframes float {
      0%, 100% { transform: translateY(0) translateX(0); }
      50% { transform: translateY(-20px) translateX(20px); }
    }
    
    .value-card {
      text-align: center;
      padding: 1.5rem;
      border-radius: 10px;
      background: white;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
      height: 100%;
      transition: all 0.3s ease;
    }
    
    .value-card:hover {
      background: var(--light-blue);
      transform: translateY(-5px);
    }
    
    .value-icon {
      font-size: 2rem;
      color: var(--primary-color);
      margin-bottom: 1rem;
    }
    
    /* Fixed back button */
    .fixed-back-button {
      position: fixed;
      top: 20px;
      left: 20px;
      z-index: 1000;
    }
  </style>
</head>
<body class="weather-background">
  <!-- Fixed back button -->

  
  <!-- Animated clouds -->
  <div class="cloud-animation cloud1">
    <i class="fas fa-cloud"></i>
  </div>
  <div class="cloud-animation cloud2">
    <i class="fas fa-cloud"></i>
  </div>
  
  <div class="container py-5">
    <div class="row justify-content-center">
      <div class="col-lg-10">
        <div class="mission-card">
          <div class="text-center mb-4">
            <div class="mission-icon">
              <i class="fas fa-bullseye"></i>
                <div class="fixed-back-button">
    <a href="index.jsp" class="btn btn-primary-custom">
      <i class="fas fa-arrow-left me-2"></i>Back to Home
    </a>
  </div>
            </div>
            <h1 class="header-title text-primary">🌍 Our Mission</h1>
          </div>
          
          <p class="lead text-center mb-4">
            At <strong class="text-primary">SkyCast</strong>, our mission is to provide reliable, real-time weather updates and 
            climate insights that empower people to make smarter decisions in their daily lives.  
          </p>
          
          <div class="row my-5">
            <div class="col-md-4 mb-4">
              <div class="value-card">
                <div class="value-icon">
                  <i class="fas fa-target"></i>
                </div>
                <h4>Accuracy</h4>
                <p>Precision forecasting using the latest meteorological technology</p>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="value-card">
                <div class="value-icon">
                  <i class="fas fa-lightbulb"></i>
                </div>
                <h4>Innovation</h4>
                <p>Continually improving our models and prediction algorithms</p>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="value-card">
                <div class="value-icon">
                  <i class="fas fa-globe-americas"></i>
                </div>
                <h4>Accessibility</h4>
                <p>Making weather information available to everyone, everywhere</p>
              </div>
            </div>
          </div>
          
          <p class="mb-4">
            We are committed to accuracy, innovation, and accessibility. By using advanced 
            forecasting technologies, we strive to help communities prepare for severe weather, 
            support businesses with climate data, and raise awareness about climate change.  
          </p>
          
          <blockquote class="blockquote text-center my-5 py-3" style="border-left: 4px solid var(--accent-color); background-color: var(--light-blue);">
            <p class="mb-0"><em>"Better Forecasts, Safer Lives."</em></p>
          </blockquote>
        </div>
        
        <!-- Additional content to demonstrate scrolling -->
        <div class="mission-card mt-4">
          <h3 class="text-center mb-4">Our Commitment to Excellence</h3>
          <p>At SkyCast, we believe that weather forecasting is more than just predicting temperatures and precipitation. It's about providing people with the information they need to make informed decisions about their day, their safety, and their future.</p>
          
          <p>Our team of meteorologists, data scientists, and software engineers work tirelessly to ensure that our forecasts are as accurate as possible. We utilize cutting-edge technology, including advanced radar systems, satellite imagery, and machine learning algorithms, to analyze weather patterns and predict changes with precision.</p>
          
          <p>But our commitment doesn't stop at accuracy. We're dedicated to making weather information accessible to everyone, regardless of their location or technical expertise. Our user-friendly interface and clear, concise forecasts make it easy for anyone to understand the weather conditions in their area.</p>
          
          <p>We also recognize the importance of weather information in the face of climate change. As extreme weather events become more frequent and intense, reliable forecasting is more critical than ever. We're committed to providing timely warnings and detailed information to help communities prepare for and respond to severe weather.</p>
          
          <p>Thank you for choosing SkyCast as your weather provider. We're honored to be a part of your daily routine and to help you stay informed and safe in any weather condition.</p>
          
          <p>Our global network of weather stations collects data from every corner of the planet, ensuring that our forecasts are based on the most comprehensive and up-to-date information available. We process billions of data points every day to deliver accurate predictions for your exact location.</p>
          
          <p>Looking to the future, we're investing in research and development to improve our forecasting models even further. We're exploring new technologies like artificial intelligence and quantum computing to push the boundaries of what's possible in weather prediction.</p>
          
          <p>We believe that everyone deserves access to reliable weather information, which is why we offer our basic services for free. Our premium features provide even more detailed forecasts and advanced tools for those who need them, but we'll always ensure that essential weather information remains available to all.</p>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>