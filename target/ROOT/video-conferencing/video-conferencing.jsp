<!DOCTYPE html>
<html lang="en">
<title>Live Video Audit</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/6/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lato">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<style>
body,h1,h2,h3,h4,h5,h6 {font-family:"Lato",sans-serif}
.w3-bar,h1,button {font-family:"Montserrat",sans-serif}
.fa-anchor,.fa-coffee {font-size:200px}
</style>

<body>

<!-- Navbar -->
<div class="w3-top">

  <nav class="w3-flex w3-blue w3-card w3-large">

    <a href="../index.jsp"
    class="w3-button w3-padding-large w3-white">
    Home
    </a>

    <a href="#"
    class="w3-button w3-hide-small w3-padding-large w3-hover-white">
    View Clients
    </a>

    <a href="#"
    class="w3-button w3-hide-small w3-padding-large w3-hover-white">
    Upload Documents
    </a>

    <a href="#"
    class="w3-button w3-hide-small w3-padding-large w3-hover-white">
    View Evidence
    </a>

    <a href="#"
    class="w3-button w3-hide-small w3-padding-large w3-hover-white">
    Live Video Auditing
    </a>

    <button
    class="w3-button w3-hide-medium w3-hide-large w3-padding-large w3-hover-white w3-blue"
    style="margin-left:auto"
    onclick="myFunction()"
    title="Toggle Navigation Menu">
      <i class="fa fa-bars"></i>
    </button>

  </nav>

  <!-- Navbar on small screens -->
  <div id="navDemo"
  class="w3-bar-block w3-white w3-hide w3-hide-large w3-hide-medium w3-large">

    <a href="#" class="w3-bar-item w3-button w3-padding-large">Link 1</a>
    <a href="#" class="w3-bar-item w3-button w3-padding-large">Link 2</a>
    <a href="#" class="w3-bar-item w3-button w3-padding-large">Link 3</a>
    <a href="#" class="w3-bar-item w3-button w3-padding-large">Link 4</a>

  </div>

</div>

<!-- Header -->
<header class="w3-container w3-blue w3-center"
style="padding:128px 16px">

  <h1 class="w3-margin w3-jumbo">Teams Video Auditing</h1>

  <p class="w3-xlarge">Secure Counts and Audits</p>

</header>

<!-- First Section -->
<section class="w3-container w3-padding-64">

  <div class="w3-content w3-grid"
  style="grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:32px;align-items:center">

    <div>

      <body>
        <h4>Azure Communication Services - Calling Web SDK</h4>
        <input id="user-access-token"
            type="text"
            placeholder="User access token"
            style="margin-bottom:1em; width: 500px;"/>
        <button id="initialize-call-agent" type="button">Initialize Call Agent</button>
        <br>
        <br>
        <input id="callee-acs-user-id"
            type="text"
            placeholder="Enter callee's Azure Communication Services user identity in format: '8:acs:resourceId_userId'"
            style="margin-bottom:1em; width: 500px; display: block;"/>
        <button id="start-call-button" type="button" disabled="true">Start Call</button>
        <button id="hangup-call-button" type="button" disabled="true">Hang up Call</button>
        <button id="accept-call-button" type="button" disabled="true">Accept Call</button>
        <button id="start-video-button" type="button" disabled="true">Start Video</button>
        <button id="stop-video-button" type="button" disabled="true">Stop Video</button>
        <br>
        <br>
        <div id="connectedLabel" style="color: #13bb13;" hidden>Call is connected!</div>
        <br>
        <div id="remoteVideosGallery" style="width: 40%;" hidden>Remote participants' video streams:</div>
        <br>
        <div id="localVideoContainer" style="width: 30%;" hidden>Local video stream:</div>
        <!-- points to the bundle generated from client.js -->
        <script src="./main.js"></script>
      </body>
      
    </div>

  </div>

</section>

<!-- Footer -->
<footer class="w3-container w3-padding-64 w3-center w3-opacity">

  <p>
  Created by: Sabrina Sousa and Adam Orchard
  </p>

  <p>
  Project Supervised by Dr. Peter Ghattas
  </p>

</footer>

<script>
const mobileMenu = document.getElementById("navDemo");

function myFunction() {
  mobileMenu.classList.toggle("w3-show");
}
</script>

</body>
</html>