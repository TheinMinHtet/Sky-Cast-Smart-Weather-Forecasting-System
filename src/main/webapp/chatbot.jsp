<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Weather FAQ Chatbot</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            color: #333;
        }
        .container {
            width: 90%;
            max-width: 1100px;
            margin: 40px auto;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            overflow: hidden;
        }
        .header {
            background: #2575fc;
            color: white;
            padding: 20px;
            text-align: center;
            position: relative;
        }
        .header h1 {
            margin: 0;
            font-size: 26px;
        }
        .header p {
            margin: 5px 0 0;
        }
        /* Back button styling */
        .back-btn {
            position: absolute;
            left: 20px;
            top: 20px;
            background: white;
            color: #2575fc;
            padding: 8px 16px;
            border-radius: 25px;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s;
        }
        .back-btn:hover {
            background: #e3f2fd;
        }

        .search-bar {
            padding: 15px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }
        .search-bar input {
            width: 80%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 25px;
            font-size: 16px;
        }
        .chat-container {
            display: flex;
            height: 500px;
        }
        .questions {
            width: 35%;
            border-right: 1px solid #ddd;
            overflow-y: auto;
            padding: 15px;
        }
        .questions h3 {
            margin-top: 20px;
            color: #2575fc;
        }
        .questions button {
            display: block;
            width: 100%;
            padding: 12px;
            margin: 8px 0;
            border: none;
            border-radius: 12px;
            background: #f5f5f5;
            text-align: left;
            cursor: pointer;
            font-size: 15px;
            transition: all 0.2s;
        }
        .questions button:hover {
            background: #e3f2fd;
        }
        .questions button.active {
            background: #2575fc;
            color: white;
        }
        .answers {
            width: 65%;
            padding: 20px;
            overflow-y: auto;
            font-size: 16px;
        }
        .answer-box {
            background: #f8f9fa;
            padding: 18px;
            border-radius: 12px;
            box-shadow: inset 0 2px 5px rgba(0,0,0,0.05);
            min-height: 80px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <!-- Back button (top left corner) -->
            <a href="today_weather.jsp" class="back-btn">⬅ Back</a>

            <h1>🌤 Weather FAQ </h1>
            <p>Browse through 50 common weather questions and get instant answers.</p>
        </div>
        <div class="search-bar">
            <input type="text" id="search" placeholder="Search weather questions...">
        </div>
        <div class="chat-container">
           <div class="questions" id="questionList">
    <h3>General Weather</h3>
    <button onclick="getAnswer(this)">What is weather?</button>
    <button onclick="getAnswer(this)">What is climate?</button>
    <button onclick="getAnswer(this)">What causes rain?</button>
    <button onclick="getAnswer(this)">What is humidity?</button>
    <button onclick="getAnswer(this)">What is a thunderstorm?</button>

    <h3>Natural Phenomena</h3>
    <button onclick="getAnswer(this)">What is an earthquake?</button>
    <button onclick="getAnswer(this)">What is a tsunami?</button>
    <button onclick="getAnswer(this)">What is a cyclone?</button>
    <button onclick="getAnswer(this)">What is global warming?</button>

    <h3>Measurement</h3>
    <button onclick="getAnswer(this)">What instrument measures temperature?</button>
    <button onclick="getAnswer(this)">What instrument measures rainfall?</button>
    <button onclick="getAnswer(this)">What instrument measures wind speed?</button>
</div>

            <div class="answers">
                <div class="answer-box" id="answerBox">
                    👈 Select a question to see the answer here!
                </div>
            </div>
        </div>
    </div>

    <script>
        // FAQ Answers Mapping
      const faqAnswers = {
    "What is weather?": "Weather refers to the day-to-day conditions of the atmosphere, including temperature, rainfall, wind, and humidity.",
    "What is climate?": "Climate is the average weather conditions in a region over a long period, typically 30 years or more.",
    "What causes rain?": "Rain occurs when water vapor in the air cools, condenses into water droplets, and falls due to gravity.",
    "What is humidity?": "Humidity is the amount of water vapor present in the air. High humidity makes the air feel warmer and sticky.",
    "What is a thunderstorm?": "A thunderstorm is a rain-bearing cloud that produces lightning and thunder, often with heavy rain and strong winds.",
    
    "What is an earthquake?": "An earthquake is the shaking of the Earth’s surface caused by sudden movement of tectonic plates beneath the crust.",
    "What is a tsunami?": "A tsunami is a series of large ocean waves usually caused by underwater earthquakes or volcanic eruptions.",
    "What is a cyclone?": "A cyclone is a large-scale air mass that rotates around a strong center of low atmospheric pressure, often bringing heavy rain and wind.",
    "What is global warming?": "Global warming is the long-term rise in Earth's average temperature caused mainly by human activities like burning fossil fuels.",
    
    "What instrument measures temperature?": "A thermometer is used to measure temperature.",
    "What instrument measures rainfall?": "A rain gauge is used to measure the amount of rainfall.",
    "What instrument measures wind speed?": "An anemometer is used to measure wind speed."
};

        // Display Answer
        function getAnswer(button) {
            const question = button.innerText;
            document.querySelectorAll(".questions button").forEach(btn => btn.classList.remove("active"));
            button.classList.add("active");
            document.getElementById("answerBox").innerText = faqAnswers[question] || "Sorry, I don’t have an answer for that question yet.";
        }

        // Search Function
        document.getElementById("search").addEventListener("keyup", function() {
            const filter = this.value.toLowerCase();
            const buttons = document.querySelectorAll("#questionList button");
            buttons.forEach(btn => {
                const txtValue = btn.innerText.toLowerCase();
                btn.style.display = txtValue.includes(filter) ? "" : "none";
            });
        });
    </script>
</body>
</html>
