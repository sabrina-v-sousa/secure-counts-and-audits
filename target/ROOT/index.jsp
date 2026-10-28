<!DOCTYPE html>
<html lang="en">
<title>Auditors Start Page </title>
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

    <a href="#"
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

  <h1 class="w3-margin w3-jumbo">Auditor Dashboard</h1>

  <p class="w3-xlarge">Secure Counts and Audits</p>

  <button class="w3-button w3-black w3-padding-large w3-large w3-margin-top">
  Log Out
  </button>

</header>

<!-- First Section -->
<section class="w3-container w3-padding-64">

  <div class="w3-content w3-grid"
  style="grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:32px;align-items:center">

    <div>

      <h1>Secure Counts and Audit Project</h1>

      <h5 class="w3-padding-32">
      This project proposes creating a cost-effective, secure, and user-friendly solution to help smaller
      audit firms conduct physical asset or inventory counts in multiple, geographically dispersed client 
      sites—without requiring on-site presence. Key technologies include lightweight mobile applications, 
      secure data transmission, and machine learning–based verification to ensure integrity and reduce the 
      risk of fraud or error.
      </h5>

    </div>

    <div class="w3-center">
      <i class="fa fa-lock w3-padding-16 w3-text-blue" style="font-size:180px"></i>
    </div>

  </div>

</section>

<!-- Second Section -->
<section class="w3-container w3-light-grey w3-padding-64">

  <div class="w3-content w3-grid"
  style="grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:32px;align-items:center">

    <div class="w3-center">
      <i class="fa fa-coffee w3-padding-64 w3-text-blue"></i>
    </div>

    <div>

      <h1>Contact Us</h1>

      <h5 class="w3-padding-32">
      Please report bugs or complaints to this email: ssousa06@uoguelph.ca.
      </h5>

    </div>

  </div>

</section>

<!-- Quote -->
<div class="w3-container w3-black w3-center w3-opacity w3-padding-64">
  <h1 class="w3-margin w3-xlarge">Created by: Sabrina Sousa and Adam Orchard</h1>
</div>

<!-- Footer -->
<footer class="w3-container w3-padding-64 w3-center w3-opacity">

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