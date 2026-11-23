package com.securecounts.audits;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/download-document")
public class DownloadDocumentServlet extends HttpServlet {

    private Path getUploadDirectory() {

        String configuredDirectory = System.getenv("AUDIT_UPLOAD_DIR");

        if (configuredDirectory != null
                && !configuredDirectory.isBlank()) {

            return Paths.get(configuredDirectory).toAbsolutePath().normalize();
        }

        return Paths.get(
                "C:",
                "ProgramData",
                "SecureCountsAndAudits",
                "uploads").toAbsolutePath().normalize();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Validate document ID
        String idParameter = request.getParameter("id");

        if (idParameter == null || idParameter.isBlank()) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Document ID is required.");
            return;
        }

        int documentId;

        try {
            documentId = Integer.parseInt(idParameter);

            if (documentId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid document ID.");
            return;
        }

        // Retrieve document metadata
        DocumentService documentService = new DocumentService();

        DocumentRecord document;

        try {
            document = documentService.getDocumentById(documentId);

        } catch (Exception e) {
            getServletContext().log(
                    "Error retrieving document record.",
                    e);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to retrieve document.");

            return;
        }

        if (document == null) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Document not found.");
            return;
        }

        // Validate stored filename
        String storedFilename = document.getStoredFilename();

        if (storedFilename == null || storedFilename.isBlank()) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Document filename is invalid.");
            return;
        }

        Path uploadDirectory = getUploadDirectory();

        Path documentPath = uploadDirectory
                .resolve(storedFilename)
                .normalize();

        // Prevent directory traversal
        if (!documentPath.startsWith(uploadDirectory)
                || !documentPath.getFileName().toString()
                        .equals(storedFilename)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Invalid document path.");
            return;
        }

        // Confirm the PDF exists
        if (!Files.exists(documentPath)
                || !Files.isRegularFile(documentPath)) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "The document file could not be found.");
            return;
        }

        // Set download response headers
        response.setContentType("application/pdf");

        response.setContentLengthLong(
                Files.size(documentPath));

        response.setHeader(
                "Content-Disposition",
                "attachment; filename=\"" + storedFilename + "\"");

        response.setHeader(
                "X-Content-Type-Options",
                "nosniff");

        response.setHeader(
                "Cache-Control",
                "no-store");

        // Stream the PDF to the browser
        try (InputStream inputStream = Files.newInputStream(documentPath);
                var outputStream = response.getOutputStream()) {

            inputStream.transferTo(outputStream);
        }
    }
}