<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Get conversation history from session
    List<String> conversationHistory = (List<String>) session.getAttribute("conversationHistory");
    if (conversationHistory == null) {
        conversationHistory = new ArrayList<>();
    }
    
    // Get current messages
    String userMessage = (String) request.getAttribute("userMessage");
    String botResponse = (String) request.getAttribute("botResponse");
    
    // Check if we need to add the current messages to history
    // This prevents duplicates when the page is refreshed
    if (userMessage != null && botResponse != null) {
        // Check if the last messages in history are different from current ones
        if (conversationHistory.isEmpty() || 
            !conversationHistory.get(conversationHistory.size()-2).equals(userMessage) ||
            !conversationHistory.get(conversationHistory.size()-1).equals(botResponse)) {
            
            // Add to history only if they're not already there
            conversationHistory.add(userMessage);
            conversationHistory.add(botResponse);
            session.setAttribute("conversationHistory", conversationHistory);
        }
    }
%>
<html>
<head>
    <title>Chatbot</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f0f2f5;
            color: #333;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .header {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            position: relative;
        }
        .back-button {
            position: absolute;
            left: 0;
            background: none;
            border: 2px solid #4a6fa5;
            color: #4a6fa5;
            padding: 8px 16px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 5px;
            text-decoration: none;
        }
        .back-button:hover {
            background-color: #4a6fa5;
            color: white;
            transform: translateX(-3px);
        }
        .clear-button {
            position: absolute;
            right: 0;
            background: none;
            border: 2px solid #e53935;
            color: #e53935;
            padding: 8px 16px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .clear-button:hover {
            background-color: #e53935;
            color: white;
        }
        .chat-container {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 20px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        h2 {
            color: #4a6fa5;
            text-align: center;
            margin-bottom: 25px;
            font-weight: 600;
        }
        form {
            display: flex;
            margin-top: auto;
            padding-top: 15px;
            gap: 10px;
        }
        input[type="text"] {
            flex: 1;
            padding: 12px 15px;
            border: 2px solid #ddd;
            border-radius: 25px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s;
        }
        input[type="text"]:focus {
            border-color: #4a6fa5;
        }
        button[type="submit"] {
            padding: 12px 25px;
            background-color: #4a6fa5;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        button[type="submit"]:hover {
            background-color: #3a5a80;
        }
        .message-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
            overflow-y: auto;
            max-height: 60vh;
            padding: 10px;
            margin-bottom: 20px;
        }
        .message {
            padding: 12px 18px;
            border-radius: 18px;
            max-width: 80%;
            word-wrap: break-word;
            line-height: 1.5;
        }
        .user-message {
            background-color: #4a6fa5;
            color: white;
            align-self: flex-end;
            border-bottom-right-radius: 5px;
        }
        .bot-message {
            background-color: #e6e9ef;
            color: #333;
            align-self: flex-start;
            border-bottom-left-radius: 5px;
        }
        .message strong {
            display: block;
            margin-bottom: 5px;
            font-size: 0.9em;
            opacity: 0.9;
        }
        .error {
            color: #e53935;
            padding: 12px 15px;
            background-color: #ffebee;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid #e53935;
        }
        .info {
            color: #1e88e5;
            padding: 10px 15px;
            background-color: #e3f2fd;
            border-radius: 8px;
            margin-bottom: 15px;
            font-size: 0.9em;
            text-align: center;
        }
        .timestamp {
            font-size: 0.7em;
            opacity: 0.6;
            margin-top: 5px;
            text-align: right;
        }
        .empty-chat {
            text-align: center;
            color: #888;
            padding: 40px 0;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="header">
        <a href="MainServlet?lat=16.8566575&lon=96.1374665" class="back-button">
            ← Back
        </a>
        <h2>AI Chatbot</h2>
        <a href="chat?clearHistory=true" class="clear-button">
            Clear History
        </a>
    </div>
    
    <div class="chat-container">
        <div class="info">
            Note: The AI service is currently using fallback responses. 
            Some advanced features may be limited.
        </div>
        
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="error"><%= error %></div>
        <% } %>
        
        <div class="message-container" id="messageContainer">
        <%
            // Display conversation history only (no separate display of current messages)
            if (conversationHistory.isEmpty()) {
        %>
            <div class="empty-chat">
                No conversation history yet. Start chatting below!
            </div>
        <%
            } else {
                for (int i = 0; i < conversationHistory.size(); i++) {
                    String message = conversationHistory.get(i);
                    if (i % 2 == 0) { // User messages (even indices)
        %>
            <div class="message user-message">
                <strong>You:</strong> <%= message %>
                <div class="timestamp"><%= (i == conversationHistory.size()-2) ? "Just now" : "Earlier" %></div>
            </div>
        <%
                    } else { // Bot responses (odd indices)
        %>
            <div class="message bot-message">
                <strong>Bot:</strong> <%= message %>
                <div class="timestamp"><%= (i == conversationHistory.size()-1) ? "Just now" : "Earlier" %></div>
            </div>
        <%
                    }
                }
            }
        %>
        </div>
        
        <form action="chat" method="post" id="chatForm">
            <input type="text" name="message" id="messageInput" placeholder="Type your message here..." required/>
            <button type="submit" id="sendButton">Send</button>
        </form>
    </div>

    <script>
        // Focus on input field when page loads
        window.onload = function() {
            document.getElementById('messageInput').focus();
            // Scroll to bottom of message container
            var container = document.getElementById('messageContainer');
            container.scrollTop = container.scrollHeight;
        };
        
        // Simple form submission feedback
        document.getElementById('chatForm').addEventListener('submit', function() {
            var sendButton = document.getElementById('sendButton');
            sendButton.disabled = true;
            sendButton.textContent = 'Sending...';
        });
        
        // Alternative: Go to specific page if history is empty
        function goBack() {
            if (document.referrer === "" || document.referrer.includes(window.location.hostname)) {
                window.location.href = "index.jsp"; // Change to your home page
            } else {
                window.history.back();
            }
        }
    </script>
</body>
</html>