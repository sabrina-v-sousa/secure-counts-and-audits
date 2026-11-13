
package com.securecounts.audits;

public class DocumentRecord {

    private final int id;
    private final String originalFilename;
    private final String storedFilename;
    private final String sha256;
    private final long fileSize;
    private final String uploadedBy;
    private final String uploadedAt;

    public DocumentRecord(
            int id,
            String originalFilename,
            String storedFilename,
            String sha256,
            long fileSize,
            String uploadedBy,
            String uploadedAt) {

        this.id = id;
        this.originalFilename = originalFilename;
        this.storedFilename = storedFilename;
        this.sha256 = sha256;
        this.fileSize = fileSize;
        this.uploadedBy = uploadedBy;
        this.uploadedAt = uploadedAt;
    }

    public int getId() {
        return id;
    }

    public String getOriginalFilename() {
        return originalFilename;
    }

    public String getStoredFilename() {
        return storedFilename;
    }

    public String getSha256() {
        return sha256;
    }

    public long getFileSize() {
        return fileSize;
    }

    public String getUploadedBy() {
        return uploadedBy;
    }

    public String getUploadedAt() {
        return uploadedAt;
    }
}
