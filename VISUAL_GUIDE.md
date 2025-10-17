# 🎨 Prikriti File Manager - Visual Guide

A visual walkthrough of the system features and functionality.

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        PRIKRITI FILE MANAGER                        │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                          FRONTEND (Flutter)                         │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                     Dashboard Screen                          │  │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐        │  │
│  │  │  Total   │ │   Done   │ │  Failed  │ │ Duplicate│        │  │
│  │  │  Files   │ │  Files   │ │  Files   │ │  Files   │        │  │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘        │  │
│  │                                                               │  │
│  │  ┌───────────────────────────────────────────────────────┐  │  │
│  │  │  📄 file1.pdf        ✅ DONE        [✏️] [🗑️]         │  │  │
│  │  │  📄 file2.doc        🟠 DUPLICATE   [✏️] [🗑️]         │  │  │
│  │  │  📄 file3.xlsx       ⚪ PENDING     [✏️] [🗑️]         │  │  │
│  │  └───────────────────────────────────────────────────────┘  │  │
│  │                                                               │  │
│  │  [  Clear All  ]           [  Upload Files  ]                │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  State Management: Provider Pattern                                │
│  API Client: HTTP Package                                          │
└───────────────────────────┬─────────────────────────────────────────┘
                            │
                            │ REST API (JSON)
                            │ HTTP/HTTPS
                            │
┌───────────────────────────▼─────────────────────────────────────────┐
│                      BACKEND (Node.js + Express)                    │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                    API Endpoints                              │  │
│  │  POST   /api/files/list-folder  →  List files from folder    │  │
│  │  PUT    /api/files/rename       →  Rename files              │  │
│  │  POST   /api/files/upload       →  Upload files              │  │
│  │  GET    /api/files/stats        →  Get statistics            │  │
│  │  GET    /health                 →  Health check              │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                    Services Layer                             │  │
│  │  • FileUtilsService  → File operations, hash calculation     │  │
│  │  • UploadService     → Upload logic, duplicate detection     │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  Middleware: CORS, Helmet, Compression, Error Handling             │
└───────────────────────────┬─────────────────────────────────────────┘
                            │
                            │ File System I/O
                            │
┌───────────────────────────▼─────────────────────────────────────────┐
│                         FILE SYSTEM                                 │
│  ┌───────────────────┐            ┌────────────────────┐           │
│  │  Source Folder    │            │  Uploads Folder    │           │
│  │  (User Selected)  │  ────────> │  (Backend/uploads) │           │
│  │                   │            │                    │           │
│  │  • file1.pdf      │            │  • file1.pdf       │           │
│  │  • file2.doc      │            │  • file3.xlsx      │           │
│  │  • file3.xlsx     │            │  • renamed_file.doc│           │
│  └───────────────────┘            └────────────────────┘           │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📊 File Upload Flow

