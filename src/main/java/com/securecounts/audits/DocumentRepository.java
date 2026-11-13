
package com.securecounts.audits;

import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DocumentRepository {

    private final String databaseUrl;

    public DocumentRepository() {

        String configuredPath = System.getenv("AUDIT_DB_PATH");

        Path databasePath;

        if (configuredPath != null && !configuredPath.isBlank()) {
            databasePath = Path.of(configuredPath);
        } else {
            databasePath = Path.of(
                    "C:", "ProgramData", "SecureCountsAndAudits",
                    "metadata", "audit.db");
        }

        try {
            Files.createDirectories(databasePath.getParent());
        } catch (Exception e) {
            throw new IllegalStateException(
                    "Could not create database directory.", e);
        }

        this.databaseUrl = "jdbc:sqlite:" + databasePath.toAbsolutePath();

        System.out.println(
                "AUDIT DATABASE: " + databasePath.toAbsolutePath());
    }

    private Connection getConnection() throws SQLException {

        try {
            Class.forName("org.sqlite.JDBC");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "SQLite JDBC driver could not be loaded.", e);
        }

        return DriverManager.getConnection(databaseUrl);
    }

    public void initializeDatabase() throws SQLException {

        String sql = """
                CREATE TABLE IF NOT EXISTS documents (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    original_filename TEXT NOT NULL,
                    stored_filename TEXT NOT NULL UNIQUE,
                    sha256 TEXT NOT NULL,
                    file_size INTEGER NOT NULL,
                    uploaded_by TEXT NOT NULL,
                    uploaded_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
                )
                """;

        try (Connection connection = getConnection();
                Statement statement = connection.createStatement()) {

            statement.execute(sql);
        }
    }

    public void saveDocument(
            String originalFilename,
            String storedFilename,
            String sha256,
            long fileSize,
            String uploadedBy) throws SQLException {

        String sql = """
                INSERT INTO documents (
                    original_filename,
                    stored_filename,
                    sha256,
                    file_size,
                    uploaded_by
                )
                VALUES (?, ?, ?, ?, ?)
                """;

        try (Connection connection = getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, originalFilename);
            statement.setString(2, storedFilename);
            statement.setString(3, sha256);
            statement.setLong(4, fileSize);
            statement.setString(5, uploadedBy);

            statement.executeUpdate();
        }
    }

    public List<DocumentRecord> getAllDocuments() throws SQLException {

        String sql = """
                SELECT id, original_filename, stored_filename,
                       sha256, file_size, uploaded_by, uploaded_at
                FROM documents
                ORDER BY uploaded_at DESC, id DESC
                """;

        List<DocumentRecord> documents = new ArrayList<>();

        try (Connection connection = getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet results = statement.executeQuery()) {

            while (results.next()) {

                DocumentRecord document = new DocumentRecord(
                        results.getInt("id"),
                        results.getString("original_filename"),
                        results.getString("stored_filename"),
                        results.getString("sha256"),
                        results.getLong("file_size"),
                        results.getString("uploaded_by"),
                        results.getString("uploaded_at"));

                documents.add(document);
            }
        }

        return documents;
    }
}
