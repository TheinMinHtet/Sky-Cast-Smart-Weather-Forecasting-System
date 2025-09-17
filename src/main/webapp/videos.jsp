<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trending Weather Videos</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            color: #f1f1f1;
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
            font-size: 14px;
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

        .video-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr); /* Exactly 3 videos per row */
            gap: 20px;
            padding: 20px;
        }

        .video-card {
            background: #1e1e1e;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.4);
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .video-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.6);
        }
        .thumbnail {
            width: 100%;
            height: 180px;
            background-size: cover;
            background-position: center;
        }
        .video-info {
            padding: 12px;
        }
        .video-title {
            font-size: 1rem;
            font-weight: bold;
            margin: 0 0 6px 0;
            color: #fff;
        }
        .video-meta {
            font-size: 0.85rem;
            color: #bbb;
        }

        /* Responsive fallback */
        @media (max-width: 768px) {
            .video-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 480px) {
            .video-grid {
                grid-template-columns: 1fr;
            }
        }
        
        /* Modal Styling */
.modal {
    display: none; 
    position: fixed;
    z-index: 1000; 
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto; 
    background-color: rgba(0,0,0,0.8);
}

.modal-content {
    position: relative;
    margin: 5% auto;
    width: 80%;
    max-width: 800px;
    background: #111;
    border-radius: 12px;
    padding: 0;
    box-shadow: 0 8px 20px rgba(0,0,0,0.5);
}

.close {
    color: #fff;
    position: absolute;
    top: 5px;
    right: 10px;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
}
.close:hover {
    color: #f00;
}
        
    </style>
</head>
<body>
<div class="container">
        <!-- Header with Back Button -->
        <div class="header">
            <a href="today_weather.jsp" class="back-btn">⬅ Back</a>
            <h1>🌦 Trending Weather Videos</h1>
            <p>Watch the latest weather news and severe weather coverage from trusted channels.</p>
        </div>

        <!-- Video Grid -->
        <div class="video-grid" id="videoGrid">
            <!-- Videos will be inserted here via JavaScript -->
        </div>
    </div>
    
    <!-- Video Modal -->
<div id="videoModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <iframe id="modalVideo" width="100%" height="480" frameborder="0" allowfullscreen></iframe>
    </div>
</div>
    
    

<script>
    const API_KEY = "AIzaSyABhtGD-UozV9Ub_MwS_wcEppc669KpQJI"; // replace with your API key
    const SEARCH_QUERY = "severe weather news channel";
    const MAX_RESULTS = 12;

    async function fetchVideos() {
        // Step 1: Search videos
        const searchRes = await fetch(
            `https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=\${MAX_RESULTS}&q=\${encodeURIComponent(SEARCH_QUERY)}&key=\${API_KEY}`
        );
        const searchData = await searchRes.json();

        const videoIds = searchData.items.map(item => item.id.videoId).join(",");
        if (!videoIds) {
            document.getElementById("videoGrid").innerHTML = "<p>No videos found.</p>";
            return;
        }

        // Step 2: Get video details
        const videosRes = await fetch(
            `https://www.googleapis.com/youtube/v3/videos?part=snippet,contentDetails&id=\${videoIds}&key=\${API_KEY}`
        );
        const videosData = await videosRes.json();
        renderVideos(videosData.items);
    }

    function renderVideos(videos) {
        const grid = document.getElementById("videoGrid");
        grid.innerHTML = "";
        videos.forEach(v => {
            const vidId = v.id;
            const title = v.snippet.title;
            const channel = v.snippet.channelTitle;
            const thumb = v.snippet.thumbnails.high.url;

            const card = document.createElement("div");
            card.className = "video-card";
            card.innerHTML = `
                <div class="thumbnail" style="background-image:url('\${thumb}')"></div>
                <div class="video-info">
                    <div class="video-title">\${title}</div>
                    <div class="video-meta">\${channel}</div>
                </div>
            `;
            card.addEventListener("click", () => {
    const modal = document.getElementById("videoModal");
    const iframe = document.getElementById("modalVideo");
    iframe.src = "https://www.youtube.com/embed/" + vidId + "?autoplay=1";
    modal.style.display = "block";
});
         // Close modal when clicking on ×
            document.querySelector(".close").onclick = function() {
                const modal = document.getElementById("videoModal");
                const iframe = document.getElementById("modalVideo");
                iframe.src = ""; // Stop the video
                modal.style.display = "none";
            }

            // Close modal when clicking outside the modal content
            window.onclick = function(event) {
                const modal = document.getElementById("videoModal");
                const iframe = document.getElementById("modalVideo");
                if (event.target === modal) {
                    iframe.src = ""; // Stop the video
                    modal.style.display = "none";
                }
            }

            grid.appendChild(card);
        });
    }

    fetchVideos();
</script>
</body>
</html>