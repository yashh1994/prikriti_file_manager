# Prikriti File Manager - Complete System Documentation

## Overview

The Prikriti File Manager is a full-stack file management system consisting of:
- **Backend**: Node.js/Express API with TypeScript
- **Frontend**: Flutter desktop/web application

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      User Interface                          │
│                  (Flutter Dashboard)                         │
│  - Folder Selection                                          │
│  - File List Display                                         │
│  - Rename Files                                              │
│  - Upload Management                                         │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ HTTP/REST API
                     │
┌────────────────────▼────────────────────────────────────────┐
│                   Backend API Server                         │
│                (Node.js + Express)                           │
│                                                              │
│  Controllers:                                                │
│  ├── List Files from Folder                                 │
│  ├── Rename Files                                            │
│  ├── Upload Files (Batch)                                    │
│  └── Get Statistics                                          │
│                                                              │
│  Services:                                                   │
│  ├── File Utils Service                                      │
│  │   ├── List files from directory                          │
│  │   ├── Calculate MD5 hash                                 │
│  │   ├── Detect duplicates                                  │
│  │   └── Generate unique filenames                          │
│  │                                                           │
│  └── Upload Service                                          │
│      ├── Process batch uploads                              │
│      ├── Handle name conflicts                              │
│      └── Track upload status                                │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ File System Operations
                     │
┌────────────────────▼────────────────────────────────────────┐
│                  File System                                 │
│                                                              │
│  Source Folder ──────────┐                                  │
│  (Selected by user)      │                                  │
│                          │                                  │
│  Uploads Folder ◄────────┘                                  │
│  (Backend/uploads)                                           │
└──────────────────────────────────────────────────────────────┘
```

## Features

### 1. Folder Selection & File Loading
- User selects a folder through Flutter's file picker
- Backend scans the folder and returns all file metadata
- File details include: name, extension, size, creation date, etc.

### 2. File Renaming
- Users can rename files before uploading
- Invalid characters are automatically sanitized
- File extensions are preserved

### 3. Batch Upload
- Upload multiple files simultaneously
- Each file processed independently
- Status tracking for each file

### 4. Duplicate Detection
**Two types of duplicate handling:**

#### a) Content Duplicate (Same File Data)
- System calculates MD5 hash of file content
- Compares with existing files in uploads folder
- If match found → Status: DUPLICATE (file NOT uploaded)
- Error message shows which existing file is the duplicate

#### b) Name Conflict (Same Filename)
- Different content, same name
- System appends timestamp to filename
- Format: `filename_1729012345.ext`
- Status: DONE (file uploaded with new name)

### 5. Upload Status Tracking

| Status | Description | Icon |
|--------|-------------|------|
| **PENDING** | File queued for upload | ⚪ Schedule |
| **DONE** | Successfully uploaded | 🟢 Check Circle |
| **FAILED** | Upload failed with error | 🔴 Error |
| **DUPLICATE** | Identical file exists | 🟠 Content Copy |

### 6. Error Handling

**Backend Errors:**
- Source file not found
- Permission denied
- Disk space issues
- Invalid file paths

**Frontend Errors:**
- API connection failures
- Invalid folder selection
- Network timeouts
- Response parsing errors

## API Endpoints

### 1. List Files from Folder
**POST** `/api/files/list-folder`

```json
// Request
{
  "folderPath": "C:\\Users\\Documents\\MyFiles"
}

// Response
{
  "success": true,
  "message": "Found 15 files",
  "files": [
    {
      "id": "uuid-here",
      "name": "document.pdf",
      "originalName": "document.pdf",
      "extension": "pdf",
      "size": 1048576,
      "path": "C:\\Users\\Documents\\MyFiles\\document.pdf",
      "mimetype": "application/pdf",
      "createdAt": "2025-10-15T10:30:00Z",
      "modifiedAt": "2025-10-15T12:00:00Z"
    }
  ],
  "totalFiles": 15,
  "totalSize": 52428800
}
```

### 2. Rename Files
**PUT** `/api/files/rename`

```json
// Request
{
  "files": [
    {
      "id": "uuid-here",
      "name": "old_name.pdf",
      "newName": "new_name.pdf",
      "extension": "pdf",
      "size": 1048576,
      "path": "C:\\path\\old_name.pdf"
    }
  ]
}

// Response
{
  "success": true,
  "message": "Files renamed successfully",
  "files": [/* updated files */]
}
```

### 3. Upload Files
**POST** `/api/files/upload`

```json
// Request
{
  "files": [
    {
      "id": "uuid-here",
      "name": "document.pdf",
      "newName": "renamed_document.pdf",
      "extension": "pdf",
      "size": 1048576,
      "path": "C:\\source\\document.pdf"
    }
  ]
}

// Response
{
  "success": true,
  "message": "Batch upload completed. 2 files uploaded successfully.",
  "results": [
    {
      "id": "uuid-here",
      "originalName": "document.pdf",
      "newName": "renamed_document.pdf",
      "status": "done",
      "finalPath": "uploads\\renamed_document.pdf",
      "size": 1048576,
      "extension": "pdf"
    },
    {
      "id": "uuid-2",
      "originalName": "image.jpg",
      "newName": "image.jpg",
      "status": "duplicate",
      "error": "Duplicate file found: existing_image.jpg",
      "finalPath": "uploads\\existing_image.jpg"
    }
  ],
  "summary": {
    "total": 10,
    "done": 7,
    "failed": 1,
    "duplicate": 2,
    "pending": 0
  }
}
```

### 4. Get Statistics
**GET** `/api/files/stats`

```json
// Response
{
  "success": true,
  "message": "Upload statistics retrieved successfully",
  "data": {
    "totalFiles": 145,
    "totalSize": 524288000,
    "files": [
      {
        "name": "document.pdf",
        "size": 1048576,
        "uploadedAt": "2025-10-15T14:30:00Z"
      }
    ]
  }
}
```

## File Naming Rules

### Valid Characters
- Letters: a-z, A-Z
- Numbers: 0-9
- Special: _ (underscore), - (hyphen), . (dot)
- Spaces: allowed

### Invalid Characters (Auto-sanitized)
- `< > : " | ? *`
- Control characters (0x00-0x1F)
- These are replaced with underscore `_`

