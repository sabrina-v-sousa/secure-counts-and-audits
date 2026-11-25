
package com.securecounts.audits;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.sql.SQLException;

@WebServlet("/delete-document")
public class DeleteDocumentServlet extends HttpServlet {

    private final DocumentService documentService = new DocumentService();

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        String submittedToken = request.getParameter("csrfToken");
        String sessionToken = session == null
                ? null
                : (String) session.getAttribute("csrfToken");

        if (submittedToken == null || sessionToken == null ||
                !MessageDigest.isEqual(
                        submittedToken.getBytes(java.nio.charset.StandardCharsets.UTF_8),
                        sessionToken.getBytes(java.nio.charset.StandardCharsets.UTF_8))) {

            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Invalid security token.");
            return;
        }

        int documentId;

        try {
            documentId = Integer.parseInt(request.getParameter("id"));
            if (documentId <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException | NullPointerException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid document ID.");
            return;
        }

        try {
            DocumentRecord document = documentService.getDocumentById(documentId);

            if (document == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Document not found.");
                return;
            }

            String configuredDirectory = System.getenv("AUDIT_UPLOAD_DIR");

            Path uploadDirectory;

            if (configuredDirectory != null &&
                    !configuredDirectory.isBlank()) {
                uploadDirectory = Path.of(configuredDirectory);
            } else {
                uploadDirectory = Path.of(
                        "C:", "ProgramData", "SecureCountsAndAudits",
                        "uploads");
            }

            uploadDirectory = uploadDirectory.toAbsolutePath().normalize();

            // Ensure the stored filename cannot escape the upload directory.
            String storedFilename = document.getStoredFilename();
            Path filenamePath = Path.of(storedFilename);

            if (filenamePath.isAbsolute() ||
                    !filenamePath.getFileName().toString().equals(storedFilename)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid stored filename.");
                return;
            }

            Path filePath = uploadDirectory.resolve(filenamePath).normalize();

            if (!filePath.startsWith(uploadDirectory)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid file path.");
                return;
            }

            // Remove the physical file, then its database record.
            Files.deleteIfExists(filePath);
            documentService.deleteDocument(documentId);

            response.sendRedirect(
                    request.getContextPath() + "/documents.jsp?deleted=true");

        } catch (SQLException e) {
            getServletContext().log("Could not delete document record.", e);
            throw new ServletException("Could not delete document.", e);
        }
    }
}
