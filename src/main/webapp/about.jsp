<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>About Us - SkyCast</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
  <style>
    :root {
      --primary: #2c3e50;
      --secondary: #3498db;
      --accent: #e74c3c;
      --light: #ecf0f1;
      --dark: #2c3e50;
    }
    
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      margin: 0;
      padding: 0;
      color: var(--dark);
      min-height: 100vh;
    }
    
    .page-container {
      max-width: 900px;
      margin: 60px auto;
      background: #fff;
      padding: 40px;
      border-radius: 16px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
      position: relative;
      overflow: hidden;
    }
    
    .page-container::before {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 5px;
      background: linear-gradient(90deg, var(--secondary), var(--accent));
    }
    
    .header {
      text-align: center;
      margin-bottom: 30px;
      position: relative;
    }
    
    .header h2 {
      font-size: 36px;
      font-weight: 700;
      margin-bottom: 15px;
      color: var(--primary);
      position: relative;
      display: inline-block;
    }
    
    .header h2::after {
      content: "";
      position: absolute;
      bottom: -10px;
      left: 50%;
      transform: translateX(-50%);
      width: 60px;
      height: 4px;
      background: var(--secondary);
      border-radius: 2px;
    }
    
    .header p {
      font-size: 18px;
      color: #7f8c8d;
      max-width: 600px;
      margin: 0 auto;
    }
    
    .content {
      margin-bottom: 30px;
    }
    
    .content p {
      font-size: 17px;
      line-height: 1.8;
      margin-bottom: 25px;
      color: #555;
      position: relative;
      padding-left: 30px;
    }
    
    .content p::before {
      content: "•";
      color: var(--secondary);
      font-size: 24px;
      position: absolute;
      left: 0;
      top: -2px;
    }
    
    .features {
      display: flex;
      flex-wrap: wrap;
      gap: 20px;
      margin: 40px 0;
    }
    
    .feature {
      flex: 1;
      min-width: 250px;
      background: #f8f9fa;
      padding: 25px;
      border-radius: 12px;
      text-align: center;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    
    .feature:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
    }
    
    .feature i {
      font-size: 40px;
      color: var(--secondary);
      margin-bottom: 15px;
    }
    
    .feature h4 {
      font-size: 20px;
      margin-bottom: 12px;
      color: var(--primary);
    }
    
    .feature p {
      font-size: 15px;
      color: #7f8c8d;
      margin: 0;
      padding: 0;
    }
    
    .feature p::before {
      display: none;
    }
    
    .team {
      margin: 40px 0;
      text-align: center;
    }
    
    .team h3 {
      font-size: 24px;
      margin-bottom: 30px;
      color: var(--primary);
      position: relative;
      display: inline-block;
    }
    
    .team h3::after {
      content: "";
      position: absolute;
      bottom: -10px;
      left: 50%;
      transform: translateX(-50%);
      width: 40px;
      height: 3px;
      background: var(--accent);
    }
    
    .team-members {
      display: flex;
      justify-content: center;
      gap: 30px;
      flex-wrap: wrap;
    }
    
    .member {
      width: 120px;
    }
    
    .member-img {
      width: 80px;
      height: 80px;
      border-radius: 50%;
      background: var(--secondary);
      margin: 0 auto 15px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 30px;
    }
    
    .member h5 {
      font-size: 16px;
      margin-bottom: 5px;
      color: var(--dark);
    }
    
    .member p {
      font-size: 14px;
      color: #7f8c8d;
      margin: 0;
      padding: 0;
    }
    
    .member p::before {
      display: none;
    }
    
    .back-btn {
      display: inline-flex;
      align-items: center;
      margin-top: 20px;
      padding: 12px 25px;
      font-size: 16px;
      font-weight: 600;
      color: #fff;
      background: linear-gradient(90deg, var(--secondary), var(--primary));
      border-radius: 30px;
      text-decoration: none;
      transition: all 0.3s ease;
      box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
    }
    
    .back-btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(52, 152, 219, 0.4);
      color: #fff;
    }
    
    .back-btn i {
      margin-right: 8px;
    }
    
    @media (max-width: 768px) {
      .page-container {
        margin: 30px 15px;
        padding: 25px;
      }
      
      .header h2 {
        font-size: 28px;
      }
      
      .content p {
        padding-left: 20px;
      }
    }
  </style>
</head>
<body>
  <div class="page-container">
      <a href="today_weather.jsp" class="back-btn">
      <i class="fas fa-arrow-left"></i> Back to Home
    </a>
    <div class="header">
      <h2>About SkyCast</h2>
      <p>Your trusted weather companion for accurate forecasts</p>
    </div>
    
    <div class="content">
      <p>
        Welcome to <b>SkyCast</b>! We are passionate about providing accurate and
        real-time weather information to keep you safe and informed.
      </p>
      <p>
        Our mission is to make weather updates accessible for everyone,
        anytime, anywhere. We combine the latest forecasting technology
        with a user-friendly design to give you the clearest picture of
        the skies above.
      </p>
    </div>
    
    <div class="features">
      <div class="feature">
        <i class="fas fa-bolt"></i>
        <h4>Real-Time Updates</h4>
        <p>Get instant weather updates as conditions change</p>
      </div>
      <div class="feature">
        <i class="fas fa-map-marker-alt"></i>
        <h4>Global Coverage</h4>
        <p>Accurate forecasts for locations worldwide</p>
      </div>
      <div class="feature">
        <i class="fas fa-mobile-alt"></i>
        <h4>Mobile Friendly</h4>
        <p>Access weather information on any device</p>
      </div>
    </div>
    
    <div class="team">
      <h3>Our Team</h3>
      <div class="team-members">
        <div class="member">
          <div class="member-img">
            <i class="fas fa-user"></i>
          </div>
          <h5>HayMann</h5>
          <p>Founder & CEO</p>
        </div>
        <div class="member">
          <div class="member-img">
            <i class="fas fa-user"></i>
          </div>
          <h5>Khin Phoo Phoo Aung</h5>
          <p>Lead Meteorologist</p>
        </div>
        <div class="member">
          <div class="member-img">
            <i class="fas fa-user"></i>
          </div>
          <h5>Thein Min Htet</h5>
          <p>Software Developer</p>
        </div>
         <div class="member">
          <div class="member-img">
            <i class="fas fa-user"></i>
          </div>
          <h5>Sein Mauk Lin Htet</h5>
          <p>Software Developer</p>
        </div>
      </div>
       
    

  </div>
</body>
</html>