```
┌──────────────────────────────────────────────────────────────────┐
│  STEP 1: FOLDER SELECTION                                        │
└──────────────────────────────────────────────────────────────────┘

   User clicks "Select Folder"
   │
   ├──► Native file picker opens
   │
   ├──► User selects folder: C:\Documents\MyFiles
   │
   └──► Flutter sends request to backend

┌──────────────────────────────────────────────────────────────────┐
│  STEP 2: FILE LOADING                                            │
└──────────────────────────────────────────────────────────────────┘

   POST /api/files/list-folder
   Body: { "folderPath": "C:\\Documents\\MyFiles" }
   │
   ├──► Backend scans folder
   │
   ├──► Collects file metadata:
   │    • Name, Extension, Size
   │    • Created/Modified dates
   │    • MIME type, Path
   │
   └──► Returns array of files with metadata

┌──────────────────────────────────────────────────────────────────┐
│  STEP 3: DISPLAY & EDIT                                          │
└──────────────────────────────────────────────────────────────────┘

   Dashboard displays files
   │
   ├──► Summary cards show counts
   │
   ├──► File list shows each file
   │
   ├──► User can rename files (optional)
   │
   └──► User can remove files (optional)

┌──────────────────────────────────────────────────────────────────┐
│  STEP 4: UPLOAD INITIATION                                       │
└──────────────────────────────────────────────────────────────────┘

   User clicks "Upload Files"
   │
   ├──► Confirmation dialog appears
   │
   ├──► User confirms
   │
   └──► POST request sent to backend

┌──────────────────────────────────────────────────────────────────┐
│  STEP 5: BACKEND PROCESSING                                      │
└──────────────────────────────────────────────────────────────────┘

   For each file:
   │
   ├──► Calculate MD5 hash
   │    │
   │    └──► Check if hash exists in uploads folder
   │         │
   │         ├──► MATCH FOUND?
   │         │    │
   │         │    ├──► YES → Status: DUPLICATE ❌ Skip upload
   │         │    │
   │         │    └──► NO → Continue to next step
   │
   ├──► Check filename in uploads folder
   │    │
   │    ├──► NAME EXISTS?
   │    │    │
   │    │    ├──► YES → Add timestamp: file_1729012345.ext
   │    │    │
   │    │    └──► NO → Keep original name
   │
   ├──► Copy file to uploads folder
   │
   └──► Return result with status

┌──────────────────────────────────────────────────────────────────┐
│  STEP 6: DISPLAY RESULTS                                         │
└──────────────────────────────────────────────────────────────────┘

   Results displayed in UI
   │
   ├──► Status icons updated (✅ 🟠 ❌ ⚪)
   │
   ├──► Summary cards refreshed
   │
   ├──► Success dialog shown
   │
   └──► User can view individual file status
```

---

## 🎯 Status Indicator System

```
┌─────────────────────────────────────────────────────────────────┐
│                         FILE STATUSES                           │
└─────────────────────────────────────────────────────────────────┘

┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│   PENDING    │  │     DONE     │  │    FAILED    │  │  DUPLICATE   │
│      ⚪      │  │      ✅      │  │      ❌      │  │      🟠      │
│              │  │              │  │              │  │              │
│  Waiting to  │  │ Successfully │  │    Upload    │  │  Same file   │
│    upload    │  │   uploaded   │  │    error     │  │    exists    │
│              │  │              │  │              │  │              │
│    Grey      │  │    Green     │  │     Red      │  │    Orange    │
└──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘
```

---

## 📋 Dashboard Layout

```
╔═══════════════════════════════════════════════════════════════════╗
║              PRIKRITI FILE MANAGER - DASHBOARD                    ║
╠═══════════════════════════════════════════════════════════════════╣
║  📁 Folder: C:\Users\Documents\Files          [ Select Folder ]   ║
╠═══════════════════════════════════════════════════════════════════╣
║  ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐          ║
║  │ Total │  │ Done  │  │Failed │  │ Dupl. │  │Pending│          ║
║  │  📄   │  │  ✅   │  │  ❌   │  │  🟠   │  │  ⏳   │          ║
║  │  15   │  │  12   │  │   1   │  │   2   │  │   0   │          ║
║  └───────┘  └───────┘  └───────┘  └───────┘  └───────┘          ║
╠═══════════════════════════════════════════════════════════════════╣
║  15 file(s)                              Total: 25.5 MB           ║
╠═══════════════════════════════════════════════════════════════════╣
║  ┌─────────────────────────────────────────────────────────────┐ ║
║  │ 📄 document.pdf                    ✅   [✏️] [🗑️]         │ ║
║  │    Size: 2.5 MB | Type: .pdf                               │ ║
║  ├─────────────────────────────────────────────────────────────┤ ║
║  │ 📊 spreadsheet.xlsx                ✅   [✏️] [🗑️]         │ ║
║  │    Size: 1.8 MB | Type: .xlsx                              │ ║
║  ├─────────────────────────────────────────────────────────────┤ ║
║  │ 🖼️ photo.jpg                       🟠   [✏️] [🗑️]         │ ║
║  │    Size: 3.2 MB | Type: .jpg                               │ ║
║  │    Error: Duplicate file found: existing_photo.jpg         │ ║
║  ├─────────────────────────────────────────────────────────────┤ ║
║  │ 📝 notes.txt                       ❌   [✏️] [🗑️]         │ ║
║  │    Size: 15 KB | Type: .txt                                │ ║
║  │    Error: Source file not found                            │ ║
║  ├─────────────────────────────────────────────────────────────┤ ║
║  │ 🎵 music.mp3                       ⚪   [✏️] [🗑️]         │ ║
║  │    Size: 4.5 MB | Type: .mp3                               │ ║
║  └─────────────────────────────────────────────────────────────┘ ║
╠═══════════════════════════════════════════════════════════════════╣
║  [  Clear All  ]              [     Upload Files (15)     ]       ║
╚═══════════════════════════════════════════════════════════════════╝
```

