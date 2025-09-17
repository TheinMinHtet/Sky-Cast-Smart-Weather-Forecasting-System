<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.weather.DBConnection" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String loginEmail = (String) session.getAttribute("email"); 
    if (username == null || loginEmail == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Home • Weather Donation</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/style.css">
<style>
body { font-family: Arial, sans-serif; background:#f4f6f9; margin:0; }
header { background:#0275d8; color:#fff; padding:20px; text-align:center; }
nav { background:#2c3e50; padding:10px; text-align:center; }
nav a { color:#fff; text-decoration:none; margin:0 10px; padding:8px 15px; border-radius:5px; }
nav a:hover { background:#34495e; }
.places-container { display:grid; grid-template-columns:repeat(auto-fit,minmax(300px,1fr)); gap:25px; padding:20px; }
.place-card { background:#fff; border-radius:10px; overflow:hidden; box-shadow:0 4px 15px rgba(0,0,0,0.1); padding:10px; display:flex; flex-direction:column; }
.place-card img { width:100%; height:200px; object-fit:cover; }
.place-card h3 { margin:10px 0; }
.place-card p { font-size:14px; color:#555; flex:1; margin-bottom:10px; }
.buttons-row { display:flex; gap:10px; justify-content:flex-start; margin-top:auto; }
.buttons-row button { flex:1; text-align:center; }
.btn { background:#f39c12; color:#fff; border:none; padding:10px 15px; border-radius:6px; cursor:pointer; font-size:14px; }
.btn:hover { background:#e67e22; }
/* Modal */
.modal { display:none; position:fixed; z-index:1000; inset:0; background:rgba(0,0,0,0.6); padding-top:80px; }
.modal-content { background:#fff; margin:auto; padding:20px; width:90%; max-width:420px; border-radius:12px; position:relative; text-align:center; }
.close { position:absolute; top:10px; right:14px; font-size:28px; cursor:pointer; color:#aaa; }
.close:hover { color:#000; }
.input, .button { width:90%; padding:10px; margin:6px 0; border:1px solid #ccc; border-radius:6px; font-size:14px; }
.button { background:#27ae60; color:#fff; border:none; cursor:pointer; }
.button:hover { background:#219150; }
#qrSection { display:none; margin-top:12px; }
#qrSection img { width:220px; height:220px; }
#readMoreDesc { text-align:left; line-height:1.6; white-space: pre-wrap; word-wrap: break-word; }
</style>
</head>
<body>

<header><h1>Welcome, <%= username %></h1></header>

<nav>
  <a href="today_weather.jsp">Back</a>
  <a href="logout">Logout</a>
</nav>

<div class="places-container">
<%
  try (Connection conn = DBConnection.getConnection();
       Statement stmt = conn.createStatement();
       ResultSet rs = stmt.executeQuery("SELECT * FROM places ORDER BY id DESC")) {

    while (rs.next()) {
        String desc = rs.getString("description");
        String shortDesc = desc != null && desc.length() > 140 ? desc.substring(0,140)+"..." : desc;

        // Use ShowImageServlet for persistent uploads
        String imageUrl = (rs.getString("image_url") != null && !rs.getString("image_url").isEmpty())
                          ? request.getContextPath() + "/showImage?file=" + rs.getString("image_url")
                          : request.getContextPath() + "/assets/default.jpg";

        // Safely encode description for JS
        String jsDesc = desc != null ? desc.replace("\\","\\\\").replace("'","\\'").replace("\"","\\\"").replace("\r","").replace("\n","\\n") : "";
%>
  <div class="place-card">
    <img src="<%= imageUrl %>" alt="Place">
    <h3><%= rs.getString("name") %></h3>
    <p><%= shortDesc %></p>
    <div class="buttons-row">
        <button class="btn readMoreBtn" 
                data-title="<%= rs.getString("name") %>" 
                data-desc='<%= jsDesc %>'>Read More</button>
        <button class="btn donateBtn" data-id="<%= rs.getInt("id") %>">Donate</button>
    </div>
  </div>
<%
    }
  } catch (Exception e) {
    out.println("<p style='color:red;text-align:center;'>Error: "+e.getMessage()+"</p>");
  }
%>
</div>

<!-- Read More Modal -->
<div id="readMoreModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeReadMore()">&times;</span>
    <h2 id="readMoreTitle"></h2>
    <p id="readMoreDesc"></p>
  </div>
</div>

<!-- Donation Modal -->
<div id="donationModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeDonate()">&times;</span>
    <h2>Donate to this Place</h2>
    <form id="donationForm">
      <input type="hidden" name="placeId" id="placeId">
      <input class="input" type="email" name="email" id="emailField" value="<%= loginEmail %>" readonly required>
      <input class="input" type="text" name="phone" id="phoneField" placeholder="Phone Number (09xxxxxxxxx)" required>
      <input class="input" type="number" step="0.01" name="amount" placeholder="Donation Amount $" required>
      <button class="button" type="submit">Save</button>
    </form>
    <div id="qrSection">
      <p>Donation saved. Scan the KPay QR to pay:</p>
      <img src="<%= request.getContextPath() %>/assets/kpayQR.jpg" alt="KPay QR">
      <div style="margin-top:10px;">
        <button class="btn" onclick="closeDonate()">Close</button>
      </div>
    </div>
  </div>
</div>

<script>
// Read More modal
document.querySelectorAll('.readMoreBtn').forEach(btn=>{
  btn.addEventListener('click', function(){
    document.getElementById('readMoreTitle').innerText = this.dataset.title;
    document.getElementById('readMoreDesc').innerText = this.dataset.desc;
    document.getElementById('readMoreModal').style.display='block';
  });
});
function closeReadMore(){ document.getElementById('readMoreModal').style.display='none'; }

// Donate modal
document.querySelectorAll('.donateBtn').forEach(btn=>{
  btn.addEventListener('click', function(){
    const placeId = this.dataset.id;
    document.getElementById('placeId').value = placeId;
    document.getElementById('donationForm').reset();
    document.getElementById('emailField').value = "<%= loginEmail %>";
    document.getElementById('donationForm').style.display='block';
    document.getElementById('qrSection').style.display='none';
    document.getElementById('donationModal').style.display='block';
  });
});
function closeDonate(){ document.getElementById('donationModal').style.display='none'; }

// Donation submit
document.getElementById('donationForm').addEventListener('submit', function(e){
  e.preventDefault();
  const placeId = document.getElementById('placeId').value;
  const email = document.getElementById('emailField').value.trim();
  const phone = document.getElementById('phoneField').value.trim();
  const amount = document.querySelector('input[name="amount"]').value.trim();
  if(email !== "<%= loginEmail %>"){ alert("Invalid email. Must use login email."); return; }
  if(!/^09\d{9}$/.test(phone)){ alert("Phone must start with 09 and be 11 digits."); return; }
  if(!amount || parseFloat(amount)<=0){ alert("Enter a valid donation amount."); return; }

  fetch('<%=request.getContextPath()%>/donate',{
    method:'POST',
    headers:{'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'},
    body:'placeId='+encodeURIComponent(placeId)+'&email='+encodeURIComponent(email)+'&phone='+encodeURIComponent(phone)+'&amount='+encodeURIComponent(amount)
  })
  .then(res=>res.json())
  .then(data=>{
    if(data.status==='success'){
      document.getElementById('donationForm').style.display='none';
      document.getElementById('qrSection').style.display='block';
    } else { alert(data.message || 'Donation failed'); }
  })
  .catch(err=>{ console.error(err); alert('Network error'); });
});
</script>
</body>
</html>
