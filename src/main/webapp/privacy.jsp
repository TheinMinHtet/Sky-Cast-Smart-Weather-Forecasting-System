<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Privacy Policy - SkyCast</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #0c0e2a 0%, #232750 100%);
            color: #eee;
            line-height: 1.6;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1100px;
            margin: 0 auto;
        }
        
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 0;
            margin-bottom: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 24px;
            font-weight: 700;
            color: #4da3ff;
        }
        
        .logo i {
            font-size: 28px;
        }
        
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: rgba(77, 163, 255, 0.2);
            color: #4da3ff;
            border: 1px solid rgba(77, 163, 255, 0.3);
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            font-weight: 500;
        }
        
        .back-button:hover {
            background: rgba(77, 163, 255, 0.3);
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }
        
        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
        }
        
        .tab {
            padding: 12px 25px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 8px 8px 0 0;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        
        .tab.active {
            background: rgba(77, 163, 255, 0.2);
            color: #4da3ff;
        }
        
        .tab:hover:not(.active) {
            background: rgba(255, 255, 255, 0.12);
        }
        
        .content {
            background: rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            margin-bottom: 40px;
        }
        
        h1 {
            color: #4da3ff;
            margin-bottom: 20px;
            font-size: 32px;
        }
        
        h2 {
            color: #6bb5ff;
            margin: 30px 0 15px;
            font-size: 24px;
            padding-bottom: 8px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        p {
            margin-bottom: 15px;
            font-size: 16px;
            line-height: 1.7;
        }
        
        ul {
            margin: 15px 0;
            padding-left: 20px;
        }
        
        li {
            margin-bottom: 10px;
            position: relative;
        }
        
        li:before {
            content: "•";
            color: #4da3ff;
            font-weight: bold;
            display: inline-block;
            width: 1em;
            margin-left: -1em;
        }
        
        .last-updated {
            color: #8a9baf;
            font-style: italic;
            margin-bottom: 30px;
            font-size: 14px;
        }
        
        .policy-section {
            margin-bottom: 35px;
        }
        
        footer {
            text-align: center;
            padding: 20px 0;
            color: #8a9baf;
            font-size: 14px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        footer a {
            color: #6bb5ff;
            text-decoration: none;
        }
        
        footer a:hover {
            text-decoration: underline;
        }
        
        @media (max-width: 768px) {
            .content {
                padding: 25px;
            }
            
            .tabs {
                flex-wrap: wrap;
            }
            
            .tab {
                flex: 1;
                text-align: center;
                padding: 10px;
                font-size: 14px;
            }
            
            h1 {
                font-size: 28px;
            }
            
            h2 {
                font-size: 22px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <div class="logo">
                <i class="fas fa-cloud-sun"></i>
                <span>SkyCast</span>
            </div>
            <div class="back-button" onclick="goBack()">
                <i class="fas fa-arrow-left"></i>
                Back to App
            </div>
        </header>
        
        <div class="tabs">
            <div class="tab active" onclick="showPolicy('privacy')">Privacy Policy</div>
            <div class="tab" onclick="showPolicy('terms')">Terms of Use</div>
            <div class="tab" onclick="showPolicy('cookies')">Cookie Policy</div>
        </div>
        
        <!-- Privacy Policy Content -->
        <div id="privacy-content" class="content">
            <h1>Privacy Policy</h1>
            <p class="last-updated">Last updated: June 10, 2023</p>
            
            <div class="policy-section">
                <p>At <strong>SkyCast</strong>, we value your privacy. This policy explains how we collect, use, and protect your personal information when you use our weather forecasting services.</p>
            </div>
            
            <div class="policy-section">
                <h2>Information We Collect</h2>
                <p>To provide accurate weather forecasts and improve our services, we may collect:</p>
                <ul>
                    <li><strong>Location data</strong> - for personalized weather forecasts</li>
                    <li><strong>Search history</strong> - to improve location suggestions (optional)</li>
                    <li><strong>Device information</strong> - to optimize app performance</li>
                    <li><strong>Usage analytics</strong> - to understand how our services are used</li>
                </ul>
            </div>
            
            <div class="policy-section">
                <h2>How We Use Your Data</h2>
                <p>We use the information we collect to:</p>
                <ul>
                    <li>Provide accurate and personalized weather forecasts</li>
                    <li>Improve our services and user experience</li>
                    <li>Develop new features and functionality</li>
                    <li>Ensure the security and integrity of our services</li>
                </ul>
                <p>We never sell your personal data to third parties.</p>
            </div>
            
            <div class="policy-section">
                <h2>Data Storage and Security</h2>
                <p>We implement industry-standard security measures to protect your data. Your information is stored on secure servers and is only retained for as long as necessary to provide our services.</p>
            </div>
            
            <div class="policy-section">
                <h2>Your Rights</h2>
                <p>You have the right to:</p>
                <ul>
                    <li>Access the personal information we hold about you</li>
                    <li>Request correction of inaccurate data</li>
                    <li>Request deletion of your personal data</li>
                    <li>Opt-out of data collection where possible</li>
                    <li>Withdraw consent for data processing</li>
                </ul>
                <p>To exercise any of these rights, please contact our support team.</p>
            </div>
        </div>
        
        <!-- Terms of Use Content (Hidden by default) -->
        <div id="terms-content" class="content" style="display: none;">
            <h1>Terms of Use</h1>
            <p class="last-updated">Last updated: June 10, 2023</p>
            
            <div class="policy-section">
                <p>Welcome to <strong>SkyCast</strong>. By using our weather forecasting services, you agree to the following terms and conditions.</p>
            </div>
            
            <div class="policy-section">
                <h2>Service Description</h2>
                <p>SkyCast provides weather forecasting services for informational purposes. While we strive for accuracy, we cannot guarantee that the information will always be current or precise.</p>
            </div>
            
            <div class="policy-section">
                <h2>User Responsibilities</h2>
                <p>You agree to:</p>
                <ul>
                    <li>Use our services only for lawful purposes</li>
                    <li>Not attempt to disrupt or compromise our services</li>
                    <li>Not use our services for emergency decision-making</li>
                    <li>Provide accurate information when required</li>
                </ul>
            </div>
            
            <div class="policy-section">
                <h2>Intellectual Property</h2>
                <p>All content, features, and functionality of SkyCast are owned by us and are protected by international copyright laws. You may not copy, modify, or create derivative works without our permission.</p>
            </div>
            
            <div class="policy-section">
                <h2>Limitation of Liability</h2>
                <p>SkyCast is not liable for any damages resulting from the use of or inability to use our services, including any decisions made based on the weather information provided.</p>
            </div>
        </div>
        
        <!-- Cookie Policy Content (Hidden by default) -->
        <div id="cookies-content" class="content" style="display: none;">
            <h1>Cookie Policy</h1>
            <p class="last-updated">Last updated: June 10, 2023</p>
            
            <div class="policy-section">
                <p>This Cookie Policy explains how SkyCast uses cookies and similar technologies to provide and improve our services.</p>
            </div>
            
            <div class="policy-section">
                <h2>What Are Cookies</h2>
                <p>Cookies are small text files that are placed on your device when you visit our website or use our app. They help us provide a better experience by remembering your preferences and settings.</p>
            </div>
            
            <div class="policy-section">
                <h2>How We Use Cookies</h2>
                <p>We use cookies for:</p>
                <ul>
                    <li><strong>Essential operations</strong> - Required for the app to function properly</li>
                    <li><strong>Preferences</strong> - Remembering your settings and choices</li>
                    <li><strong>Analytics</strong> - Understanding how users interact with our services</li>
                    <li><strong>Performance</strong> - Optimizing and improving our services</li>
                </ul>
            </div>
            
            <div class="policy-section">
                <h2>Managing Cookies</h2>
                <p>You can control cookies through your browser settings. However, disabling certain cookies may affect the functionality of our services.</p>
                <p>Most browsers allow you to:</p>
                <ul>
                    <li>See what cookies are stored and delete them</li>
                    <li>Block third-party cookies</li>
                    <li>Clear cookies when you close your browser</li>
                    <li>Completely block cookies from specific websites</li>
                </ul>
            </div>
            
            <div class="policy-section">
                <h2>Changes to Cookie Usage</h2>
                <p>We may update our use of cookies from time to time. We will notify users of any material changes to this policy and provide options to adjust cookie preferences.</p>
            </div>
        </div>
        
        <footer>
            <p>&copy; 2023 SkyCast Weather Services. All rights reserved.</p>
            <p>Contact us: <a href="mailto:privacy@skycast.com">privacy@skycast.com</a></p>
        </footer>
    </div>

    <script>
        function showPolicy(policy) {
            // Hide all content
            document.getElementById('privacy-content').style.display = 'none';
            document.getElementById('terms-content').style.display = 'none';
            document.getElementById('cookies-content').style.display = 'none';
            
            // Remove active class from all tabs
            const tabs = document.querySelectorAll('.tab');
            tabs.forEach(tab => tab.classList.remove('active'));
            
            // Show selected content and activate tab
            document.getElementById(policy + '-content').style.display = 'block';
            event.currentTarget.classList.add('active');
        }
        
        function goBack() {
            // Use browser's history to go back
            window.history.back();
        }
    </script>
</body>
</html>