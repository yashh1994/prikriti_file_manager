# API Testing Guide

This guide helps you test the Prikriti File Manager API endpoints.

## Prerequisites
- Backend server running on `http://localhost:3000`
- A folder with test files

---

## Testing with PowerShell

### 1. Health Check

```powershell
Invoke-RestMethod -Uri "http://localhost:3000/health" -Method Get
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Prikriti File Manager API is running",
  "timestamp": "2025-10-15T10:30:00.000Z",
  "environment": "development"
}
```

---

### 2. List Files from Folder

```powershell
$body = @{
    folderPath = "C:\Users\YourName\Documents\TestFolder"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/api/files/list-folder" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Found 5 files",
  "files": [
    {
      "id": "uuid-here",
      "name": "document.pdf",
      "originalName": "document.pdf",
      "extension": "pdf",
      "size": 1048576,
      "path": "C:\\Users\\...\\document.pdf",
      "mimetype": "application/pdf",
      "createdAt": "2025-10-15T10:00:00.000Z",
      "modifiedAt": "2025-10-15T12:00:00.000Z"
    }
  ],
  "totalFiles": 5,
  "totalSize": 5242880
}
```

---

### 3. Upload Files

```powershell
$files = @(
    @{
        id = "test-uuid-1"
        name = "test.txt"
        originalName = "test.txt"
        extension = "txt"
        size = 1024
        path = "C:\path\to\test.txt"
        createdAt = "2025-10-15T10:00:00Z"
        modifiedAt = "2025-10-15T10:00:00Z"
    }
)

$body = @{
    files = $files
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Uri "http://localhost:3000/api/files/upload" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Batch upload completed. 1 files uploaded successfully.",
  "results": [
    {
      "id": "test-uuid-1",
      "originalName": "test.txt",
      "newName": "test.txt",
      "status": "done",
      "finalPath": "uploads\\test.txt",
      "size": 1024,
      "extension": "txt"
    }
  ],
  "summary": {
    "total": 1,
    "done": 1,
    "failed": 0,
    "duplicate": 0,
    "pending": 0
  }
}
```

---

### 4. Get Upload Statistics

```powershell
Invoke-RestMethod -Uri "http://localhost:3000/api/files/stats" -Method Get
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Upload statistics retrieved successfully",
  "data": {
    "totalFiles": 10,
    "totalSize": 10485760,
    "files": [
      {
        "name": "test.txt",
        "size": 1024,
        "uploadedAt": "2025-10-15T14:30:00.000Z"
      }
    ]
  }
}
```

---

## Testing with cURL

### 1. Health Check
```bash
curl http://localhost:3000/health
```

### 2. List Files from Folder
```bash
curl -X POST http://localhost:3000/api/files/list-folder \
  -H "Content-Type: application/json" \
  -d '{"folderPath":"C:\\Users\\YourName\\Documents\\TestFolder"}'
```

### 3. Upload Files
```bash
curl -X POST http://localhost:3000/api/files/upload \
  -H "Content-Type: application/json" \
  -d '{
    "files": [
      {
        "id": "test-uuid-1",
        "name": "test.txt",
        "originalName": "test.txt",
        "extension": "txt",
        "size": 1024,
        "path": "C:\\path\\to\\test.txt",
        "createdAt": "2025-10-15T10:00:00Z",
        "modifiedAt": "2025-10-15T10:00:00Z"
      }
    ]
  }'
```

### 4. Get Statistics
```bash
curl http://localhost:3000/api/files/stats
```

---

## Testing with Postman

### Setup
1. Open Postman
2. Create a new Collection: "Prikriti File Manager"
3. Set base URL variable: `{{baseUrl}}` = `http://localhost:3000`

### Request 1: Health Check
- **Method**: GET
- **URL**: `{{baseUrl}}/health`
- **Headers**: None needed

### Request 2: List Files
- **Method**: POST
- **URL**: `{{baseUrl}}/api/files/list-folder`
- **Headers**: 
  - Content-Type: application/json
- **Body** (raw JSON):
```json
{
  "folderPath": "C:\\Users\\YourName\\Documents\\TestFolder"
}
```

### Request 3: Upload Files
- **Method**: POST
- **URL**: `{{baseUrl}}/api/files/upload`
- **Headers**: 
  - Content-Type: application/json
