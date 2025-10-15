# 🛠️ Helpful Commands Reference

Quick reference for common commands used in the Prikriti File Manager project.

---

## 📂 Navigation

```powershell
# Navigate to Backend
cd "e:\Freelancing\Kishan\Prikriti File Manager\Backend"

# Navigate to Frontend
cd "e:\Freelancing\Kishan\Prikriti File Manager\Frontend\app"

# Navigate to Root
cd "e:\Freelancing\Kishan\Prikriti File Manager"
```

---

## 🔧 Backend Commands

### Development
```powershell
# Install dependencies
npm install

# Start development server with auto-reload
npm run dev

# Build TypeScript to JavaScript
npm run build

# Start production server
npm start

# Run tests
npm test

# Lint code
npm run lint

# Fix linting issues
npm run lint:fix

# Format code
npm run format
```

### Maintenance
```powershell
# Clean build folder
npm run clean

# Reinstall dependencies
rm -r node_modules
npm install

# Update dependencies
npm update

# Check for outdated packages
npm outdated
```

---

## 📱 Flutter Commands

### Development
```powershell
# Install dependencies
flutter pub get

# Run on Windows
flutter run -d windows

# Run on Web
flutter run -d chrome

# Run on Android (with device/emulator)
flutter run -d android

# Run on iOS (macOS only, with device/simulator)
flutter run -d ios
```

### Build
```powershell
# Build Windows executable
flutter build windows --release

# Build Web app
flutter build web --release

# Build Android APK
flutter build apk --release

# Build iOS (macOS only)
flutter build ios --release
```

### Maintenance
```powershell
# Clean build files
flutter clean

# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Check outdated packages
flutter pub outdated

# List available devices
flutter devices

# Run Flutter doctor
flutter doctor

# Analyze code
flutter analyze
```

---

## 🧪 Testing Commands

### Backend API Testing

**PowerShell:**
```powershell
# Health check
Invoke-RestMethod -Uri "http://localhost:3000/health" -Method Get

# List files from folder
$body = @{ folderPath = "C:\TestFolder" } | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:3000/api/files/list-folder" `
    -Method Post -ContentType "application/json" -Body $body

# Get statistics
Invoke-RestMethod -Uri "http://localhost:3000/api/files/stats" -Method Get
```

**cURL:**
```bash
# Health check
curl http://localhost:3000/health

# List files
curl -X POST http://localhost:3000/api/files/list-folder \
  -H "Content-Type: application/json" \
  -d '{"folderPath":"C:\\TestFolder"}'

# Get statistics
curl http://localhost:3000/api/files/stats
```

---

## 🗂️ File Management Commands

### Clear Uploads Folder
```powershell
# Remove all files from uploads folder
Remove-Item "Backend\uploads\*" -Force

# Remove all files and folders
Remove-Item "Backend\uploads\*" -Force -Recurse
```

### Check File Existence
```powershell
# Check if file exists
Test-Path "C:\path\to\file.txt"

# List files in uploads folder
Get-ChildItem "Backend\uploads"

# Get file info
Get-Item "Backend\uploads\file.txt"
```

### View Logs
```powershell
# View latest log
Get-Content "Backend\logs\app.log" -Tail 50

# Follow log in real-time
Get-Content "Backend\logs\app.log" -Wait -Tail 10
```

---

## 🐛 Debugging Commands

### Check Process and Ports
```powershell
# Check what's using port 3000
netstat -ano | findstr :3000

# Kill process by PID
taskkill /PID <PID> /F

# List all Node processes
Get-Process node
```

### Git Commands
```powershell
# Check status
git status

# View changes
git diff

# Add all changes
git add .

# Commit changes
git commit -m "Your message"

# Push to remote
git push origin features

# Pull latest changes
git pull

# View commit history
git log --oneline
```

---

## 📦 Package Management

### Backend
```powershell
# Install specific package
npm install <package-name>

# Install as dev dependency
npm install <package-name> --save-dev

# Uninstall package
npm uninstall <package-name>

# Update specific package
npm update <package-name>

# Check package version
npm list <package-name>
```

### Flutter
```powershell
# Add package
flutter pub add <package-name>

# Add dev dependency
flutter pub add <package-name> --dev

# Remove package
flutter pub remove <package-name>

# Get specific version
flutter pub add <package-name>:<version>

