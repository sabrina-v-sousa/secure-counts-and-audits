<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![sabrina-v-sousa][sabrina-v-sousa]][sabrina-v-sousa-url]
[![aorch289][aorch289]][aorch289-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/sabrina-v-sousa/secure-counts-and-audits">
    <img src="src/main/webapp/favicon.ico" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">Secure Counts</h3>

  <p align="center">
    Web App For Secure Remote Auditing
    <br />
    <a href="https://secure-counts-and-audits-eahrg0bzfgbhewew.canadacentral-01.azurewebsites.net/">View Demo</a>
    &middot;
    <a href="https://github.com/sabrina-v-sousa/secure-counts-and-audits/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    &middot;
    <a href="https://github.com/sabrina-v-sousa/secure-counts-and-audits/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
        <li><a href="#usage">Usage</a></li>
      </ul>
    </li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
    <li><a href="#attributions">Attributions</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

![Secure Counts Web App Screen Shot][product-screenshot]

This project proposes creating a cost-effective, secure, and user-friendly solution to help smaller audit firms conduct physical asset or inventory counts in multiple, geographically dispersed client sites, without requiring on-site presence. Key technologies include lightweight mobile applications, secure data transmission, and machine learning-based verification to ensure integrity and reduce the risk of fraud or error.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

* ![Microsoft Azure][Microsoft Azure]
* ![JavaScript][JavaScript]
* ![Java][Java]
* ![Node.js][Node.js]
* ![CSS][CSS]

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these steps.

### Prerequisites

* [![Java][Java]][Java url]
  (version 25.0.5.0.2 or later)
* [![Node.js][Node.js]][Node url]
  (version 10.2.4 or later)
* [![Apache Maven][Apache Maven]][Maven url]
  (version 3.10.0 or later)
* [![Microsoft Azure][Microsoft Azure]][Azure url]
  Communication Service
* [![Docker][Docker]][Docker url] 
  (version 29.6.1 or later)

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/sabrina-v-sousa/secure-counts-and-audits.git
   ```
2. Create an Azure Communication Service
3. In the Communication Service, go to Settings > Keys > Connection String
4. Set a connection string environment variable 
   ```sh
   set CONN_STRING1=<connection_string>
   ```
5. Run ROOT.war as a local web app with Docker
   ```sh
   docker run --rm -p 8080:8080 -e "CONN_STRING1=%CONN_STRING1%" -v "%cd%\target\ROOT.war:/usr/local/tomcat/webapps/ROOT.war" tomcat:11.0-jdk25
   ```
6. Local web app will be available at http://localhost:8080/

### Usage

Changes can be implemented by running these commands.

1. Install NPM dependencies
   ```sh
   npm ci
   ```
2. Build webpack bundle (if .js files were changed)
   ```sh
   npm run build
   ```
3. Create web app package
   ```sh
   mvn package
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* ![Dr. Peter Ghattas][Dr. Peter Ghattas] 

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- Attributions -->
## Attributions

*   ![Project Icon][Project Icon]
    Lock directory security protection Icon by Icon Factory on <a href="https://icon-icons.com/authors/1444-icon-factory">Icon-Icons.com</a>
*   ![README Template][README Template]
    <a href="https://github.com/othneildrewBest-README-Template">Best-README-Template</a>
*   ![CSS Template][CSS Template]
    <a href="https://www.w3schools.com/w3css/tryw3css_templates_start_page.htm">W3 Schools Start Page Template</a> 



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/sabrina-v-sousa/secure-counts-and-audits.svg?style=for-the-badge
[contributors-url]: https://github.com/sabrina-v-sousa/secure-counts-and-audits/graphs/contributors
[sabrina-v-sousa-url]: https://github.com/sabrina-v-sousa
[aorch289-url]: https://github.com/aorch289
[product-screenshot]: images/Screenshot.jpg
[Java url]: https://www.oracle.com/ca-en/java/technologies/downloads/#jdk25-linux
[Node url]: https://nodejs.org/en/download
[Maven url]: https://maven.apache.org/install.html
[Azure url]: https://azure.microsoft.com/en-us
[Docker url]: https://docs.docker.com/engine/install/
<!-- Shields.io badges. You can a comprehensive list with many more badges at: https://github.com/inttter/md-badges -->
[sabrina-v-sousa]: https://img.shields.io/badge/sabrina--v--sousa-blue?style=for-the-badge
[aorch289]: https://img.shields.io/badge/aorch289-orange?style=for-the-badge
[Project Icon]: https://img.shields.io/badge/Project_Icon-grey
[README Template]: https://img.shields.io/badge/README_Template-grey
[CSS Template]: https://img.shields.io/badge/CSS_Template-grey
[Microsoft Azure]: https://custom-icon-badges.demolab.com/badge/Microsoft%20Azure-0089D6?logo=msazure&logoColor=white
[Java]: https://img.shields.io/badge/Java-%23ED8B00.svg?logo=openjdk&logoColor=white
[JavaScript]: https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=000
[Node.js]: https://img.shields.io/badge/Node.js-6DA55F?logo=node.js&logoColor=white
[CSS]: https://img.shields.io/badge/CSS-639?logo=css&logoColor=fff
[Apache Maven]: https://img.shields.io/badge/Apache_Maven-grey
[Docker]: https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=fff
[Dr. Peter Ghattas]: https://img.shields.io/badge/Project_Supervisor:_Dr._Peter_Ghattas-purple