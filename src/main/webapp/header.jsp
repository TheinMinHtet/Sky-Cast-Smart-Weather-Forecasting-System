<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@ page import="java.sql.*" %> 
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
   
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>SkyCast</title>
  <meta name="theme-color" content="#1a6fc4"> <!-- Added -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <link rel="stylesheet" href="./css/header.css">
 <style>
    .autocomplete-suggestions {
      border: 1px solid #e1e8ed;
      border-radius: 8px;
      background-color: #fff;
      max-height: 300px;
      overflow-y: auto;
      position: absolute;
      width: calc(100% - 120px);
      z-index: 1000;
      box-shadow: 0 5px 15px rgba(0,0,0,0.08);
      left: 0;
      margin-top: 4px;
      padding: 8px 0;
    }
    .autocomplete-suggestion {
      padding: 12px 16px;
      cursor: pointer;
      border-bottom: 1px solid #f5f8fa;
      font-size: 0.95rem;
      color: #1c1e21;
      transition: all 0.2s ease;
      display: flex;
      align-items: center;
    }
    .autocomplete-suggestion:hover {
      background-color: #f0f7ff;
      transform: translateX(2px);
    }
    .autocomplete-suggestion:last-child {
      border-bottom: none;
    }
    .autocomplete-suggestion.selected {
      background-color: #e3f2fd;
      color: #1a6fc4;
      font-weight: 500;
    }
    .autocomplete-suggestion:before {
      content: "\f3c5";
      font-family: "Font Awesome 6 Free";
      font-weight: 900;
      margin-right: 10px;
      color: #1a6fc4;
      font-size: 14px;
    }
    .search-container {
      position: relative;
    }
    .navbar-brand {
      font-weight: bold;
      font-size: 1.5rem;
    }
    .bg-custom-header {
      background: linear-gradient(135deg, #1a6fc4 0%, #00ffff 100%);
    }
    
    /* Scrollbar styling for autocomplete */
    .autocomplete-suggestions::-webkit-scrollbar {
      width: 8px;
    }
    .autocomplete-suggestions::-webkit-scrollbar-track {
      background: #f1f1f1;
      border-radius: 4px;
    }
    .autocomplete-suggestions::-webkit-scrollbar-thumb {
      background: #c1c1c1;
      border-radius: 4px;
    }
    .autocomplete-suggestions::-webkit-scrollbar-thumb:hover {
      background: #a8a8a8;
    }
</style>
</head>
<body>
  <!-- Header -->
<div class="navbar navbar-expand-xl bg-black sticky-top shadow">
      <a class="navbar-brand text-white ms-3" href="index.jsp"><i class="fa-solid fa-cloud me-2"></i>SkyCast</a>
      <a class="navbar-brand d-flex align-items-center" href="index.jsp">
       
      </a>
</div>
<nav class="navbar navbar-expand-xl bg-custom-header sticky-top shadow">
    <div class="container">
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
          aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-3 me-auto">
    <li class="nav-item px-3">
        <c:choose>
            <c:when test="${not empty lat and not empty lon}">
                <a class="nav-link ${empty param.page || param.page == 'today' ? 'active' : ''}" 
                   aria-current="page" 
                   href="MainServlet?page=today&lat=${lat}&lon=${lon}">Today</a>
            </c:when>
            <c:otherwise>
                <a class="nav-link ${empty param.page || param.page == 'today' ? 'active' : ''}" 
                   aria-current="page" 
                   href="MainServlet?page=today&location=${param.location}">Today</a>
            </c:otherwise>
        </c:choose>
    </li>

    <li class="nav-item px-3">
        <c:choose>
            <c:when test="${not empty lat and not empty lon}">
                <a class="nav-link ${param.page == 'hourly' ? 'active' : ''}" 
                   href="MainServlet?page=hourly&lat=${lat}&lon=${lon}">Hourly</a>
            </c:when>
            <c:otherwise>
                <a class="nav-link ${param.page == 'hourly' ? 'active' : ''}" 
                   href="MainServlet?page=hourly&location=${param.location}">Hourly</a>
            </c:otherwise>
        </c:choose>
    </li>

    <li class="nav-item px-3">
        <c:choose>
            <c:when test="${not empty lat and not empty lon}">
                <a class="nav-link ${param.page == 'daily' ? 'active' : ''}" 
                   href="MainServlet?page=daily&lat=${lat}&lon=${lon}">Daily</a>
            </c:when>
            <c:otherwise>
                <a class="nav-link ${param.page == 'daily' ? 'active' : ''}" 
                   href="MainServlet?page=daily&location=${param.location}">Daily</a>
            </c:otherwise>
        </c:choose>
    </li>

    <li class="nav-item px-3">
    <c:choose>
        <c:when test="${not empty lat and not empty lon}">
            <a class="nav-link ${param.page == 'airquality' ? 'active' : ''}" 
               href="MainServlet?page=airquality&lat=${lat}&lon=${lon}" 
               style="white-space: nowrap;">Air Quality</a>
        </c:when>
        <c:otherwise>
            <a class="nav-link ${param.page == 'airquality' ? 'active' : ''}" 
               href="MainServlet?page=airquality&location=${param.location}" 
               style="white-space: nowrap;">Air Quality</a>
        </c:otherwise>
    </c:choose>
</li>


    <li class="nav-item px-3">
        <c:choose>
            <c:when test="${not empty lat and not empty lon}">
                <a class="nav-link ${param.page == 'radar' ? 'active' : ''}" 
                   href="MainServlet?page=radar&lat=${lat}&lon=${lon}">Radar</a>
            </c:when>
            <c:otherwise>
                <a class="nav-link ${param.page == 'radar' ? 'active' : ''}" 
                   href="MainServlet?page=radar&location=${param.location}">Radar</a>
            </c:otherwise>
        </c:choose>
    </li>

    <li class="nav-item px-3 mb-sm-2">
    <c:choose>
        <c:when test="${not empty lat and not empty lon}">
            <a class="nav-link ${param.page == 'health' ? 'active' : ''}" 
               href="MainServlet?page=health&lat=${lat}&lon=${lon}" 
               style="white-space: nowrap;">Health & Activities</a>
        </c:when>
        <c:otherwise>
            <a class="nav-link ${param.page == 'health' ? 'active' : ''}" 
               href="MainServlet?page=health&location=${param.location}" 
               style="white-space: nowrap;">Health & Activities</a>
        </c:otherwise>
    </c:choose>
</li>

</ul>

        <div class="search-container" style="position: relative;">
          <form class="d-inline-flex" role="search" method="GET" action="MainServlet" id="searchForm">
            <input class="form-control border-black me-1 w-75 ms-sm-4" name="location" id="locationInput" type="text" placeholder="Enter city name" aria-label="Search" autocomplete="off">
            <input class="btn btn-outline-dark" type="submit" value="Search">
          </form>
          <div id="autocompleteResults" class="autocomplete-suggestions" style="display: none;"></div>
        </div>
         <%-- Check if user is logged in --%>

      
<a href="userHome.jsp" class="text-decoration-none ms-1">
  <button class="btn btn-outline-dark mt-xl-1 mb-sm-1">Donate</button>
</a>

<a href="chat.jsp" class="text-decoration-none ms-1">
  <button class="btn btn-outline-dark mt-xl-1 mb-sm-1" style="white-space: nowrap;">🤖Chat</button>
</a>


<a href="videos.jsp" class="text-decoration-none ms-1 me-1">
  <button class="btn btn-outline-dark mt-xl-1 mb-sm-1">
    <i class="fa-solid fa-video"></i>
  </button>
</a>

        <%
            String username = (String) session.getAttribute("username"); // or "user" depending on your login logic
            if (username == null) {
        %>
            <!-- Show Login if not logged in -->
           <a href="login.jsp" class="text-decoration-none">
  <button class="btn btn-outline-dark mt-xl-1 mb-sm-1">Login</button>
</a>
        <%
            } else {
        %>
            <!-- Show Logout if logged in -->
          
     <a href="logout" class="text-decoration-none">
  <button class="btn btn-outline-dark mt-xl-1 mb-sm-1">Logout</button>
</a>
        <%
            }
        %>
      </div>
    </div>
  </nav>
   <!--Header-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // List of major cities worldwide
      const cities = [
    	  "Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", 
          "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", 
          "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bhutan", 
          "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria", 
          "Burkina Faso", "Burundi", "Cabo Verde", "Cambodia", "Cameroon", "Canada", 
          "Central African Republic", "Chad", "Chile", "China", "Colombia", "Comoros", 
          "Congo", "Costa Rica", "Côte d'Ivoire", "Croatia", "Cuba", "Cyprus", "Czech Republic", 
          "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", 
          "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Eswatini", "Ethiopia", 
          "Fiji", "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", 
          "Greece", "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", 
          "Honduras", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", 
          "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", 
          "Korea, North", "Korea, South", "Kosovo", "Kuwait", "Kyrgyzstan", "Laos", "Lebanon", 
          "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", 
          "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", 
          "Mauritania", "Mauritius", "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia", 
          "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", 
          "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Macedonia", 
          "Norway", "Oman", "Pakistan", "Palau", "Palestine", "Panama", "Papua New Guinea", 
          "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania", 
          "Russia", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", 
          "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", 
          "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", 
          "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Sudan", 
          "Spain", "Sri Lanka", "Sudan", "Suriname", "Sweden", "Switzerland", "Syria", 
          "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", "Togo", "Tonga", 
          "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", 
          "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "Uruguay", 
          "Uzbekistan", "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "Yemen", "Zambia", 
          "Zimbabwe",
          "Kabul","Kandahar","Herat","Mazar-i-Sharif","Jalalabad",
          "Tirana","Durrës","Vlorë","Elbasan","Shkodër",
          "Algiers","Oran","Constantine","Annaba","Blida",
          "Andorra la Vella","Escaldes-Engordany","Encamp","Sant Julià de Lòria",
          "Luanda","Huambo","Lobito","Benguela","Kuito",
          "Saint John's","All Saints","Liberta","Potter's Village","Bolans",
          "Buenos Aires","Córdoba","Rosario","Mendoza","La Plata",
          "Yerevan","Gyumri","Vanadzor","Vagharshapat","Abovyan",
          "Sydney","Melbourne","Brisbane","Perth","Adelaide","Canberra",
          "Vienna","Graz","Linz","Salzburg","Innsbruck",
          "Baku","Ganja","Sumqayıt","Mingachevir","Lankaran",
          "Nassau","Freeport","West End","Coopers Town","Marsh Harbour",
          "Manama","Riffa","Muharraq","Hamad Town","A'ali",
          "Dhaka","Chittagong","Khulna","Rajshahi","Sylhet",
          "Bridgetown","Speightstown","Oistins","Bathsheba","Holetown",
          "Minsk","Gomel","Mogilev","Vitebsk","Grodno",
          "Brussels","Antwerp","Ghent","Charleroi","Liège",
          "Belize City","San Ignacio","Orange Walk","Belmopan","Dangriga",
          "Cotonou","Porto-Novo","Parakou","Djougou","Bohicon",
          "Thimphu","Phuntsholing","Punakha","Samdrup Jongkhar","Geylegphug",
          "La Paz","Santa Cruz","Cochabamba","Sucre","Oruro",
          "Sarajevo","Banja Luka","Tuzla","Zenica","Mostar",
          "Gaborone","Francistown","Molepolole","Selibe Phikwe","Maun",
          "São Paulo","Rio de Janeiro","Brasília","Salvador","Fortaleza",
          "Bandar Seri Begawan","Kuala Belait","Seria","Tutong","Bangar",
          "Sofia","Plovdiv","Varna","Burgas","Ruse",
          "Ouagadougou","Bobo-Dioulasso","Koudougou","Ouahigouya","Banfora",
          "Bujumbura","Gitega","Muyinga","Ngozi","Ruyigi",
          "Praia","Mindelo","Santa Maria","Cova Figueira","Pedra Badejo",
          "Phnom Penh","Siem Reap","Battambang","Sihanoukville","Poipet",
          "Douala","Yaoundé","Bamenda","Bafoussam","Garoua",
          "Toronto","Montreal","Vancouver","Calgary","Edmonton","Ottawa",
          "Bangui","Bimbo","Berbérati","Carnot","Bambari",
          "N'Djamena","Moundou","Sarh","Abeche","Kelo",
          "Santiago","Valparaíso","Concepción","Antofagasta","Temuco",
          "Beijing","Shanghai","Guangzhou","Shenzhen","Chengdu","Hong Kong",
          "Bogotá","Medellín","Cali","Barranquilla","Cartagena",
          "Moroni","Mutsamudu","Fomboni","Domoni","Tsimbeo",
          "Brazzaville","Pointe-Noire","Dolisie","Nkayi","Owando",
          "San José","Limón","Alajuela","Heredia","Liberia",
          "Abidjan","Bouaké","Daloa","Korhogo","San-Pédro",
          "Zagreb","Split","Rijeka","Osijek","Zadar",
          "Havana","Santiago de Cuba","Camagüey","Holguín","Santa Clara",
          "Nicosia","Limassol","Larnaca","Famagusta","Paphos",
          "Prague","Brno","Ostrava","Plzeň","Liberec",
          "Copenhagen","Aarhus","Odense","Aalborg","Esbjerg",
          "Djibouti City","Ali Sabieh","Tadjoura","Obock","Dikhil",
          "Roseau","Portsmouth","Marigot","Berekua","Mahaut",
          "Santo Domingo","Santiago","La Romana","San Pedro de Macorís","San Francisco de Macorís",
          "Quito","Guayaquil","Cuenca","Santo Domingo","Machala",
          "Cairo","Alexandria","Giza","Shubra El Kheima","Port Said",
          "San Salvador","Santa Ana","San Miguel","Mejicanos","Soyapango",
          "Malabo","Bata","Ebebiyín","Aconibe","Añisoc",
          "Asmara","Keren","Massawa","Assab","Mendefera",
          "Tallinn","Tartu","Narva","Pärnu","Kohtla-Järve",
          "Mbabane","Manzini","Big Bend","Malkerns","Nhlangano",
          "Addis Ababa","Dire Dawa","Mekele","Gondar","Awassa",
          "Suva","Lautoka","Nadi","Labasa","Ba",
          "Helsinki","Espoo","Tampere","Vantaa","Oulu",
          "Paris","Marseille","Lyon","Toulouse","Nice",
          "Libreville","Port-Gentil","Franceville","Oyem","Moanda",
          "Banjul","Serekunda","Brikama","Bakau","Farafenni",
          "Tbilisi","Batumi","Kutaisi","Rustavi","Gori",
          "Berlin","Hamburg","Munich","Cologne","Frankfurt",
          "Accra","Kumasi","Tamale","Sekondi-Takoradi","Sunyani",
          "Athens","Thessaloniki","Patras","Heraklion","Larissa",
          "St. George's","Gouyave","Grenville","Victoria","Sauteurs",
          "Guatemala City","Mixco","Villa Nueva","Quetzaltenango","Escuintla",
          "Conakry","Nzérékoré","Kankan","Manéah","Dubréka",
          "Bissau","Bafatá","Gabú","Bissorã","Bolama",
          "Georgetown","Linden","New Amsterdam","Anna Regina","Bartica",
          "Port-au-Prince","Carrefour","Delmas","Pétion-Ville","Port-de-Paix",
          "Tegucigalpa","San Pedro Sula","Choloma","La Ceiba","El Progreso",
          "Budapest","Debrecen","Szeged","Miskolc","Pécs",
          "Reykjavik","Kópavogur","Hafnarfjörður","Akureyri","Garðabær",
          "Mumbai","Delhi","Bangalore","Hyderabad","Chennai","Kolkata",
          "Jakarta","Surabaya","Bandung","Medan","Semarang",
          "Tehran","Mashhad","Isfahan","Karaj","Tabriz",
          "Baghdad","Basra","Mosul","Erbil","Najaf",
          "Dublin","Cork","Limerick","Galway","Waterford",
          "Jerusalem","Tel Aviv","Haifa","Rishon LeZion","Petah Tikva",
          "Rome","Milan","Naples","Turin","Palermo",
          "Kingston","Montego Bay","Spanish Town","Portmore","Mandeville",
          "Tokyo","Yokohama","Osaka","Nagoya","Sapporo",
          "Amman","Zarqa","Irbid","Russeifa","Al Quwaysimah",
          "Almaty","Nur-Sultan","Shymkent","Karaganda","Aktobe",
          "Nairobi","Mombasa","Kisumu","Nakuru","Eldoret",
          "Tarawa","Betio","Bairiki","Banaba","Taburao",
          "Pyongyang","Hamhung","Chongjin","Nampo","Wonsan",
          "Seoul","Busan","Incheon","Daegu","Daejeon",
          "Pristina","Prizren","Mitrovica","Peja","Gjakova",
          "Kuwait City","Al Ahmadi","Hawalli","As Salimiyah","Sabah as Salim",
          "Bishkek","Osh","Jalal-Abad","Karakol","Tokmok",
          "Vientiane","Pakse","Savannakhet","Luang Prabang","Xam Neua",
          "Beirut","Tripoli","Sidon","Tyre","Nabatieh",
          "Maseru","Mafeteng","Leribe","Maputsoa","Mohale's Hoek",
          "Monrovia","Gbarnga","Kakata","Bensonville","Harper",
          "Tripoli","Benghazi","Misrata","Tarhuna","Al Khums",
          "Vaduz","Schaan","Triesen","Balzers","Eschen",
          "Vilnius","Kaunas","Klaipėda","Šiauliai","Panevėžys",
          "Luxembourg City","Esch-sur-Alzette","Differdange","Dudelange","Ettelbruck",
          "Antananarivo","Toamasina","Antsirabe","Fianarantsoa","Mahajanga",
          "Lilongwe","Blantyre","Mzuzu","Zomba","Kasungu",
          "Kuala Lumpur","George Town","Ipoh","Shah Alam","Petaling Jaya",
          "Malé","Addu City","Fuvahmulah","Kulhudhuffushi","Thinadhoo",
          "Bamako","Sikasso","Mopti","Koutiala","Ségou",
          "Valletta","Birkirkara","Mosta","Qormi","Żabbar",
          "Majuro","Ebeye","Arno","Jaluit","Wotje",
          "Nouakchott","Nouadhibou","Kaédi","Rosso","Zouérat",
          "Port Louis","Beau Bassin-Rose Hill","Vacoas-Phoenix","Curepipe","Quatre Bornes",
          "Mexico City","Guadalajara","Monterrey","Puebla","Tijuana",
          "Palikir","Weno","Colonia","Tofol","Kolonia",
          "Chișinău","Tiraspol","Bălți","Bender","Rîbnița",
          "Monaco","Monte Carlo","La Condamine","Fontvieille","Moneghetti",
          "Ulaanbaatar","Erdenet","Darkhan","Choibalsan","Khovd",
          "Podgorica","Nikšić","Herceg Novi","Bar","Budva",
          "Casablanca","Rabat","Fes","Marrakesh","Tangier",
          "Maputo","Matola","Beira","Nampula","Chimoio",
          "Yangon", "Mandalay", "Naypyidaw", "Bago", "Mawlamyine", 
          "Taunggyi", "Monywa", "Myitkyina", "Pathein", "Pyay", 
          "Pakokku", "Hinthada", "Meiktila", "Dawei", "Myeik", 
          "Sittwe", "Kalay", "Mogok", "Shwebo", "Thanlyin",
          "Pyinmana", "Letpadan", "Thanatpin", "Tharyarwady", "Nyaunglebin",
          "Yenangyaung", "Taungoo", "Thayetmyo", "Pyinoolwin", "Kyaukse",
          "Magway", "Myingyan", "Chauk", "Aunglan", "Bogale",
          "Kanbe", "Dala", "Hlegu", "Kayan", "Twante",
          "Kyaiklat", "Maubin", "Wakema", "Kyaikto", "Thanbyuzayat",
          "Kyaikkami", "Mudon", "Thaton", "Paung", "Bilin",
          "Kyaikmaraw", "Chaungzon", "Mawlamyinegyun", "Labutta", "Pyapon",
          "Kyaunggon", "Dedaye", "Ingapu", "Kyangin", "Thabaung",
          "Lemyethna", "Einme", "Myaungmya", "Pantanaw", "Danubyu",
          "Zalun", "Nyaungdon", "Ma-ubin", "Waw", "Kyaikpawlaw",
          "Kyaikmayaw", "Kyaikhat", "Kyaiktan", "Kawkareik", "Myawaddy",
          "Hpa-an", "Hlaingbwe", "Hpapun", "Thandaung", "Bawlakhe",
          "Loikaw", "Demoso", "Hpruso", "Shadaw", "Bawgali",
          "Pinlaung", "Pekon", "Mobye", "Kunhing", "Laihka",
          "Langhko", "Mongnai", "Mongpan", "Mongton", "Monghpyak",
          "Mongkung", "Monghsat", "Mongping", "Mongyawng", "Mongla",
          "Tachileik", "Kengtung", "Mongyai", "Monghsu", "Mongkaing",
          "Lashio", "Hseni", "Tangyan", "Kutkai", "Muse",
          "Namkham", "Mongmit", "Mabein", "Pangsang", "Namtu",
          "Laukkai", "Konkyan", "Kunlong", "Hopang", "Panwai",
          "Matman", "Mongmao", "Pangwaun", "Narphan", "Pansaung",
          "Panghsang", "Monglin", "Mongyang", "Mongkhet", "Mongla",
          "Mongping", "Mongtong", "Mongnawng", "Monghpyak", "Mongyawng",
          "Tanan", "Thibaw", "Kyaukme", "Nawnghkio", "Hsipaw",
          "Namhsan", "Manton", "Monglong", "Mongnai", "Mongpan",
          "Mongton", "Monghpyak", "Mongkung", "Monghsat", "Mongping",
          "Mongyawng", "Mongla", "Tachileik", "Kengtung", "Mongyai",
          "Monghsu", "Mongkaing", "Lashio", "Hseni", "Tangyan",
          "Kutkai", "Muse", "Namkham", "Mongmit", "Mabein",
          "Pangsang", "Namtu", "Laukkai", "Konkyan", "Kunlong",
          "Hopang", "Panwai", "Matman", "Mongmao", "Pangwaun",
          "Narphan", "Pansaung", "Panghsang", "Monglin", "Mongyang",
          "Mongkhet", "Mongla", "Mongping", "Mongtong", "Mongnawng",
          "Monghpyak", "Mongyawng", "Tanan", "Thibaw", "Kyaukme",
          "Nawnghkio", "Hsipaw", "Namhsan", "Manton", "Monglong",
          "Windhoek", "Rundu", "Walvis Bay", "Swakopmund", "Oshakati",
          "Yaren", "Denigomodu", "Meneng", "Aiwo", "Boe",
          "Kathmandu", "Pokhara", "Lalitpur", "Bharatpur", "Biratnagar",
          "Amsterdam", "Rotterdam", "The Hague", "Utrecht", "Eindhoven",
          "Auckland", "Wellington", "Christchurch", "Hamilton", "Tauranga",
          "Managua", "León", "Masaya", "Tipitapa", "Chinandega",
          "Niamey", "Zinder", "Maradi", "Agadez", "Tahoua",
          "Lagos", "Kano", "Ibadan", "Abuja", "Port Harcourt",
          "Skopje", "Bitola", "Kumanovo", "Prilep", "Tetovo",
          "Oslo", "Bergen", "Stavanger", "Trondheim", "Drammen",
          "Muscat", "Seeb", "Salalah", "Bawshar", "Sohar",
          "Karachi", "Lahore", "Faisalabad", "Rawalpindi", "Multan",
          "Ngerulmud", "Koror", "Melekeok", "Airai", "Kloulklubed",
          "Gaza", "East Jerusalem", "Hebron", "Nablus", "Jenin",
          "Panama City", "San Miguelito", "Tocumen", "David", "Arraiján",
          "Port Moresby", "Lae", "Arawa", "Mount Hagen", "Popondetta",
          "Asunción", "Ciudad del Este", "San Lorenzo", "Luque", "Capiatá",
          "Lima", "Arequipa", "Trujillo", "Chiclayo", "Piura",
          "Manila", "Quezon City", "Davao City", "Cebu City", "Zamboanga City",
          "Warsaw", "Kraków", "Łódź", "Wrocław Wroclaw", "Poznań",
          "Lisbon", "Porto", "Vila Nova de Gaia", "Amadora", "Braga",
          "Doha", "Al Rayyan", "Umm Salal", "Al Wakrah", "Al Khor",
          "Bucharest", "Cluj-Napoca", "Timișoara", "Iași", "Constanța",
          "Moscow", "Saint Petersburg", "Novosibirsk", "Yekaterinburg", "Nizhny Novgorod",
          "Kigali", "Butare", "Gitarama", "Musanze", "Gisenyi",
          "Basseterre", "Charlestown", "Sadlers", "Cayon", "Market Shop",
          "Castries", "Gros Islet", "Vieux Fort", "Micoud", "Soufrière",
          "Kingstown", "Georgetown", "Byera", "Barrouallie", "Layou",
          "Apia", "Vaitele", "Faleula", "Siusega", "Malie",
          "San Marino", "Serravalle", "Borgo Maggiore", "Domagnano", "Fiorentino",
          "São Tomé", "Santo Amaro", "Neves", "Santana", "Trindade",
          "Riyadh", "Jeddah", "Mecca", "Medina", "Dammam",
          "Dakar", "Pikine", "Touba", "Thiès", "Kaolack",
          "Belgrade", "Novi Sad", "Niš", "Kragujevac", "Subotica",
          "Victoria", "Anse Boileau", "Beau Vallon", "Cascade", "Takamaka",
          "Freetown", "Bo", "Kenema", "Makeni", "Koidu",
          "Singapore", "Woodlands", "Sengkang", "Hougang", "Tampines",
          "Bratislava", "Košice", "Prešov", "Žilina", "Banská Bystrica",
          "Ljubljana", "Maribor", "Celje", "Kranj", "Velenje",
          "Honiara", "Auki", "Gizo", "Kirakira", "Tulagi",
          "Mogadishu", "Hargeisa", "Bosaso", "Kismayo", "Marka",
          "Johannesburg", "Cape Town", "Durban", "Pretoria", "Port Elizabeth",
          "Juba", "Malakal", "Wau", "Yambio", "Aweil",
          "Madrid", "Barcelona", "Valencia", "Seville", "Zaragoza",
          "Colombo", "Dehiwala-Mount Lavinia", "Moratuwa", "Jaffna", "Negombo",
          "Khartoum", "Omdurman", "Port Sudan", "Kassala", "El Obeid",
          "Paramaribo", "Lelydorp", "Nieuw Nickerie", "Moengo", "Meerzorg",
          "Stockholm", "Gothenburg", "Malmö", "Uppsala", "Västerås",
          "Zurich", "Geneva", "Basel", "Lausanne", "Bern",
          "Damascus", "Aleppo", "Homs", "Hama", "Latakia",
          "Taipei", "New Taipei", "Kaohsiung", "Taichung", "Tainan",
          "Dushanbe", "Khujand", "Kulob", "Qurghonteppa", "Istaravshan",
          "Dar es Salaam", "Mwanza", "Arusha", "Dodoma", "Mbeya",
          "Bangkok", "Nonthaburi", "Nakhon Ratchasima", "Chiang Mai", "Hat Yai",
          "Dili", "Baucau", "Maliana", "Suai", "Liquiçá",
          "Lomé", "Sokodé", "Kara", "Kpalimé", "Atakpamé",
          "Nuku'alofa", "Neiafu", "Haveluloto", "Vaini", "Pangai",
          "Port of Spain", "San Fernando", "Chaguanas", "Arima", "Marabella",
          "Tunis", "Sfax", "Sousse", "Kairouan", "Bizerte",
          "Istanbul", "Ankara", "İzmir", "Bursa", "Adana",
          "Ashgabat", "Türkmenabat", "Daşoguz", "Mary", "Balkanabat",
          "Funafuti", "Asau", "Tanrake", "Tonga", "Kulia",
          "Kampala", "Gulu", "Lira", "Mbarara", "Jinja",
          "Kyiv", "Kharkiv", "Odesa", "Dnipro", "Donetsk",
          "Dubai", "Abu Dhabi", "Sharjah", "Al Ain", "Ajman",
          "London", "Birmingham", "Manchester", "Glasgow", "Liverpool",
          "New York", "Los Angeles", "Chicago", "Houston", "Phoenix",
          "Montevideo", "Salto", "Ciudad de la Costa", "Paysandú", "Las Piedras",
          "Tashkent", "Namangan", "Samarkand", "Andijan", "Bukhara",
          "Port Vila", "Luganville", "Norsup", "Sola", "Lakatoro",
          "Vatican City",
          "Caracas", "Maracaibo", "Valencia", "Barquisimeto", "Maracay",
          "Ho Chi Minh City", "Hanoi", "Da Nang", "Haiphong", "Biên Hòa",
          "Sana'a", "Aden", "Taiz", "Al Hudaydah", "Ibb",
          "Lusaka", "Kitwe", "Ndola", "Kabwe", "Chingola",
          "Harare", "Bulawayo", "Chitungwiza", "Mutare", "Gweru",
          "Ahlon",
          "Bahan",
          "Botataung",
          "Dagon",
          "Dagon Myothit North",
          "Dagon Myothit South",
          "Dagon Seikkan",
          "Dawbon",
          "Hlaing",
          "Hlaing Tharyar",
          "Kamayut",
          "Kyeemyindaing",
          "Kyauktada",
          "Kyimyindaing",
          "Lanmadaw",
          "Latha",
          "Mayangone",
          "Mingaladon",
          "Mingalartaungnyunt",
          "North Okkalapa",
          "Pazundaung",
          "Sanchaung",
          "South Okkalapa",
          "Shwepyitha",
          "Tamwe",
          "Thaketa",
          "Thingangyun",
          "Yankin",
          "Htantabin",
          "Dala"


      ];

      // Function to filter cities based on input
      function filterCities(input) {
        if (input.length < 2) return [];
        
        return cities.filter(city => 
          city.toLowerCase().includes(input.toLowerCase())
        ).slice(0, 10); // Limit to 10 results
      }

      // Function to display autocomplete results
      function showAutocompleteResults(results) {
        const resultsContainer = document.getElementById('autocompleteResults');
        resultsContainer.innerHTML = '';
        
        if (results.length === 0) {
          resultsContainer.style.display = 'none';
          return;
        }
        
        results.forEach(result => {
          const div = document.createElement('div');
          div.className = 'autocomplete-suggestion';
          div.textContent = result;
          div.addEventListener('click', () => {
            document.getElementById('locationInput').value = result;
            resultsContainer.style.display = 'none';
            document.getElementById('searchForm').submit();
          });
          resultsContainer.appendChild(div);
        });
        
        resultsContainer.style.display = 'block';
      }

      // Event listener for input
      document.getElementById('locationInput').addEventListener('input', function() {
        const input = this.value.trim();
        const results = filterCities(input);
        showAutocompleteResults(results);
      });

      // Hide autocomplete when clicking outside
      document.addEventListener('click', function(e) {
        if (!e.target.closest('.search-container')) {
          document.getElementById('autocompleteResults').style.display = 'none';
        }
      });

      // Handle form submission
      document.getElementById('searchForm').addEventListener('submit', function(e) {
        const input = document.getElementById('locationInput').value.trim();
        if (input.length === 0) {
          e.preventDefault();
          alert('Please enter a city name');
        }
      });
      
      // Add keyboard navigation for autocomplete
      document.getElementById('locationInput').addEventListener('keydown', function(e) {
        const resultsContainer = document.getElementById('autocompleteResults');
        const suggestions = resultsContainer.querySelectorAll('.autocomplete-suggestion');
        
        if (suggestions.length === 0) return;
        
        let current = -1;
        suggestions.forEach((suggestion, index) => {
          if (suggestion.classList.contains('selected')) {
            current = index;
          }
        });
        
        if (e.key === 'ArrowDown') {
          e.preventDefault();
          if (current < suggestions.length - 1) {
            if (current >= 0) {
              suggestions[current].classList.remove('selected');
            }
            current++;
            suggestions[current].classList.add('selected');
            suggestions[current].scrollIntoView({block: 'nearest'});
          }
        } else if (e.key === 'ArrowUp') {
          e.preventDefault();
          if (current > 0) {
            suggestions[current].classList.remove('selected');
            current--;
            suggestions[current].classList.add('selected');
            suggestions[current].scrollIntoView({block: 'nearest'});
          }
        } else if (e.key === 'Enter' && current >= 0) {
          e.preventDefault();
          suggestions[current].click();
        }
      });
    </script>
</body>
</html>