# File Metadata Service API

This service provides file metadata operations and file retrieval from the uploads directory. It's separate from the main file upload service and focuses on managing already uploaded files.

## Base URL
```
/api/file-metadata
```

## Endpoints

### 1. Get All Files Metadata
**GET** `/list`

Returns metadata of all files in the uploads directory without loading file contents.

**Response:**
```json
{
  "success": true,
  "message": "Found 15 uploaded files",
  "files": [
    {
      "id": "base64-encoded-path",
      "name": "document.pdf",
      "originalName": "document.pdf",
      "extension": "pdf",
      "size": 1024000,
      "mimetype": "application/pdf",
      "createdAt": "2024-01-01T00:00:00.000Z",
      "modifiedAt": "2024-01-01T00:00:00.000Z",
      "relativePath": "documents/document.pdf"
    }
  ],
  "totalFiles": 15,
  "totalSize": 15360000
}
```

### 2. Download File by Name
**GET** `/download/:filename`

Downloads a file by exact filename match.

**Parameters:**
- `filename` (path parameter): Exact filename to download

**Response:**
- File download with appropriate headers
- 404 if file not found

### 3. Stream File by Name
**GET** `/stream/:filename`

Streams a file for viewing in browser (inline) by exact filename match.

**Parameters:**
- `filename` (path parameter): Exact filename to stream

**Response:**
- File stream with inline content disposition
- 404 if file not found

### 4. Get File by ID
**GET** `/file/:fileId`

Gets a file using its base64-encoded ID.

**Parameters:**
- `fileId` (path parameter): Base64-encoded file path

**Response:**
- File download with appropriate headers
- 404 if file not found

### 5. Search Files by Name
**GET** `/search?q=searchTerm`

Search for files by partial name match (case-insensitive).

**Query Parameters:**
- `q` (required): Search term to match against filenames

**Response:**
```json
{
  "success": true,
  "message": "Found 3 files matching \"document\"",
  "files": [
    {
      "id": "base64-encoded-path",
      "name": "document.pdf",
      "originalName": "document.pdf",
      "extension": "pdf",
      "size": 1024000,
      "mimetype": "application/pdf",
      "createdAt": "2024-01-01T00:00:00.000Z",
      "modifiedAt": "2024-01-01T00:00:00.000Z",
      "relativePath": "documents/document.pdf"
    }
  ],
  "totalFiles": 3,
  "totalSize": 3072000
}
```

### 6. Delete File by Name
**DELETE** `/delete/:filename`

Deletes a file by exact filename match.

**Parameters:**
- `filename` (path parameter): Exact filename to delete

**Response:**
```json
{
  "success": true,
  "message": "File deleted successfully: document.pdf"
}
```

### 7. Get Uploads Statistics
**GET** `/stats`

Get statistics about the uploads directory.

**Response:**
```json
{
  "success": true,
  "message": "Upload statistics retrieved successfully",
  "stats": {
    "totalFiles": 15,
    "totalSize": 15360000,
    "totalDirectories": 3,
    "lastModified": "2024-01-01T00:00:00.000Z"
  }
}
```

### 8. Health Check
**GET** `/health`

Check the health status of the file metadata service.

**Response:**
```json
{
  "success": true,
  "message": "File Metadata Service is healthy",
  "service": "file-metadata-service",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "uploadsAvailable": true,
  "version": "1.0.0"
}
```

## Features

### Security
- Path traversal protection
- Files must be within uploads directory
- Base64-encoded IDs for secure file access

### File Operations
- **Metadata Only**: Get file information without loading content
- **Download**: Get files with download headers
- **Stream**: Get files with inline viewing headers
- **Search**: Case-insensitive partial name matching
- **Delete**: Safe file removal

### Directory Support
- Recursive directory scanning
- Subdirectory support
- Relative path tracking

## Use Cases

1. **File Browser**: List all uploaded files with metadata
2. **File Preview**: Stream files for browser viewing
3. **File Download**: Download specific files by name
4. **File Search**: Find files by partial name match
5. **File Management**: Delete unwanted files
6. **Statistics**: Monitor uploads directory usage

## Error Handling

All endpoints return appropriate HTTP status codes:
- `200`: Success
- `400`: Bad request (missing parameters)
- `404`: File not found
- `500`: Internal server error

Error responses include:
```json
{
  "success": false,
  "message": "Error description"
}
```

## Notes

- File IDs are base64-encoded file paths for security
- All file operations are within the uploads directory only
- Search is case-insensitive and matches partial filenames
- File streaming supports inline browser viewing
- Download endpoints set appropriate content headers