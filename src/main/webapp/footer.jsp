<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    String user = (String) session.getAttribute("username"); // or however you store login
    boolean loggedIn = (user != null);
%>
    
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>SkyCast</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <style>
    :root {
      --primary-color: #2c7be5;
      --secondary-color: #6c757d;
      --accent-color: #00c9ff;
      --dark-color: #343a40;
      --light-color: #f8f9fa;
    }
    
    body {
      display: flex;
      flex-direction: column;
      min-height: 100vh;
    }
    
    main {
      flex: 1;
    }
    
    footer {
      background: linear-gradient(135deg, #2c3e50, #1a1a2e) !important;
      color: #fff !important;
      position: relative;
      overflow: hidden;
    }
    
    footer::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%2300c9ff" fill-opacity="0.1" d="M0,128L48,117.3C96,107,192,85,288,112C384,139,480,213,576,218.7C672,224,768,160,864,138.7C960,117,1056,139,1152,149.3C1248,160,1344,160,1392,160L1440,160L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>');
      background-size: cover;
      background-position: center;
      opacity: 0.3;
    }
    
    .footer-title {
      position: relative;
      padding-bottom: 10px;
      margin-bottom: 20px;
      font-weight: 700;
    }
    
    .footer-title::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 0;
      width: 50px;
      height: 3px;
      background: var(--accent-color);
      border-radius: 2px;
    }
    
    .footer-links li {
      margin-bottom: 12px;
      transition: all 0.3s ease;
    }
    
    .footer-links a {
      color: #e9ecef !important;
      text-decoration: none;
      transition: all 0.3s ease;
      position: relative;
      padding-left: 0;
    }
    
    .footer-links a:hover {
      color: var(--accent-color) !important;
      padding-left: 8px;
    }
    
    .footer-links a::before {
      content: '→';
      position: absolute;
      left: -15px;
      opacity: 0;
      transition: all 0.3s ease;
    }
    
    .footer-links a:hover::before {
      left: -10px;
      opacity: 1;
    }
    
    .social-icons a {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.1);
      color: white;
      margin-right: 10px;
      transition: all 0.3s ease;
    }
    
    .social-icons a:hover {
      background: var(--accent-color);
      transform: translateY(-3px);
      box-shadow: 0 5px 15px rgba(0, 201, 255, 0.3);
    }
    
    .contact-info li {
      margin-bottom: 15px;
      display: flex;
      align-items: center;
    }
    
    .contact-info i {
      margin-right: 10px;
      color: var(--accent-color);
      width: 20px;
    }
    
    .subscribe-form .input-group {
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
      border-radius: 50px;
      overflow: hidden;
    }
    
    .subscribe-form input {
      background: rgba(255, 255, 255, 0.9);
      border: none;
      padding: 12px 20px;
    }
    
    .subscribe-form button {
      background: var(--accent-color);
      border: none;
      padding: 12px 20px;
      font-weight: 600;
      transition: all 0.3s ease;
    }
    
    .subscribe-form button:hover {
      background: #00b4e6;
    }
    
    .copyright {
      border-top: 1px solid rgba(255, 255, 255, 0.1);
      padding-top: 20px;
    }
    
    .copyright a {
      color: #e9ecef !important;
      text-decoration: none;
      transition: all 0.3s ease;
    }
    
    .copyright a:hover {
      color: var(--accent-color) !important;
    }
    
    .weather-icon {
      position: absolute;
      opacity: 0.05;
      font-size: 15rem;
      bottom: -50px;
      right: 50px;
      z-index: 0;
    }
    
    /* Enhanced Suggestion Box Styles */
    .suggestion-box {
      background: rgba(255, 255, 255, 0.05);
      border-radius: 15px;
      padding: 25px;
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.1);
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    }
    
    .suggestion-title {
      display: flex;
      align-items: center;
      margin-bottom: 20px;
    }
    
    .suggestion-title i {
      background: var(--accent-color);
      width: 40px;
      height: 40px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 12px;
      font-size: 18px;
    }
    
    .suggestion-form textarea {
      background: rgba(255, 255, 255, 0.9);
      border: none;
      border-radius: 12px;
      padding: 15px;
      resize: none;
      min-height: 120px;
      margin-bottom: 15px;
      transition: all 0.3s ease;
    }
    
    .suggestion-form textarea:focus {
      box-shadow: 0 0 0 3px rgba(0, 201, 255, 0.3);
      outline: none;
    }
    
    .suggestion-form textarea::placeholder {
      color: #6c757d;
    }
    
    .char-count {
      text-align: right;
      font-size: 0.8rem;
      margin-bottom: 15px;
      color: rgba(255, 255, 255, 0.7);
    }
    
    .suggestion-btn {
      background: var(--accent-color);
      color: white;
      border: none;
      border-radius: 50px;
      padding: 12px 25px;
      font-weight: 600;
      width: 100%;
      transition: all 0.3s ease;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    .suggestion-btn i {
      margin-left: 8px;
    }
    
    .suggestion-btn:hover {
      background: #00b4e6;
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(0, 201, 255, 0.4);
    }
    
    .suggestion-btn:active {
      transform: translateY(0);
    }
  </style>
</head>
<body>
  <main>
    <!-- Your main content here -->
  </main>
  
  <!-- Enhanced Footer -->
  <footer class="pt-5 pb-3">
    <div class="weather-icon">
      <i class="fas fa-cloud-sun"></i>
    </div>
    <div class="container position-relative">
      <div class="row text-start">

        <!-- COMPANY -->
        <div class="col-md-3 col-sm-6 mb-4">
          <h6 class="text-uppercase fw-bold footer-title">SkyCast</h6>
          <ul class="list-unstyled footer-links">
            <li><a href="about.jsp"><i class="fas fa-info-circle me-2"></i>About Us</a></li>
            <li><a href="ourmission.jsp"><i class="fas fa-bullseye me-2"></i>Our Mission</a></li>
            <li><a href="career.jsp"><i class="fas fa-briefcase me-2"></i>Careers</a></li>
            <li><a href="#"><i class="fas fa-newspaper me-2"></i>News & Updates</a></li>
          </ul>
          <div class="social-icons mt-4">
            <a href="#"><i class="fab fa-facebook-f"></i></a>
            <a href="#"><i class="fab fa-twitter"></i></a>
            <a href="#"><i class="fab fa-instagram"></i></a>
            <a href="#"><i class="fab fa-youtube"></i></a>
          </div>
        </div>

        <!-- RESOURCES -->
        <div class="col-md-3 col-sm-6 mb-4">
          <h6 class="text-uppercase fw-bold footer-title">Resources</h6>
          <ul class="list-unstyled footer-links">
            <li><a href="chatbot.jsp"><i class="fas fa-question-circle me-2"></i>FAQ</a></li>
            <li><a href="weathertips.jsp"><i class="fas fa-globe-americas me-2"></i>Weather Tips</a></li>
            <li><a href="safety.jsp"><i class="fas fa-shield-alt me-2"></i>Safety Guides</a></li>
            <li><a href="climate.jsp"><i class="fas fa-globe-americas me-2"></i>Climate Info</a></li>
          </ul>
        </div>

        <!-- CONTACT -->
        <div class="col-md-3 col-sm-6 mb-4">
          <h6 class="text-uppercase fw-bold footer-title">Contact Us</h6>
          <ul class="list-unstyled contact-info">
            <li><i class="fas fa-envelope"></i> <a href="mailto:support@skycast.com">support@skycast.com</a></li>
            <li><i class="fas fa-phone"></i> +95 123 456 789</li>
            <li><i class="fas fa-map-marker-alt"></i> Yangon, Myanmar</li>
          </ul>
        </div>
        
        <!-- SUGGESTION BOX -->
        <div class="col-md-3 col-sm-6 mb-4">
          <div class="suggestion-box">
            <div class="suggestion-title">
              <i class="fas fa-lightbulb"></i>
              <h6 class="text-uppercase fw-bold mb-0">Your Suggestions</h6>
            </div>
            <p class="small mb-3">We value your feedback to improve our service</p>
   <form class="suggestion-form" method="post" action="submitSuggestion.jsp">
    <textarea class="form-control" name="suggestion" placeholder="What can we improve?" maxlength="250"></textarea>
    <div class="char-count"><span id="char-remaining">250</span> characters remaining</div>
    <button type="submit" class="suggestion-btn">Submit Suggestion <i class="fas fa-paper-plane"></i></button>
</form>


          </div>
        </div>
      </div>

      <hr class="my-4">
      <!-- COPYRIGHT & LEGAL -->
      <div class="text-center mt-4 copyright">
        <p class="mb-1">
          © 2025 SkyCast. All Rights Reserved.
        </p>
        <p class="mb-0">
          <a href="privacy.jsp" class="mx-2">Privacy Policy</a> |
          <a href="privacy.jsp" class="me-2">Terms of Use</a> |
        
          <a href="privacy.jsp" class="ms-2">Cookie Policy</a>
        </p>
      </div>
    </div>
  </footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    // Character counter for suggestion box
    document.addEventListener('DOMContentLoaded', function() {
      const textarea = document.querySelector('.suggestion-form textarea');
      const charCount = document.getElementById('char-remaining');
      const maxLength = 250;
      
      textarea.addEventListener('input', function() {
        const remaining = maxLength - this.value.length;
        charCount.textContent = remaining;
        
        if (remaining < 50) {
          charCount.style.color = '#ff6b6b';
        } else {
          charCount.style.color = 'rgba(255, 255, 255, 0.7)';
        }
      });
      
      // Form submission handling

    });
  </script>
</body>
</html>