- **Body** (raw JSON):
```json
{
  "files": [
    {
      "id": "uuid-test",
      "name": "test.txt",
      "originalName": "test.txt",
      "extension": "txt",
      "size": 1024,
      "path": "C:\\full\\path\\to\\test.txt",
      "createdAt": "2025-10-15T10:00:00Z",
      "modifiedAt": "2025-10-15T10:00:00Z"
    }
  ]
}
```

### Request 4: Get Stats
- **Method**: GET
- **URL**: `{{baseUrl}}/api/files/stats`
- **Headers**: None needed

---

## Test Scenarios

### Scenario 1: Normal Upload Flow
1. Call list-folder endpoint with a valid folder
2. Save the response files array
3. Call upload endpoint with those files
4. Verify all files have status "done"
5. Call stats endpoint to see uploaded files

### Scenario 2: Duplicate Detection
1. Upload files once (should succeed)
2. Upload same files again (should show duplicate)
3. Check that duplicate files have status "duplicate"

### Scenario 3: File Rename
1. List files from folder
2. Modify file objects to include "newName" field
3. Upload with new names
4. Verify files in uploads folder have new names

### Scenario 4: Error Handling
1. Try list-folder with invalid path
2. Try upload with non-existent file path
3. Verify error responses

---

## Response Status Codes

| Code | Meaning | When |
|------|---------|------|
| 200 | Success | Request completed successfully |
| 400 | Bad Request | Missing or invalid parameters |
| 404 | Not Found | Endpoint doesn't exist |
| 500 | Server Error | Backend error occurred |

---

## Common Test Cases

### Test Invalid Folder Path
```powershell
$body = @{
    folderPath = "Z:\NonExistent\Path"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/api/files/list-folder" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body
```

Should return error.

### Test File with Special Characters
```powershell
# Create a file with special characters in name
$files = @(
    @{
        id = "test-1"
        name = "my<file>name?.txt"
        originalName = "my<file>name?.txt"
        newName = "my_file_name_.txt"  # Will be sanitized
        extension = "txt"
        size = 100
        path = "C:\path\to\actual\file.txt"
        createdAt = "2025-10-15T10:00:00Z"
        modifiedAt = "2025-10-15T10:00:00Z"
    }
)
```

Should sanitize to valid filename.

---

## Debugging Tips

### Enable Detailed Logging
Backend logs are in `Backend/logs/` folder

### Check Request/Response in Browser
Open DevTools → Network tab when using the Flutter app

### Verify File Paths
Use PowerShell to check if files exist:
```powershell
Test-Path "C:\path\to\file.txt"
```

### Monitor Server Logs
Watch backend terminal for detailed error messages

---

## Performance Testing

### Test with Multiple Files
Create a test script with 100+ files to test performance.

### Test with Large Files
Upload files of various sizes (1MB, 10MB, 50MB).

### Test Concurrent Uploads
Use multiple Postman tabs to upload simultaneously.

---

## Integration Testing

Create a test workflow:
```powershell
# 1. Start with fresh uploads folder
Remove-Item "Backend\uploads\*" -Force

# 2. List files
$files = Invoke-RestMethod -Uri "http://localhost:3000/api/files/list-folder" `
    -Method Post -ContentType "application/json" `
    -Body '{"folderPath":"C:\\TestFolder"}'

# 3. Upload files
Invoke-RestMethod -Uri "http://localhost:3000/api/files/upload" `
    -Method Post -ContentType "application/json" `
    -Body ($files | ConvertTo-Json)

# 4. Verify stats
Invoke-RestMethod -Uri "http://localhost:3000/api/files/stats" -Method Get
```

---

## Expected File Structure After Upload

```
Backend/
└── uploads/
    ├── document.pdf
    ├── image.jpg
    ├── data_1729012345.csv  (timestamp added for conflict)
    └── report.docx
```

---

## Security Testing

### Test Path Traversal (Should Fail)
```json
{
  "folderPath": "../../etc/passwd"
}
```

### Test Invalid File Types (Should Validate)
Upload executable files if they're not in allowed extensions.

---

## Cleanup After Testing

```powershell
# Clear uploads folder
Remove-Item "Backend\uploads\*" -Force -Recurse

# Or keep for verification
```

---

This guide provides comprehensive API testing coverage. Use it to verify all functionality works correctly!
