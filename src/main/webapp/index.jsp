<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SkyCast</title>
    <link rel="stylesheet" type="text/css" href="css/header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            color: #fff;
            text-align: center;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* 🔹 Hero section (only background area) */
        .hero-section {
            padding: 50px 20px;
            transition: background 0.5s ease-in-out;
            flex: 1;
        }

        /* Background variants */
        .hero-section.morning {
            background: url("./photo/sebastien-gabriel--IMlv9Jlb24-unsplash.jpg") no-repeat center center/cover;
        }
        .hero-section.afternoon {
            background: url("./photo/grooveland-designs-zjoydJb17mE-unsplash.jpg") no-repeat center center/cover;
        }
        .hero-section.evening {
            background: url("./photo/jason-mavrommatis-GPPAjJicemU-unsplash.jpg") no-repeat center center/cover;
        }
        .hero-section.night {
            background: url("./photo/nathan-anderson-L95xDkSSuWw-unsplash.jpg") no-repeat center center/cover;
        }

        .search-container {
            margin-top: 30px;
            display: flex;
            justify-content: left;
            align-items: left;
            gap: 15px;
            flex-wrap: wrap;
            margin-left:20px;
            position: relative;
        }

        .search-form {
            display: flex;
            gap: 10px;
            position: relative;
        }

        .search-form input[type="text"] {
            padding: 10px;
            width: 250px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            background: rgba(255, 255, 255, 0.3);
            color: #fff;
            transition: background 0.3s, box-shadow 0.3s;
        }

        .search-form input[type="text"]::placeholder {
            color: #ccc;
        }

        .search-form input[type="text"]:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.2);
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.7);
        }

        .autocomplete-suggestions {
            border: 1px solid #e1e8ed;
            border-radius: 8px;
            background-color: #fff;
            max-height: 300px;
            overflow-y: auto;
            position: absolute;
            width: 250px;
            z-index: 1000;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            left: 0;
            top: 45px;
            margin-top: 4px;
            padding: 8px 0;
            display: none;
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
            text-align: left;
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

        .search-form button,
        .location-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 20px;
            background: rgba(0, 0, 0, 0.6);
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s, transform 0.2s;
        }

        .search-form button:hover,
        .location-btn:hover {
            background: rgba(0, 0, 0, 0.8);
            transform: scale(1.05);
        }

        .weather-display {
            margin-left:20px;
            margin-top: 40px;
            font-size: 22px;
        }

        .temp {
            font-size: 60px;
            font-weight: bold;
        }

        .msg-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }

        .msg-box {
            position: relative;
            width: 450px;
            max-width: 90%;
            padding: 30px;
            border-radius: 12px;
            font-family: Arial, sans-serif;
            font-size: 18px;
            text-align: center;
            box-shadow: 0 6px 15px rgba(0,0,0,0.4);
            animation: fadeIn 0.3s ease-in-out;
        }

        .msg-box.success {
            background: #e6ffed;
            border: 2px solid #28a745;
            color: #155724;
        }
        .msg-box.error {
            background: #ffe6e6;
            border: 2px solid #dc3545;
            color: #721c24;
        }
        .msg-box.warning {
            background: #fff3cd;
            border: 2px solid #ffc107;
            color: #856404;
        }

        .close-btn {
            position: absolute;
            right: 15px;
            top: 10px;
            font-size: 28px;
            font-weight: bold;
            color: #333;
            cursor: pointer;
        }

        @keyframes fadeIn {
            from {opacity: 0; transform: scale(0.8);}
            to {opacity: 1; transform: scale(1);}
        }

        /* Loading spinner for suggestions */
        .suggestions-loading {
            display: none;
            position: absolute;
            top: 50%;
            right: 10px;
            transform: translateY(-50%);
            width: 20px;
            height: 20px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: translateY(-50%) rotate(0deg); }
            100% { transform: translateY(-50%) rotate(360deg); }
        }
        
        /* Footer styling */
        footer {
            background: rgba(0, 0, 0, 0.7);
            padding: 15px;
            margin-top: auto;
        }
    </style>
    <script>
        function setBackgroundByTime() {
            let hero = document.querySelector(".hero-section");
            hero.className = "hero-section";

            let hour = new Date().getHours();

            if (hour >= 5 && hour < 12) {
                hero.classList.add("morning");
            } else if (hour >= 12 && hour < 17) {
                hero.classList.add("afternoon");
            } else if (hour >= 17 && hour < 20) {
                hero.classList.add("evening");
            } else {
                hero.classList.add("night");
            }
        }

        function useCurrentLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    function (position) {
                        let lat = position.coords.latitude;
                        let lon = position.coords.longitude;
                        window.location.href = "MainServlet?lat=" + lat + "&lon=" + lon;
                    },
                    function (error) {
                        alert("Unable to retrieve location. Please allow GPS access.");
                    }
                );
            } else {
                alert("Geolocation is not supported by this browser.");
            }
        }

        // City suggestions data
       // City suggestions data
        const popularCities = [
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

        // Initialize suggestions when page loads
        window.onload = function() {
            setBackgroundByTime();
            
            // Auto-submit form when a suggestion is clicked
            document.addEventListener('click', function(e) {
                if (e.target.classList.contains('autocomplete-suggestion')) {
                    // Set the value in the search input
                    document.querySelector('input[name="location"]').value = e.target.textContent;
                    
                    // Hide suggestions
                    hideSuggestions();
                    
                    // Submit the form
                    document.querySelector('.search-form').submit();
                }
            });
        };

        // Enhanced search with real-time suggestions
        function getCitySuggestions(input) {
            if (input.length < 1) {
                hideSuggestions();
                return;
            }
            
            // Show loading spinner
            document.getElementById('suggestionsLoading').style.display = 'block';
            
            // Simulate API call (replace with actual API call if available)
            setTimeout(() => {
                const filteredCities = popularCities.filter(city => 
                    city.toLowerCase().includes(input.toLowerCase())
                );
                
                showSuggestions(filteredCities);
                document.getElementById('suggestionsLoading').style.display = 'none';
            }, 300);
        }

        function showSuggestions(cities) {
            const suggestionsContainer = document.getElementById('autocompleteSuggestions');
            suggestionsContainer.innerHTML = '';
            
            if (cities.length === 0) {
                const noResults = document.createElement('div');
                noResults.className = 'autocomplete-suggestion';
                noResults.innerHTML = 'No cities found';
                suggestionsContainer.appendChild(noResults);
            } else {
                cities.slice(0, 10).forEach(city => { // Show max 10 suggestions
                    const suggestion = document.createElement('div');
                    suggestion.className = 'autocomplete-suggestion';
                    suggestion.textContent = city;
                    suggestionsContainer.appendChild(suggestion);
                });
            }
            
            suggestionsContainer.style.display = 'block';
        }

        function hideSuggestions() {
            document.getElementById('autocompleteSuggestions').style.display = 'none';
        }

        // Keyboard navigation for suggestions
        let selectedSuggestionIndex = -1;
        
        function handleInputKeyDown(e) {
            const suggestions = document.querySelectorAll('.autocomplete-suggestion');
            
            if (e.key === 'ArrowDown') {
                e.preventDefault();
                selectedSuggestionIndex = Math.min(selectedSuggestionIndex + 1, suggestions.length - 1);
                updateSelectedSuggestion(suggestions);
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                selectedSuggestionIndex = Math.max(selectedSuggestionIndex - 1, -1);
                updateSelectedSuggestion(suggestions);
            } else if (e.key === 'Enter' && selectedSuggestionIndex >= 0) {
                e.preventDefault();
                document.querySelector('input[name="location"]').value = suggestions[selectedSuggestionIndex].textContent;
                hideSuggestions();
                document.querySelector('.search-form').submit();
            } else if (e.key === 'Escape') {
                hideSuggestions();
                selectedSuggestionIndex = -1;
            }
        }
        
        function updateSelectedSuggestion(suggestions) {
            // Remove selected class from all suggestions
            suggestions.forEach(s => s.classList.remove('selected'));
            
            // Add selected class to current suggestion
            if (selectedSuggestionIndex >= 0 && selectedSuggestionIndex < suggestions.length) {
                suggestions[selectedSuggestionIndex].classList.add('selected');
                // Scroll into view if needed
                suggestions[selectedSuggestionIndex].scrollIntoView({ block: 'nearest' });
            }
        }
    </script>
</head>
<body>

    <!-- Header -->
    <div class="navbar navbar-expand-xl bg-black sticky-top shadow">
        <a class="navbar-brand text-white ms-3" href="index.jsp"><i class="fa-solid fa-cloud me-2"></i>SkyCast</a>
        <a class="navbar-brand d-flex align-items-center" href="index.jsp">
        </a>
    </div>

    <!-- 🔹 Hero Section with background -->
    <div class="hero-section">
        <div class="search-container">
            <!-- Search form with city suggestions -->
            <form action="MainServlet" method="GET" class="search-form">
                <input type="hidden" name="page" value="today">
                <input type="text" name="location" placeholder="Search city..." 
                       oninput="getCitySuggestions(this.value)"
                       onblur="setTimeout(hideSuggestions, 200)"
                       onkeydown="handleInputKeyDown(event)"
                       autocomplete="off"
                       required>
                <div id="autocompleteSuggestions" class="autocomplete-suggestions"></div>
                <div id="suggestionsLoading" class="suggestions-loading"></div>
                <button type="submit">Search</button>
            </form>

            <!-- Current location button -->
            <button type="button" onclick="useCurrentLocation()" class="location-btn">
                Use Current Location
            </button>
        </div>

        <c:set var="displayData" value="${not empty weatherData ? weatherData : sessionScope.lastWeatherData}" />

        <c:if test="${not empty displayData}">
            <a href="MainServlet?location=${displayData.location}" 
               style="text-decoration: none; color: inherit;">
                <div style="display: inline-block; background: rgba(0,0,0,0.6); padding: 20px; border-radius: 15px; box-shadow: 0 4px 12px rgba(0,0,0,0.3); margin: 20px; width: 300px; cursor: pointer; transition: transform 0.2s, box-shadow 0.2s;"
                     onmouseover="this.style.transform='scale(1.05)'; this.style.boxShadow='0 8px 20px rgba(0,0,0,0.5)';"
                     onmouseout="this.style.transform='scale(1)'; this.style.boxShadow='0 4px 12px rgba(0,0,0,0.3)';">
                    <h3 style="margin-bottom: 10px; font-weight: normal; color:white;">Recent Location</h3>
                    <div style="font-size: 50px; font-weight: bold; color:white;">${displayData.temp}&deg;C</div>
                    <div style="margin: 5px 0; color:white;" class="text-capitalize">${displayData.condition}</div>
                    <div style="font-size: 18px; color:white;">${displayData.location}</div>
                </div>
            </a>
        </c:if>

        <c:if test="${empty displayData}">
            <div style="
                display: inline-block;
                background: rgba(0, 0, 0, 0.7);
                padding: 25px 20px;
                border-radius: 20px;
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.4);
                margin: 20px;
                width: 220px;
                text-align: center;
                transition: transform 0.2s, box-shadow 0.2s;
                cursor: default;"
            onmouseover="this.style.transform='scale(1.05)'; this.style.boxShadow='0 10px 25px rgba(0,0,0,0.6)';"
            onmouseout="this.style.transform='scale(1)'; this.style.boxShadow='0 6px 15px rgba(0,0,0,0.4)';">
                <div style="font-size: 50px; font-weight: bold; color: #fff;">--°C</div>
                <div style="font-size: 18px; color: #ddd; margin: 5px 0;">No data</div>
                <div style="font-size: 16px; color: #bbb;">Unknown</div>
            </div>
        </c:if>
    </div>

    <jsp:include page="footer.jsp" />
    
    <c:if test="${not empty sessionScope.message}">
        <div class="msg-overlay">
            <div class="msg-box ${sessionScope.type}">
               <span class="close-btn" 
      onclick="document.querySelector('.msg-overlay').style.display='none'; 
               window.location.href='MainServlet?page=today&lat=16.8566575&lon=96.1374665';">&times;</span>

                <p>${sessionScope.message}</p>
            </div>
        </div>
        <c:remove var="message" scope="session"/>
        <c:remove var="type" scope="session"/>
    </c:if>
</body>
</html>