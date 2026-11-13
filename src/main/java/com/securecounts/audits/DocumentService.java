
package com.securecounts.audits;

import java.sql.SQLException;
import java.util.List;

public class DocumentService {

    private final DocumentRepository repository;

    public DocumentService() {
        this.repository = new DocumentRepository();
    }

    public void initialize() throws SQLException {
        repository.initializeDatabase();
    }

    public void registerDocument(
            String originalFilename,
            String storedFilename,
            String sha256,
            long fileSize,
            String uploadedBy) throws SQLException {

        repository.initializeDatabase();

        repository.saveDocument(
                originalFilename,
                storedFilename,
                sha256,
                fileSize,
                uploadedBy);
    }

    public List<DocumentRecord> getAllDocuments() throws SQLException {
        return repository.getAllDocuments();
    }

}
