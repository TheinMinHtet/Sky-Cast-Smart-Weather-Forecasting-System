package API;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONObject;
import org.json.JSONArray;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/chat")
public class ChatbotServlet extends HttpServlet {
    private static final String API_URL = "https://router.huggingface.co/v1/chat/completions";
    private static final String API_KEY = System.getenv("HF_TOKEN"); // your key

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userMessage = request.getParameter("message");
        String botResponse = "Sorry, I couldn't process your request at the moment.";

        // Get or initialize conversation history from session
        HttpSession session = request.getSession();
        List<String> conversationHistory = (List<String>) session.getAttribute("conversationHistory");
        if (conversationHistory == null) {
            conversationHistory = new ArrayList<>();
            session.setAttribute("conversationHistory", conversationHistory);
        }

        if (userMessage == null || userMessage.trim().isEmpty()) {
            request.setAttribute("error", "Please enter a message.");
        } else {
            try {
                // Build JSON request body for chat
                JSONObject jsonRequest = new JSONObject();
                jsonRequest.put("model", "deepseek-ai/DeepSeek-R1:sambanova");

                JSONArray messages = new JSONArray();
                
                // Add conversation history to provide context to the AI
                for (int i = 0; i < conversationHistory.size(); i++) {
                    String historyMessage = conversationHistory.get(i);
                    JSONObject msg = new JSONObject();
                    
                    if (i % 2 == 0) { // Even index: user message
                        msg.put("role", "user");
                        msg.put("content", historyMessage);
                    } else { // Odd index: bot response
                        msg.put("role", "assistant");
                        msg.put("content", historyMessage);
                    }
                    
                    messages.put(msg);
                }
                
                // Add current user message
                JSONObject userMsg = new JSONObject();
                userMsg.put("role", "user");
                userMsg.put("content", userMessage);
                messages.put(userMsg);

                jsonRequest.put("messages", messages);

                String jsonInputString = jsonRequest.toString();

                // Send request to Hugging Face API
                URL url = new URL(API_URL);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("POST");
                conn.setRequestProperty("Authorization", "Bearer " + API_KEY);
                conn.setRequestProperty("Content-Type", "application/json");
                conn.setDoOutput(true);
                conn.setConnectTimeout(60000); // 60s for slow model load
                conn.setReadTimeout(60000);

                try (OutputStream os = conn.getOutputStream()) {
                    byte[] input = jsonInputString.getBytes("utf-8");
                    os.write(input, 0, input.length);
                }

                int responseCode = conn.getResponseCode();

                if (responseCode == HttpURLConnection.HTTP_OK) {
                    BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
                    StringBuilder responseText = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        responseText.append(responseLine.trim());
                    }

                    // Parse JSON response
                    JSONObject jsonResponse = new JSONObject(responseText.toString());
                    JSONArray choices = jsonResponse.getJSONArray("choices");
                    if (choices.length() > 0) {
                        botResponse = choices.getJSONObject(0)
                                             .getJSONObject("message")
                                             .getString("content");
                    }
                } else {
                    // Error handling
                    BufferedReader errorReader = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"));
                    StringBuilder errorResponse = new StringBuilder();
                    String errorLine;
                    while ((errorLine = errorReader.readLine()) != null) {
                        errorResponse.append(errorLine.trim());
                    }

                    System.err.println("API Error: " + errorResponse.toString());

                    if (responseCode == 503) {
                        botResponse = "The chatbot service is loading. Please try again in a moment.";
                    } else {
                        botResponse = "Sorry, I'm experiencing technical difficulties (Error: " + responseCode + ").";
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Unexpected error: " + e.getMessage());
            }
        }

        // Add current conversation to history
        conversationHistory.add(userMessage);
        conversationHistory.add(botResponse);

        // Send response back to JSP
        request.setAttribute("botResponse", botResponse);
        request.setAttribute("userMessage", userMessage);
        request.setAttribute("conversationHistory", conversationHistory);

        RequestDispatcher dispatcher = request.getRequestDispatcher("chat.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle clear history request
        if ("true".equals(request.getParameter("clearHistory"))) {
            HttpSession session = request.getSession();
            session.removeAttribute("conversationHistory");
            response.sendRedirect("chat.jsp");
            return;
        }
        
        // For GET requests, just display the chat page
        RequestDispatcher dispatcher = request.getRequestDispatcher("chat.jsp");
        dispatcher.forward(request, response);
    }
}