---

## 🔄 Duplicate Detection Logic

```
┌─────────────────────────────────────────────────────────────────┐
│              DUPLICATE DETECTION ALGORITHM                      │
└─────────────────────────────────────────────────────────────────┘

FILE: photo.jpg
SIZE: 3.2 MB
PATH: C:\Users\Photos\photo.jpg

                    ▼
         ┌──────────────────────┐
         │  Calculate MD5 Hash  │
         │  Hash: a1b2c3d4e5f6  │
         └──────────┬───────────┘
                    │
                    ▼
         ┌──────────────────────┐
         │  Scan uploads folder │
         │  for existing files  │
         └──────────┬───────────┘
                    │
         ┌──────────▼───────────┐
         │  For each file in    │
         │  uploads folder:     │
         │  Calculate its hash  │
         └──────────┬───────────┘
                    │
         ┌──────────▼───────────────────┐
         │  Compare hashes              │
         └──────────┬───────────────────┘
                    │
         ┌──────────▼───────────┐
         │  Hash Match Found?   │
         └──────────┬───────────┘
                    │
         ┌──────────┴───────────┐
         │                      │
       YES                     NO
         │                      │
         ▼                      ▼
┌────────────────┐    ┌──────────────────┐
│  Status:       │    │  Check if name   │
│  DUPLICATE     │    │  exists in       │
│                │    │  uploads folder  │
│  Skip upload   │    └────────┬─────────┘
│                │             │
│  Return error  │    ┌────────▼─────────┐
│  message       │    │  Name exists?    │
└────────────────┘    └────────┬─────────┘
                               │
                      ┌────────┴────────┐
                      │                 │
                    YES                NO
                      │                 │
                      ▼                 ▼
              ┌───────────────┐  ┌──────────────┐
              │ Add timestamp │  │  Use original│
              │ to filename   │  │  filename    │
              │               │  │              │
              │ photo_        │  │  photo.jpg   │
              │ 1729012345.jpg│  │              │
              └───────┬───────┘  └──────┬───────┘
                      │                 │
                      └────────┬────────┘
                               │
                               ▼
                      ┌────────────────┐
                      │  Copy file to  │
                      │ uploads folder │
                      │                │
                      │  Status: DONE  │
                      └────────────────┘
```

---

## 🎨 File Type Icons

```
┌─────────────────────────────────────────────────────────────────┐
│                    FILE TYPE ICON MAPPING                       │
└─────────────────────────────────────────────────────────────────┘

┌──────────────┬──────────────┬──────────────────────────────────┐
│   Icon       │   Extension  │   Description                    │
├──────────────┼──────────────┼──────────────────────────────────┤
│   🖼️ Image   │ jpg,jpeg,png │   Image files                    │
│              │ gif,bmp      │                                  │
├──────────────┼──────────────┼──────────────────────────────────┤
│   📄 PDF     │ pdf          │   PDF documents                  │
├──────────────┼──────────────┼──────────────────────────────────┤
│   📝 Doc     │ doc,docx     │   Word documents                 │
├──────────────┼──────────────┼──────────────────────────────────┤
│   📊 Sheet   │ xls,xlsx,csv │   Spreadsheets                   │
├──────────────┼──────────────┼──────────────────────────────────┤
│   📦 Archive │ zip,rar,7z   │   Compressed files               │
├──────────────┼──────────────┼──────────────────────────────────┤
│   🎬 Video   │ mp4,avi,mov  │   Video files                    │
│              │ mkv          │                                  │
├──────────────┼──────────────┼──────────────────────────────────┤
│   🎵 Audio   │ mp3,wav,flac │   Audio files                    │
├──────────────┼──────────────┼──────────────────────────────────┤
│   📄 File    │ (others)     │   Generic file                   │
└──────────────┴──────────────┴──────────────────────────────────┘
```

