# File Manager Backend - Quick Start Guide

## ✅ Installation Complete!

Your file manager backend is fully set up and ready to use.

## 🚀 Running the Server

### Development Mode (with hot reload)
```bash
npm run dev
```

### Production Mode
```bash
npm run build
npm start
```

The server will start on **http://localhost:3000**

## 📋 Features Implemented

✅ **Folder Selection & File Listing**
- Select any folder and load all files with complete metadata
- Returns: name, extension, size, creation/modification dates, MIME type

✅ **File Renaming**
- Rename files before upload
- Automatic sanitization of invalid characters
- Extension preservation

✅ **Batch Upload with Status Tracking**
- Upload multiple files at once
- Real-time status for each file: `pending`, `done`, `failed`, `duplicate`
- Comprehensive upload summary

✅ **Duplicate Detection**
- **Content-based**: MD5 hash comparison prevents re-uploading identical files
- **Name-based**: Automatic timestamp suffix for name conflicts
- Example: `report.docx` → `report_1729000000000.docx`

✅ **Error Handling**
- File not found errors
- Invalid path errors
- Permission errors
- Copy/verification failures

✅ **Upload Statistics**
- Total files uploaded
- Total storage size
- Individual file details with upload timestamps

## 📡 API Endpoints

### 1. Health Check
```
GET /health
```

### 2. List Files from Folder
```
POST /api/files/list-folder
Body: { "folderPath": "C:\\Users\\Documents\\MyFiles" }
```

### 3. Rename Files (Optional, before upload)
```
PUT /api/files/rename
Body: { "files": [ /* array of files with newName field */ ] }
```

### 4. Upload Files
```
POST /api/files/upload
Body: { "files": [ /* array of files from list-folder */ ] }
```

### 5. Get Upload Statistics
```
GET /api/files/stats
```

## 🧪 Testing the API

### Quick Test (PowerShell)

1. **Create test files:**
```powershell
New-Item -ItemType Directory -Force -Path "E:\TestFiles"
"Test content 1" | Out-File "E:\TestFiles\document1.txt"
"Test content 2" | Out-File "E:\TestFiles\document2.txt"
"Sample PDF" | Out-File "E:\TestFiles\report.pdf"
```

2. **Test health endpoint:**
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/health"
```

3. **List files:**
```powershell
$listBody = @{ folderPath = "E:\TestFiles" } | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:3000/api/files/list-folder" `
    -Method POST `
    -ContentType "application/json" `
    -Body $listBody
```

4. **Upload files:**
```powershell
# Get files list first
$files = (Invoke-RestMethod -Uri "http://localhost:3000/api/files/list-folder" `
    -Method POST `
    -ContentType "application/json" `
    -Body (@{ folderPath = "E:\TestFiles" } | ConvertTo-Json)).files

# Upload them
$uploadBody = @{ files = $files } | ConvertTo-Json -Depth 10
Invoke-RestMethod -Uri "http://localhost:3000/api/files/upload" `
    -Method POST `
    -ContentType "application/json" `
    -Body $uploadBody
```

5. **Check upload stats:**
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/api/files/stats"
```

## 📂 Project Structure

```
Backend/
├── src/
│   ├── config/
│   │   └── config.ts              # Configuration management
│   ├── controllers/
│   │   └── file.controller.ts     # API request handlers
│   ├── middleware/
│   │   ├── error.middleware.ts    # Error handling
│   │   └── logger.middleware.ts   # Request logging
│   ├── routes/
│   │   └── file.routes.ts         # API routes
│   ├── services/
│   │   ├── file-utils.service.ts  # File operations utilities
│   │   └── upload.service.ts      # Upload logic & status tracking
│   ├── types/
│   │   └── file.types.ts          # TypeScript interfaces
│   └── index.ts                   # Application entry point
├── dist/                          # Compiled JavaScript
├── uploads/                       # File upload destination
├── logs/                          # Application logs
├── .env                           # Environment variables
├── package.json
├── tsconfig.json
├── API_DOCUMENTATION.md           # Detailed API docs
└── TEST_ENDPOINTS.md              # Testing guide
```

## 🔧 Configuration

Edit `.env` file to customize:

```env
# Server
PORT=3000
NODE_ENV=development

# Upload Settings
UPLOAD_PATH=uploads
MAX_FILE_SIZE=104857600  # 100MB
ALLOWED_EXTENSIONS=jpg,jpeg,png,gif,pdf,doc,docx,txt,zip...

# CORS
CORS_ORIGIN=*

# Rate Limiting
RATE_LIMIT_WINDOW=900000  # 15 minutes
RATE_LIMIT_MAX=100        # Max requests
```

## 📖 Complete Workflow Example

1. User selects a folder on their computer
2. Frontend calls `POST /api/files/list-folder` with folder path
3. Backend returns list of all files with metadata
4. User optionally renames files in the UI
5. User clicks "Upload" button
6. Frontend calls `POST /api/files/upload` with file list
7. Backend processes each file:
   - Checks if file exists at source
   - Validates filename
   - Checks for duplicate content (hash)
   - Handles name conflicts (timestamp)
   - Copies file to uploads folder
   - Returns status for each file
8. Frontend displays upload results with status indicators

## 🎯 Upload Status Flow

```
PENDING  → File queued for upload
   ↓
DONE     → Successfully uploaded
FAILED   → Upload error (see error message)
DUPLICATE→ File with same content already exists
```

## 🛡️ Security Features

- Helmet.js for security headers
- CORS configuration
- Rate limiting
- Input validation & sanitization
- File type restrictions
- Size limits
- Error message sanitization

## 📝 Available Scripts

```bash
npm run dev         # Development server with hot reload
npm run build       # Compile TypeScript to JavaScript
npm start           # Run production build
npm test            # Run tests
npm run lint        # Check code quality
npm run lint:fix    # Fix linting issues
npm run format      # Format code with Prettier
npm run clean       # Remove build artifacts
```

## 🐛 Troubleshooting

### Server won't start
- Check if port 3000 is available
- Verify `.env` file exists
- Run `npm install` to ensure dependencies

### Upload fails
- Check `uploads/` folder permissions
- Verify source folder path is accessible
- Check file size limits in `.env`

### Duplicate detection not working
- Ensure files have different content
- Check hash calculation (MD5)

## 📚 Documentation

- **API_DOCUMENTATION.md** - Complete API reference
- **TEST_ENDPOINTS.md** - Testing examples
- **README.md** - Main project documentation

## 🎉 Success!

Your file manager backend is fully functional with:
- ✅ Folder browsing
- ✅ File metadata extraction  
- ✅ Renaming support
- ✅ Duplicate detection
- ✅ Status tracking
- ✅ Error handling
- ✅ Statistics

Happy coding! 🚀
