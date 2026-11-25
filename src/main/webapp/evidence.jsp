
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.UUID" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.io.File" %>
<%@ page import="com.securecounts.audits.DocumentService" %>
<%@ page import="com.securecounts.audits.DocumentRecord" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }

    private String formatFileSize(long bytes) {
        if (bytes < 1024) {
            return bytes + " B";
        }

        if (bytes < 1024 * 1024) {
            return String.format("%.2f KB", bytes / 1024.0);
        }

        return String.format("%.2f MB", bytes / (1024.0 * 1024.0));
    }
%>

<%
    if (session.getAttribute("csrfToken") == null) {
        session.setAttribute("csrfToken", UUID.randomUUID().toString());
    }

    List<DocumentRecord> documents = List.of();
    String databaseError = null;

    String uploadDirectory = System.getenv("AUDIT_UPLOAD_DIR");

    File uploadFolder;

    if (uploadDirectory != null && !uploadDirectory.isBlank()) {
        uploadFolder = new File(uploadDirectory);
    } else {
        uploadFolder = new File(
            "C:/ProgramData/SecureCountsAndAudits/uploads"
        );
    }

    try {
        DocumentService documentService = new DocumentService();
        documents = documentService.getAllDocuments();

    } catch (SQLException e) {
        application.log("Could not retrieve evidence documents.", e);
        databaseError = "Unable to retrieve evidence. Please try again later.";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet"
          href="https://www.w3schools.com/w3css/6/w3.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <title>View Evidence - Secure Counts and Audits</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
            margin: 0;
            padding: 0;
            color: #000000;
        }

        .container {
            max-width: 1100px;
            margin: 40px auto;
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        h1 {
            color: #ffffff;
        }        

        h2 {
            color: #263746;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 14px;
        }

        th, td {
            text-align: left;
            padding: 12px;
            border-bottom: 1px solid #ddd;
            vertical-align: top;
        }

        th {
            background: #263746;
            color: white;
        }

        tr:hover {
            background: #f4f6f8;
        }

        .hash {
            overflow-wrap: anywhere;
            font-family: monospace;
            font-size: 12px;
        }

        .empty-message {
            background: #f4f6f8;
            padding: 20px;
            border-radius: 5px;
        }

        .status-available {
            color: #198754;
            font-weight: bold;
        }

        .status-missing {
            color: #dc3545;
            font-weight: bold;
        }

        .action-button {
            display: inline-block;
            background: #263746;
            color: #ffffff;
            border: none;
            padding: 10px 12px;
            margin: 3px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
        }

        .action-button:hover {
            background: #3d566b;
            color: #ffffff;
        }

        .delete-button {
            background: #b02a37;
        }

        .delete-button:hover {
            background: #842029;
        }

        .error {
            background: #fce8e6;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }

        .back-link {
            display: inline-block;
            margin-top: 25px;
        }

    </style>

</head>

<body>

    <!-- Navbar -->

    <div class="w3-top">

        <nav class="w3-flex w3-blue w3-card w3-large">

            <a href="index.jsp"
               class="w3-button w3-padding-large w3-white">
                Home
            </a>

            <a href="clients.jsp"
               class="w3-button w3-hide-small w3-padding-large w3-hover-white">
                View Clients
            </a>

            <a href="documents.jsp"
               class="w3-button w3-hide-small w3-padding-large w3-hover-white">
                Upload Documents
            </a>

            <a href="evidence.jsp"
               class="w3-button w3-hide-small w3-padding-large w3-hover-white">
                View Evidence
            </a>

            <a href="video-conferencing/video-conferencing.jsp"
               class="w3-button w3-hide-small w3-padding-large w3-hover-white">
                Live Video Auditing
            </a>

            <button class="w3-bar-item w3-button w3-padding-large
                           w3-hide-medium w3-hide-large w3-right"
                    onclick="myFunction()">

                <i class="fa fa-bars"></i>

            </button>

        </nav>

        <!-- Mobile navigation -->

        <div id="navDemo"
             class="w3-bar-block w3-white w3-hide w3-hide-medium w3-hide-large">

            <a href="clients.jsp"
               class="w3-bar-item w3-button">
                View Clients
            </a>

            <a href="documents.jsp"
               class="w3-bar-item w3-button">
                Upload Documents
            </a>

            <a href="evidence.jsp"
               class="w3-bar-item w3-button">
                View Evidence
            </a>

            <a href="video-conferencing/video-conferencing.jsp"
               class="w3-bar-item w3-button">
                Live Video Auditing
            </a>

        </div>

    </div>

    <!-- Header -->

    <header class="w3-container w3-blue w3-center"
            style="padding:48px 16px">

        <h1 class="w3-margin w3-jumbo">
            View Evidence
        </h1>

        <p class="w3-xlarge">
            Secure Counts and Audits
        </p>

    </header>

    <div class="container">

        <h1>
            <i class="fa fa-folder-open"></i>
            Evidence Management
        </h1>

        <p>
            View, download, and manage documents submitted as audit evidence.
        </p>

        <% if (databaseError != null) { %>

            <div class="error">
                <%= escapeHtml(databaseError) %>
            </div>

        <% } else if (documents.isEmpty()) { %>

            <div class="empty-message">
                No evidence documents have been uploaded yet.
            </div>

        <% } else { %>

            <div class="table-wrapper">

                <table>

                    <thead>

                        <tr>
                            <th>Document</th>
                            <th>Original Filename</th>
                            <th>Upload Date</th>
                            <th>File Size</th>
                            <th>Uploaded By</th>
                            <th>SHA-256 Hash</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>

                    </thead>

                    <tbody>

                        <% for (DocumentRecord document : documents) { %>

                            <%
                                File evidenceFile = new File(
                                    uploadFolder,
                                    document.getStoredFilename()
                                );

                                boolean fileExists = evidenceFile.exists();
                            %>

                            <tr>

                                <td>
                                    <strong>
                                        <%= escapeHtml(document.getStoredFilename()) %>
                                    </strong>
                                </td>

                                <td>
                                    <%= escapeHtml(document.getOriginalFilename()) %>
                                </td>

                                <td>
                                    <%= escapeHtml(document.getUploadedAt()) %>
                                </td>

                                <td>
                                    <%= formatFileSize(document.getFileSize()) %>
                                </td>

                                <td>
                                    <%= escapeHtml(document.getUploadedBy()) %>
                                </td>

                                <td class="hash">
                                    <%= escapeHtml(document.getSha256()) %>
                                </td>

                                <td>

                                    <% if (fileExists) { %>

                                        <span class="status-available">
                                            <i class="fa fa-check-circle"></i>
                                            Available
                                        </span>

                                    <% } else { %>

                                        <span class="status-missing">
                                            <i class="fa fa-exclamation-circle"></i>
                                            Missing
                                        </span>

                                    <% } %>

                                </td>

                                <td>

                                    <% if (fileExists) { %>

                                        <a href="${pageContext.request.contextPath}/download-document?id=<%= document.getId() %>"
                                           class="action-button">

                                            <i class="fa fa-download"></i>
                                            Download

                                        </a>

                                    <% } %>

                                    <form method="post"
                                          action="${pageContext.request.contextPath}/delete-document"
                                          onsubmit="return confirm('Are you sure you want to permanently delete this evidence document?');">

                                        <input type="hidden"
                                               name="csrfToken"
                                               value="<%= escapeHtml(String.valueOf(session.getAttribute("csrfToken"))) %>">

                                        <input type="hidden"
                                               name="id"
                                               value="<%= document.getId() %>">

                                        <button type="submit"
                                                class="action-button delete-button">

                                            <i class="fa fa-trash"></i>
                                            Delete

                                        </button>

                                    </form>

                                </td>

                            </tr>

                        <% } %>

                    </tbody>

                </table>

            </div>

        <% } %>

        <p class="back-link">

            <a href="index.jsp">
                <i class="fa fa-arrow-left"></i>
                Return to Dashboard
            </a>

        </p>

    </div>

    <script>

        function myFunction() {

            var x = document.getElementById("navDemo");

            if (x.className.indexOf("w3-show") == -1) {
                x.className += " w3-show";
            } else {
                x.className = x.className.replace(" w3-show", "");
            }

        }

    </script>

</body>

</html>
