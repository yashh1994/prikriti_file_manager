# Quick Start Guide - Prikriti File Manager

## 🚀 Getting Started in 5 Minutes

### Prerequisites
- ✅ Node.js (v16 or higher)
- ✅ Flutter SDK (v3.9.2 or higher)
- ✅ Windows/macOS/Linux

---

## Step 1: Start the Backend

```powershell
# Navigate to Backend folder
cd "e:\Freelancing\Kishan\Prikriti File Manager\Backend"

# Install dependencies (first time only)
npm install

# Start the server
npm run dev
```

**Expected Output:**
```
=================================
🚀 Prikriti File Manager API
📡 Server running on port 3000
🌍 Environment: development
📁 Upload path: E:\Freelancing\Kishan\Prikriti File Manager\Backend\uploads
=================================
```

---

## Step 2: Run the Flutter Dashboard

**Open a NEW terminal** and run:

```powershell
# Navigate to Flutter app
cd "e:\Freelancing\Kishan\Prikriti File Manager\Frontend\app"

# Install dependencies (first time only)
flutter pub get

# Run the app
flutter run -d windows
```

**Alternative platforms:**
```powershell
# For Web
flutter run -d chrome

# For Android (with device/emulator connected)
flutter run -d android
```

---

## Step 3: Use the Dashboard

### 1️⃣ Select a Folder
- Click **"Select Folder"** button at the top
- Choose any folder from your computer
- All files will be loaded instantly

### 2️⃣ Review Files
- View all file details (name, size, type)
- See summary cards showing file counts
- Check total size of all files

### 3️⃣ Rename Files (Optional)
- Click the ✏️ edit icon next to any file
- Type the new name
- Press Enter or click ✓ to confirm

### 4️⃣ Remove Files (Optional)
- Click the 🗑️ delete icon to remove files from the list
- This only removes from the upload queue, not your disk

### 5️⃣ Upload Files
- Click **"Upload Files"** button at the bottom
- Confirm the upload
- Watch the status change for each file:
  - 🟢 **Done**: Successfully uploaded
  - 🔴 **Failed**: Error occurred
  - 🟠 **Duplicate**: Same file already exists
  - ⚪ **Pending**: Waiting to upload

### 6️⃣ View Results
- Check the summary dialog after upload
- Review the summary cards for statistics
- Failed files will show error messages

---

## 📁 Where Are Uploaded Files?

Files are uploaded to:
```
Backend/uploads/
```

You can find all uploaded files in this folder.

---

## 🧪 Test Scenarios

### Test 1: Normal Upload
1. Select a folder with 5-10 files
2. Upload without any changes
3. All should show "Done" status

### Test 2: Rename Before Upload
1. Select a folder
2. Rename 2-3 files
3. Upload and verify new names in uploads folder

### Test 3: Duplicate Detection
1. Upload some files
2. Try uploading the same files again
3. Should show "Duplicate" status

### Test 4: Name Conflict
1. Create two different files with same name
2. Upload first file
3. Upload second file from different location
4. Second file gets timestamp appended

---

## 🎨 Dashboard Features

### Summary Cards
- **Total Files**: Number of files loaded
- **Done**: Successfully uploaded
- **Failed**: Upload errors
- **Duplicate**: Skipped duplicates
- **Pending**: Not yet uploaded

### File List Features
- 📄 File icon based on type
- 📝 Inline editing for names
- 📊 File size in readable format
- 🎯 Status indicator
- ✏️ Edit button
- 🗑️ Delete button

### Action Buttons
- **Select Folder**: Load new files
- **Clear All**: Remove all from list
- **Upload Files**: Start upload process

---

## 🔧 Configuration

### Change Backend URL

If backend runs on different port, edit:

**File**: `Frontend/app/lib/services/api_service.dart`

```dart
ApiService({this.baseUrl = 'http://localhost:3000/api/files'});
```

Change `localhost:3000` to your backend URL.

### Change Upload Folder

**File**: `Backend/.env`

```env
UPLOAD_PATH=uploads
```

---

## ❌ Troubleshooting

### Backend Won't Start

**Issue**: Port 3000 already in use
```powershell
# Check what's using port 3000
netstat -ano | findstr :3000

# Kill the process or change port in Backend/.env
```

**Issue**: Module not found
```powershell
# Reinstall dependencies
cd Backend
rm -r node_modules
npm install
```

### Flutter App Won't Run

**Issue**: No device available
```powershell
# Check available devices
flutter devices

# Enable Windows desktop
flutter config --enable-windows-desktop
```

**Issue**: Pub get failed
```powershell
# Clean and retry
flutter clean
flutter pub get
```

### Cannot Select Folder

**Windows**: Ensure app has file system permissions  
**Web**: File picker may have browser limitations  
**Mobile**: Grant storage permissions

### Upload Fails

1. Check backend is running
2. Verify uploads folder exists
3. Check file permissions
4. Review backend logs

---

## 📊 API Testing (Optional)

Test API with curl or Postman:

### Health Check
```powershell
curl http://localhost:3000/health
```

### List Files
```powershell
curl -X POST http://localhost:3000/api/files/list-folder `
  -H "Content-Type: application/json" `
  -d '{"folderPath":"C:\\Users\\YourName\\Documents"}'
```

---

## 📖 Documentation

- **Complete System**: See `COMPLETE_SYSTEM_DOCUMENTATION.md`
- **Backend API**: See `Backend/API_DOCUMENTATION.md`
- **Flutter App**: See `Frontend/app/FLUTTER_README.md`

---

## 🎉 That's It!

You're all set! Start uploading files with the beautiful dashboard.

### Next Steps
- Explore renaming features
- Test duplicate detection
- Check upload statistics
- Review error handling

### Need Help?
- Check the complete documentation
- Review API responses in browser DevTools
- Check backend logs in `Backend/logs`

---

## 💡 Tips

1. **Performance**: For large folders (1000+ files), loading may take a moment
2. **File Size**: Backend has 100MB default max file size
3. **Duplicates**: Based on file content, not name
4. **Names**: Special characters automatically sanitized
5. **Status**: Real-time updates as files upload

Enjoy managing your files! 🚀
