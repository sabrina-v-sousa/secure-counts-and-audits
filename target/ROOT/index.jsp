<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Auditor Dashboard | Secure Counts and Audits</title>

    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lato">

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <style>
        body,
        h1,
        h2,
        h3,
        h4,
        h5,
        h6 {
            font-family: "Lato", sans-serif;
        }

        .w3-bar,
        button {
            font-family: "Montserrat", sans-serif;
        }

        body {
            padding-top: 60px;
            background-color: #f5f7fa;
        }

        .dashboard-header {
            padding: 75px 16px;
        }

        .dashboard-card {
            min-height: 190px;
            transition: box-shadow 0.2s ease;
        }

        .dashboard-card:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .dashboard-icon {
            font-size: 42px;
            margin-bottom: 12px;
        }

        .project-description {
            line-height: 1.8;
        }

        footer {
            margin-top: 40px;
        }
    </style>
</head>

<body>

    <nav class="w3-top w3-bar w3-blue w3-card" aria-label="Main navigation">

        <a href="index.jsp" class="w3-bar-item w3-button w3-padding-large">
            <i class="fa fa-shield"></i>
            Secure Counts
        </a>

        <div class="w3-right w3-hide-small">
            <a href="index.jsp" class="w3-bar-item w3-button w3-padding-large">
                Home
            </a>

            <a href="clients.jsp" class="w3-bar-item w3-button w3-padding-large">
                View Clients
            </a>

            <a href="documents.jsp" class="w3-bar-item w3-button w3-padding-large">
                Documents
            </a>

            <a href="evidence.jsp" class="w3-bar-item w3-button w3-padding-large">
                Evidence
            </a>

            <a href="video-conferencing/video-conferencing.jsp" class="w3-bar-item w3-button w3-padding-large">
                Live Auditing
            </a>
        </div>

        <button class="w3-bar-item w3-button w3-right w3-hide-large w3-hide-medium" onclick="toggleMenu()"
            aria-label="Toggle navigation menu" aria-expanded="false" id="menuButton">
            <i class="fa fa-bars"></i>
        </button>
    </nav>

    <div id="mobileMenu" class="w3-bar-block w3-white w3-hide w3-hide-large w3-hide-medium" style="margin-top:60px"
        aria-label="Mobile navigation">

        <a href="index.jsp" class="w3-bar-item w3-button">
            Home
        </a>

        <a href="clients.jsp" class="w3-bar-item w3-button">
            View Clients
        </a>

        <a href="documents.jsp" class="w3-bar-item w3-button">
            Upload Documents
        </a>

        <a href="evidence.jsp" class="w3-bar-item w3-button">
            View Evidence
        </a>

        <a href="video-conferencing/video-conferencing.jsp" class="w3-bar-item w3-button">
            Live Video Auditing
        </a>
    </div>

    <header class="w3-container w3-blue w3-center dashboard-header">

        <h1 class="w3-jumbo">Auditor Dashboard</h1>

        <p class="w3-xlarge">
            Secure Counts and Audits
        </p>

        <p>
            Manage inventory audits, verification records, and supporting evidence.
        </p>

    </header>

    <main>

        <section class="w3-content w3-padding-32" style="max-width:1200px">

            <h2>Audit Workspace</h2>

            <p>
                Select an area below to begin managing your audits.
            </p>

            <div class="w3-row-padding">

                <div class="w3-third w3-margin-bottom">
                    <div class="w3-white w3-card w3-padding-24 w3-center dashboard-card">

                        <i class="fa fa-users w3-text-blue dashboard-icon" aria-hidden="true"></i>

                        <h3>Clients</h3>

                        <p>Manage client information and audit assignments.</p>

                        <a href="clients.jsp" class="w3-button w3-blue">
                            View Clients
                        </a>

                    </div>
                </div>

                <div class="w3-third w3-margin-bottom">
                    <div class="w3-white w3-card w3-padding-24 w3-center dashboard-card">

                        <i class="fa fa-file-text w3-text-blue dashboard-icon" aria-hidden="true"></i>

                        <h3>Client Documents</h3>

                        <p>Manage inventory lists and supporting documents.</p>

                        <a href="documents.jsp" class="w3-button w3-blue">
                            View Documents
                        </a>

                    </div>
                </div>

                <div class="w3-third w3-margin-bottom">
                    <div class="w3-white w3-card w3-padding-24 w3-center dashboard-card">

                        <i class="fa fa-lock w3-text-blue dashboard-icon" aria-hidden="true"></i>

                        <h3>Audit Evidence</h3>

                        <p>Inventory working papers and supporting documentation.</p>

                        <a href="evidence.jsp" class="w3-button w3-blue">
                            View Evidence
                        </a>

                    </div>
                </div>

            </div>

            <div class="w3-row-padding">

                <div class="w3-half w3-margin-bottom">
                    <div class="w3-white w3-card w3-padding-24 w3-center dashboard-card">

                        <i class="fa fa-video-camera w3-text-blue dashboard-icon" aria-hidden="true"></i>

                        <h3>Live Video Auditing</h3>

                        <p>
                            Access audit sessions and record inventory
                            verification observations.
                        </p>

                        <a href="video-conferencing/video-conferencing.jsp" class="w3-button w3-blue">
                            Open Audit Workspace
                        </a>

                    </div>
                </div>

                <div class="w3-half w3-margin-bottom">
                    <div class="w3-white w3-card w3-padding-24 w3-center dashboard-card">

                        <i class="fa fa-clipboard w3-text-blue dashboard-icon" aria-hidden="true"></i>

                        <h3>Reports</h3>

                        <p>
                            Review audit results, discrepancies, and
                            verification exceptions.
                        </p>

                        <a href="reports.jsp" class="w3-button w3-blue">
                            View Reports
                        </a>

                    </div>
                </div>

            </div>

        </section>

        <section class="w3-container w3-light-grey w3-padding-64">

            <div class="w3-content" style="max-width:1000px">

                <h2>About the Project</h2>

                <p class="project-description">
                    This project proposes creating a cost-effective, 
                    secure, and user-friendly solution to help smaller 
                    audit firms conduct physical asset or inventory counts in multiple, 
                    geographically dispersed client sites, without requiring on-site presence. 
                    Key technologies include lightweight mobile applications, 
                    secure data transmission, and machine learning-based 
                    verification to ensure integrity and reduce the risk of fraud or error.
                </p>


            </div>

        </section>

    </main>

    <footer class="w3-container w3-dark-grey w3-center w3-padding-32">

        <p>
            Secure Counts and Audits
        </p>

        <p>
            Created by: Sabrina Sousa and Adam Orchard
        </p>

        <p>
            Project Supervised by Dr. Peter Ghattas
        </p>

    </footer>

    <script>
        function toggleMenu() {
            const menu = document.getElementById("mobileMenu");
            const button = document.getElementById("menuButton");

            menu.classList.toggle("w3-show");

            const expanded = menu.classList.contains("w3-show");

            button.setAttribute("aria-expanded", String(expanded));
        }
    </script>
</body>

</html>