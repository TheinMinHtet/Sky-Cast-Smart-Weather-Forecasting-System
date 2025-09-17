<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Careers - SkyCast</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
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
    
    .header h1 {
      font-size: 36px;
      font-weight: 700;
      margin-bottom: 15px;
      color: var(--primary);
      position: relative;
      display: inline-block;
    }
    
    .header h1::after {
      content: "";
      position: absolute;
      bottom: -10px;
      left: 50%;
      transform: translateX(-50%);
      width: 80px;
      height: 4px;
      background: var(--secondary);
      border-radius: 2px;
    }
    
    .header .lead {
      font-size: 18px;
      color: #7f8c8d;
      max-width: 600px;
      margin: 0 auto;
    }
    
    .intro {
      margin-bottom: 30px;
      text-align: center;
    }
    
    .intro p {
      font-size: 17px;
      line-height: 1.8;
      margin-bottom: 25px;
      color: #555;
    }
    
    .openings-section {
      margin: 40px 0;
    }
    
    .openings-section h4 {
      font-size: 24px;
      margin-bottom: 25px;
      color: var(--primary);
      position: relative;
      display: inline-block;
      padding-left: 15px;
      border-left: 4px solid var(--secondary);
    }
    
    .job-list {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    
    .job-item {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 12px;
      margin-bottom: 15px;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
      border-left: 4px solid var(--secondary);
    }
    
    .job-item:hover {
      transform: translateY(-3px);
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    }
    
    .job-item i {
      color: var(--secondary);
      margin-right: 10px;
      font-size: 18px;
    }
    
    .job-item span {
      font-weight: 600;
      color: var(--dark);
    }
    
    .contact {
      background: linear-gradient(135deg, var(--light) 0%, #dfe6e9 100%);
      padding: 25px;
      border-radius: 12px;
      text-align: center;
      margin: 40px 0;
    }
    
    .contact p {
      font-size: 17px;
      margin-bottom: 15px;
      color: var(--dark);
    }
    
    .email-link {
      display: inline-block;
      background: var(--secondary);
      color: white;
      padding: 12px 25px;
      border-radius: 30px;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s ease;
      box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
    }
    
    .email-link:hover {
      background: var(--primary);
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(52, 152, 219, 0.4);
      color: white;
    }
    
    .email-link i {
      margin-right: 8px;
    }
    
    .benefits {
      margin: 40px 0;
    }
    
    .benefits h4 {
      font-size: 24px;
      margin-bottom: 25px;
      color: var(--primary);
      position: relative;
      display: inline-block;
      padding-left: 15px;
      border-left: 4px solid var(--accent);
    }
    
    .benefits-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
    }
    
    .benefit-card {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 12px;
      text-align: center;
      transition: transform 0.3s ease;
    }
    
    .benefit-card:hover {
      transform: translateY(-5px);
    }
    
    .benefit-card i {
      font-size: 36px;
      color: var(--accent);
      margin-bottom: 15px;
    }
    
    .benefit-card h5 {
      font-size: 18px;
      margin-bottom: 10px;
      color: var(--primary);
    }
    
    .benefit-card p {
      font-size: 14px;
      color: #7f8c8d;
      margin: 0;
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
      
      .header h1 {
        font-size: 28px;
      }
      
      .benefits-grid {
        grid-template-columns: 1fr;
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
      <h1><i class="fas fa-rocket"></i> Careers at SkyCast</h1>
      <p class="lead">
        Join our team of passionate innovators and weather enthusiasts!
      </p>
    </div>
    
    <div class="intro">
      <p>
        At <strong>SkyCast</strong>, we believe in creating a positive impact through technology and 
        teamwork. We offer exciting opportunities for developers, data scientists, meteorologists, 
        and designers who want to shape the future of weather forecasting.
      </p>
    </div>
    
    <div class="openings-section">
      <h4><i class="fas fa-briefcase"></i> Current Openings</h4>
      <ul class="job-list">
        <li class="job-item"><i class="fas fa-code"></i> <span>Java Backend Developer</span></li>
        <li class="job-item"><i class="fas fa-laptop-code"></i> <span>Frontend Developer (React / JSP)</span></li>
        <li class="job-item"><i class="fas fa-chart-line"></i> <span>Data Scientist (Weather & Climate Modeling)</span></li>
        <li class="job-item"><i class="fas fa-bullhorn"></i> <span>Marketing & Community Manager</span></li>
      </ul>
    </div>
    
    <div class="benefits">
      <h4><i class="fas fa-gift"></i> Why Join Us?</h4>
      <div class="benefits-grid">
        <div class="benefit-card">
          <i class="fas fa-users"></i>
          <h5>Great Team</h5>
          <p>Work with talented and passionate colleagues</p>
        </div>
        <div class="benefit-card">
          <i class="fas fa-chart-line"></i>
          <h5>Growth Opportunities</h5>
          <p>Continuous learning and career development</p>
        </div>
        <div class="benefit-card">
          <i class="fas fa-heart"></i>
          <h5>Work-Life Balance</h5>
          <p>Flexible hours and remote work options</p>
        </div>
      </div>
    </div>
    
    <div class="contact">
      <p>
        If you are interested, please send your CV to  
      </p>
      <a href="mailto:careers@skycast.com" class="email-link">
        <i class="fas fa-envelope"></i> careers@skycast.com
      </a>
    </div>


  </div>
</body>
</html>