### Examples
| Original Name | Sanitized Name |
|---------------|----------------|
| `my<file>.pdf` | `my_file_.pdf` |
| `data:2025.xlsx` | `data_2025.xlsx` |
| `report?.doc` | `report_.doc` |

## Duplicate Handling Workflow

```
┌─────────────────────────┐
│  File Upload Request    │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Calculate MD5 Hash     │
│  of source file         │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Search uploads folder  │
│  for files with same    │
│  hash                   │
└───────────┬─────────────┘
            │
     ┌──────┴──────┐
     │             │
  Match?        No Match
     │             │
     ▼             ▼
┌─────────┐   ┌──────────────────┐
│ SKIP    │   │ Check if file    │
│ Upload  │   │ with same name   │
│         │   │ exists           │
│ Status: │   └────────┬─────────┘
│DUPLICATE│            │
└─────────┘     ┌──────┴──────┐
                │             │
             Exists        No
                │             │
                ▼             ▼
         ┌──────────┐   ┌──────────┐
         │ Add      │   │ Upload   │
         │timestamp │   │ as-is    │
         │to name   │   │          │
         │          │   │ Status:  │
         │ Status:  │   │ DONE     │
         │ DONE     │   └──────────┘
         └──────────┘
```

## Frontend Dashboard Components

### 1. Summary Cards
- **Total Files**: Count of all loaded files
- **Done**: Successfully uploaded files
- **Failed**: Files with upload errors
- **Duplicate**: Files skipped due to duplication
- **Pending**: Files waiting to upload

### 2. File List
- File icon based on extension
- File name (editable inline)
- File size (human-readable)
- File extension
- Status indicator
- Action buttons (Edit, Delete)

### 3. Action Buttons
- **Select Folder**: Choose source folder
- **Clear All**: Remove all files from list
- **Upload Files**: Start batch upload

## State Management

### Provider Pattern
```dart
FileManagerProvider
├── files: List<FileModel>
├── isLoading: bool
├── isUploading: bool
├── selectedFolderPath: String?
├── errorMessage: String?
├── lastUploadResponse: BatchUploadResponse?
├── uploadStats: Map<String, dynamic>?
│
├── selectAndLoadFolder()
├── updateFileName(fileId, newName)
├── uploadFiles()
├── fetchUploadStats()
└── getUploadSummary()
```

## Setup & Installation

### Backend Setup

```bash
cd Backend
npm install
npm run dev
```

**Environment Variables (.env):**
```env
PORT=3000
NODE_ENV=development
CORS_ORIGIN=*
UPLOAD_PATH=uploads
MAX_FILE_SIZE=104857600
```

### Frontend Setup

```bash
cd Frontend/app
flutter pub get
flutter run -d windows
```

## Testing the System

### 1. Start Backend
```bash
cd Backend
npm run dev
```
Expected: Server running on port 3000

### 2. Run Flutter App
```bash
cd Frontend/app
flutter run -d windows
```

### 3. Test Workflow
1. Click "Select Folder"
2. Choose a folder with various files
3. Review loaded files
4. Rename some files (optional)
5. Click "Upload Files"
6. Verify upload results

### 4. Test Duplicate Detection
1. Upload files once
2. Try uploading the same files again
3. Should show "DUPLICATE" status

### 5. Test Name Conflicts
1. Create two different files with same name
2. Upload first file
3. Upload second file
4. Second file should have timestamp appended

## Performance Considerations

### Backend
- Async file operations
- Stream-based hash calculation
- Efficient memory usage for large files

### Frontend
- Lazy loading for large file lists
- Optimized rebuilds with Provider
- Debounced API calls

## Security Considerations

### Backend
- Path traversal prevention
- File type validation
- Size limits enforced
- Sanitized filenames

### Frontend
- Input validation
- Error boundary handling
- Secure API communication

## Future Enhancements

1. **Authentication**: User login and authorization
2. **File Preview**: Preview images and documents
3. **Progress Tracking**: Real-time upload progress
4. **Drag & Drop**: Drag files into the app
5. **Filters**: Filter files by type, size, status
6. **Search**: Search files by name
7. **Sorting**: Sort by name, size, date
8. **Cloud Storage**: S3, Google Drive integration
9. **File Compression**: Compress before upload
10. **Metadata Editing**: Edit file metadata

## Troubleshooting

### Backend Issues

**Problem**: Files not uploading
- Check uploads folder permissions
- Verify disk space
- Check file paths

**Problem**: Duplicate detection not working
- Clear uploads folder and retry
- Check hash calculation

### Frontend Issues

**Problem**: Cannot select folder
- Check platform permissions
- Verify file_picker plugin

**Problem**: API connection failed
- Ensure backend is running
- Check CORS configuration
- Verify API URL in code

## Support

For issues or questions:
- Check logs in `Backend/logs`
- Review API responses
- Check console output

## License

ISC License - See LICENSE file for details
