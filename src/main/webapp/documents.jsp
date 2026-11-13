
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.UUID" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
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

    try {
        DocumentService documentService = new DocumentService();
        documents = documentService.getAllDocuments();
    } catch (SQLException e) {
        application.log("Could not retrieve uploaded documents.", e);
        databaseError = "Unable to retrieve document history. Please try again later.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Documents - Secure Counts and Audits</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
            margin: 0;
            padding: 40px 20px;
            color: #263746;
        }
        .container {
            max-width: 1100px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        h1, h2 {
            color: #263746;
        }
        .upload-section {
            margin-bottom: 35px;
            padding-bottom: 25px;
            border-bottom: 1px solid #ddd;
        }
        input[type="file"] {
            display: block;
            margin: 20px 0;
        }
        button {
            background: #263746;
            color: white;
            border: none;
            padding: 12px 22px;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background: #3d566b;
        }
        .success {
            background: #e6f4ea;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .error {
            background: #fce8e6;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .hash {
            overflow-wrap: anywhere;
            font-family: monospace;
            font-size: 12px;
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
        .empty-message {
            background: #f4f6f8;
            padding: 20px;
            border-radius: 5px;
        }
        .back-link {
            display: inline-block;
            margin-top: 25px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Audit Documents</h1>
    <div class="upload-section">
        <h2>Upload Audit Document</h2>
        <p>Select a PDF document to upload as audit evidence.</p>
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="success">
                <strong>
                    <%= escapeHtml(String.valueOf(request.getAttribute("successMessage"))) %>
                </strong>
                <p>
                    Stored file:
                    <%= escapeHtml(String.valueOf(request.getAttribute("storedFilename"))) %>
                </p>
                <p>SHA-256 hash:</p>
                <p class="hash">
                    <%= escapeHtml(String.valueOf(request.getAttribute("sha256"))) %>
                </p>
            </div>
        <% } %>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error">
                <%= escapeHtml(String.valueOf(request.getAttribute("errorMessage"))) %>
            </div>
        <% } %>
        <form action="${pageContext.request.contextPath}/upload-document"
              method="post"
              enctype="multipart/form-data">
            <input type="hidden"
                   name="csrfToken"
                   value="<%= escapeHtml(String.valueOf(session.getAttribute("csrfToken"))) %>">
            <label for="document">Choose a PDF document:</label>
            <input type="file"
                   id="document"
                   name="document"
                   accept=".pdf,application/pdf"
                   required>
            <button type="submit">Upload Document</button>
        </form>
    </div>
    <div class="history-section">
        <h2>Uploaded Documents</h2>
        <p>Document records retrieved from the audit database.</p>
        <% if (databaseError != null) { %>
            <div class="error">
                <%= escapeHtml(databaseError) %>
            </div>
        <% } else if (documents.isEmpty()) { %>
            <div class="empty-message">
                No documents have been uploaded yet.
            </div>
        <% } else { %>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Filename</th>
                            <th>Upload Date</th>
                            <th>File Size</th>
                            <th>Uploaded By</th>
                            <th>SHA-256 Hash</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (DocumentRecord document : documents) { %>
                            <tr>
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
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>

    <p class="back-link">
        <a href="index.jsp">Return to Dashboard</a>
    </p>

</div>

</body>
</html>
