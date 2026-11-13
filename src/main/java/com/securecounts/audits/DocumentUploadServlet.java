
package com.securecounts.audits;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HexFormat;
import java.util.UUID;
import java.sql.SQLException;

@WebServlet("/upload-document")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 10 * 1024 * 1024, maxRequestSize = 12 * 1024 * 1024)
public class DocumentUploadServlet extends HttpServlet {

    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;

    private final DocumentService documentService = new DocumentService();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String submittedToken = request.getParameter("csrfToken");
        String sessionToken = (String) request.getSession().getAttribute("csrfToken");

        if (submittedToken == null || sessionToken == null ||
                !MessageDigest.isEqual(
                        submittedToken.getBytes(java.nio.charset.StandardCharsets.UTF_8),
                        sessionToken.getBytes(java.nio.charset.StandardCharsets.UTF_8))) {

            request.setAttribute("errorMessage",
                    "Your session expired or the security check failed.");
            request.getRequestDispatcher("/documents.jsp").forward(request, response);
            return;
        }

        Path temporaryFile = null;

        try {
            Part filePart = request.getPart("document");

            if (filePart == null || filePart.getSize() == 0) {
                throw new IllegalArgumentException("Please select a PDF file.");
            }

            if (filePart.getSize() > MAX_FILE_SIZE) {
                throw new IllegalArgumentException("The file must be 10 MB or smaller.");
            }

            String submittedName = filePart.getSubmittedFileName();

            if (submittedName == null ||
                    !submittedName.toLowerCase().endsWith(".pdf")) {
                throw new IllegalArgumentException("Only PDF files are accepted.");
            }

            String configuredDirectory = System.getenv("AUDIT_UPLOAD_DIR");

            Path uploadDirectory;

            if (configuredDirectory != null && !configuredDirectory.isBlank()) {
                uploadDirectory = Path.of(configuredDirectory);
            } else {
                uploadDirectory = Path.of(
                        "C:", "ProgramData", "SecureCountsAndAudits",
                        "uploads");
            }

            Files.createDirectories(uploadDirectory);
            System.out.println("UPLOAD DIRECTORY: " + uploadDirectory.toAbsolutePath());

            String storedFilename = UUID.randomUUID() + ".pdf";

            temporaryFile = Files.createTempFile(
                    uploadDirectory, "upload-", ".tmp");

            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, temporaryFile,
                        StandardCopyOption.REPLACE_EXISTING);
            }

            byte[] header = new byte[5];

            try (InputStream input = Files.newInputStream(temporaryFile)) {
                if (input.read(header) != 5 ||
                        !new String(header, java.nio.charset.StandardCharsets.US_ASCII)
                                .equals("%PDF-")) {
                    throw new IllegalArgumentException(
                            "The uploaded file does not appear to be a valid PDF.");
                }
            }

            String sha256 = calculateSHA256(temporaryFile);

            Path finalFile = uploadDirectory.resolve(storedFilename);

            Files.move(temporaryFile, finalFile);
            temporaryFile = null;

            String originalFilename = submittedName.replace('\\', '/');

            originalFilename = originalFilename.substring(
                    originalFilename.lastIndexOf('/') + 1);

            String uploadedBy;

            if (request.getUserPrincipal() != null) {
                uploadedBy = request.getUserPrincipal().getName();
            } else {
                uploadedBy = "Demo user (not authenticated)";
            }

            try {

                documentService.registerDocument(
                        originalFilename,
                        storedFilename,
                        sha256,
                        filePart.getSize(),
                        uploadedBy);

            } catch (SQLException e) {

                Files.deleteIfExists(finalFile);

                throw e;
            }

            request.setAttribute("successMessage",
                    "Document uploaded successfully.");
            request.setAttribute("storedFilename", storedFilename);
            request.setAttribute("sha256", sha256);

        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());

        } catch (Exception e) {
            getServletContext().log("Document upload failed.", e);
            request.setAttribute("errorMessage",
                    "The document could not be uploaded. Please try again.");
        } finally {
            if (temporaryFile != null) {
                Files.deleteIfExists(temporaryFile);
            }
        }

        request.getRequestDispatcher("/documents.jsp").forward(request, response);
    }

    private String calculateSHA256(Path file)
            throws IOException, NoSuchAlgorithmException {

        MessageDigest digest = MessageDigest.getInstance("SHA-256");

        try (InputStream input = Files.newInputStream(file)) {
            byte[] buffer = new byte[8192];
            int bytesRead;

            while ((bytesRead = input.read(buffer)) != -1) {
                digest.update(buffer, 0, bytesRead);
            }
        }

        return HexFormat.of().formatHex(digest.digest());
    }
}