# Show package tree
flutter pub deps
```

---

## 🔍 Search and Find

```powershell
# Find files by name
Get-ChildItem -Recurse -Filter "*.ts"

# Search in files
Select-String -Path ".\**\*.ts" -Pattern "function"

# Find large files
Get-ChildItem -Recurse | Where-Object { $_.Length -gt 1MB }
```

---

## 📊 System Information

```powershell
# Node version
node --version

# npm version
npm --version

# Flutter version
flutter --version

# Dart version
dart --version

# Check Flutter doctor
flutter doctor -v

# Check system info
systeminfo
```

---

## 🚀 Deployment Commands

### Backend Deployment
```powershell
# Build for production
npm run build

# Set production environment
$env:NODE_ENV="production"

# Start production server
npm start
```

### Flutter Deployment
```powershell
# Build Windows release
flutter build windows --release

# The executable will be in:
# build\windows\runner\Release\app.exe

# Build Web release
flutter build web --release

# The web files will be in:
# build\web\
```

---

## 🧹 Cleanup Commands

### Full Reset
```powershell
# Backend full cleanup
cd Backend
Remove-Item node_modules -Recurse -Force
Remove-Item dist -Recurse -Force
Remove-Item package-lock.json -Force
npm install

# Flutter full cleanup
cd Frontend/app
flutter clean
Remove-Item pubspec.lock -Force
flutter pub get
```

### Cache Cleanup
```powershell
# Clear npm cache
npm cache clean --force

# Clear Flutter cache
flutter pub cache repair
```

---

## 📝 Quick Scripts

### Start Both Backend and Frontend
Save as `start-all.ps1`:
```powershell
# Start backend in new terminal
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'e:\Freelancing\Kishan\Prikriti File Manager\Backend'; npm run dev"

# Wait 3 seconds
Start-Sleep -Seconds 3

# Start frontend in new terminal
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'e:\Freelancing\Kishan\Prikriti File Manager\Frontend\app'; flutter run -d windows"
```

Run with: `.\start-all.ps1`

### Reset Everything
Save as `reset-all.ps1`:
```powershell
# Clear uploads
Remove-Item "Backend\uploads\*" -Force

# Clear logs
Remove-Item "Backend\logs\*" -Force

# Restart backend
# (Assumes backend is running - stop it first manually)

Write-Host "System reset complete!"
```

---

## 🎯 Common Workflows

### Start Development
```powershell
# 1. Start backend
cd Backend
npm run dev

# 2. In new terminal, start frontend
cd Frontend/app
flutter run -d windows
```

### Update Dependencies
```powershell
# Backend
cd Backend
npm update
npm audit fix

# Frontend
cd Frontend/app
flutter pub upgrade
```

### Build for Production
```powershell
# Backend
cd Backend
npm run build

# Frontend
cd Frontend/app
flutter build windows --release
```

---

## 💡 Pro Tips

### Alias Commands (PowerShell Profile)
Add to `$PROFILE`:
```powershell
# Navigate to project
function goto-prikriti { cd "e:\Freelancing\Kishan\Prikriti File Manager" }
Set-Alias prikriti goto-prikriti

# Start backend
function start-backend { 
    cd "e:\Freelancing\Kishan\Prikriti File Manager\Backend"
    npm run dev 
}

# Start frontend
function start-frontend { 
    cd "e:\Freelancing\Kishan\Prikriti File Manager\Frontend\app"
    flutter run -d windows 
}
```

Usage:
```powershell
prikriti        # Go to project
start-backend   # Start backend
start-frontend  # Start frontend
```

---

## 🔧 Environment Variables

### Set Backend Port
```powershell
# Temporary (current session)
$env:PORT = "3001"

# Or edit Backend/.env file
```

### Set Flutter Environment
```powershell
# Development
$env:FLUTTER_ENV = "development"

# Production
$env:FLUTTER_ENV = "production"
```

---

## 📱 Device Management (Flutter)

```powershell
# List all devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Enable Windows desktop
flutter config --enable-windows-desktop

# Enable Web
flutter config --enable-web

# Check configuration
flutter config
```

---

## 🎓 Help Commands

```powershell
# npm help
npm help

# Flutter help
flutter help

# Specific command help
flutter run --help
npm run --help

# View available scripts
npm run
```

---

**Save this file for quick reference!** 📋

All commands are ready to copy-paste and use in your PowerShell terminal.