---

## 📈 Upload Summary Dialog

```
╔═══════════════════════════════════════════════╗
║          Upload Results                       ║
╠═══════════════════════════════════════════════╣
║                                               ║
║  Batch upload completed.                      ║
║  12 files uploaded successfully.              ║
║                                               ║
║  ┌─────────────────────────────────────────┐ ║
║  │ ● Total        15                       │ ║
║  │ ● Done         12                       │ ║
║  │ ● Failed        1                       │ ║
║  │ ● Duplicate     2                       │ ║
║  │ ● Pending       0                       │ ║
║  └─────────────────────────────────────────┘ ║
║                                               ║
║                        [  OK  ]               ║
╚═══════════════════════════════════════════════╝
```

---

## 🔧 Backend API Structure

```
┌─────────────────────────────────────────────────────────────────┐
│                    BACKEND API LAYERS                           │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│  LAYER 1: HTTP LAYER (Express)                                  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Middleware:                                              │  │
│  │  • CORS         → Cross-origin requests                  │  │
│  │  • Helmet       → Security headers                       │  │
│  │  • Compression  → Response compression                   │  │
│  │  • Logger       → Request/Response logging               │  │
│  │  • Error        → Error handling                         │  │
│  └───────────────────────────────────────────────────────────┘  │
└───────────────────────────┬─────────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────────┐
│  LAYER 2: ROUTES                                                │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  POST   /api/files/list-folder                           │  │
│  │  PUT    /api/files/rename                                │  │
│  │  POST   /api/files/upload                                │  │
│  │  GET    /api/files/stats                                 │  │
│  │  GET    /health                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
└───────────────────────────┬─────────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────────┐
│  LAYER 3: CONTROLLERS                                           │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  FileController:                                          │  │
│  │  • listFilesFromFolder()                                 │  │
│  │  • renameFiles()                                          │  │
│  │  • uploadFiles()                                          │  │
│  │  • getUploadStats()                                       │  │
│  │  • healthCheck()                                          │  │
│  └───────────────────────────────────────────────────────────┘  │
└───────────────────────────┬─────────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────────┐
│  LAYER 4: SERVICES                                              │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  FileUtilsService:                                        │  │
│  │  • listFilesFromFolder()                                 │  │
│  │  • calculateFileHash()                                    │  │
│  │  • findDuplicateByHash()                                  │  │
│  │  • generateUniqueFilename()                               │  │
│  │  • validateFileName()                                     │  │
│  │  • sanitizeFileName()                                     │  │
│  │                                                           │  │
│  │  UploadService:                                           │  │
│  │  • processBatchUpload()                                   │  │
│  │  • uploadSingleFile()                                     │  │
│  │  • getUploadStats()                                       │  │
│  └───────────────────────────────────────────────────────────┘  │
└───────────────────────────┬─────────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────────┐
│  LAYER 5: FILE SYSTEM                                           │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  fs-extra:                                                │  │
│  │  • Read directory                                         │  │
│  │  • Get file stats                                         │  │
│  │  • Copy files                                             │  │
│  │  • Calculate hashes                                       │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎯 User Journey Map

```
User Opens App
    │
    ▼
┌───────────────────┐
│  Dashboard Loads  │
│  (Empty State)    │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│ Click "Select     │
│  Folder" Button   │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  File Picker      │
│  Opens            │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  User Selects     │
│  Folder           │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  Loading...       │
│  API Call         │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  Files Displayed  │
│  in List          │
└────────┬──────────┘
         │
         ▼
    ┌───┴────┐
    │        │
Optional:    Optional:
Rename       Remove
Files        Files
    │        │
    └───┬────┘
        │
        ▼
┌───────────────────┐
│  Click "Upload    │
│  Files" Button    │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  Confirmation     │
│  Dialog           │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  Uploading...     │
│  Progress         │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  Results Displayed│
│  Status Updated   │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  Summary Dialog   │
│  Shows Stats      │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  User Reviews     │
│  Results          │
└───────────────────┘
```

---

**This visual guide provides a comprehensive overview of the system!** 🎨

Use it to understand how everything works together.
