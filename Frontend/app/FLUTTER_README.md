# Prikriti File Manager - Flutter Frontend

A modern Flutter application for managing and uploading files with a beautiful dashboard interface.

## Features

✅ **Folder Selection**: Select any folder from your system and load all files  
✅ **File Details**: View comprehensive file information (name, extension, size, etc.)  
✅ **Rename Files**: Edit file names before uploading  
✅ **Batch Upload**: Upload multiple files simultaneously  
✅ **Duplicate Detection**: Automatic detection of duplicate files  
✅ **Upload Status**: Real-time status tracking (Pending, Done, Failed, Duplicate)  
✅ **Beautiful Dashboard**: Modern UI with Material Design 3  
✅ **Error Handling**: Robust error handling with user-friendly messages  
✅ **Summary Cards**: Visual statistics for upload operations  

## Screenshots

### Dashboard View
- Summary cards showing upload statistics
- File list with detailed information
- Rename functionality
- Status indicators

## Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Backend server running on `http://localhost:3000`

## Installation

### 1. Install Dependencies

```bash
cd "Frontend/app"
flutter pub get
```

### 2. Configure Backend URL

Edit `lib/services/api_service.dart` if your backend is running on a different URL:

```dart
ApiService({this.baseUrl = 'http://localhost:3000/api/files'});
```

### 3. Run the Application

```bash
# For Windows
flutter run -d windows

# For Web
flutter run -d chrome

# For Android
flutter run -d android

# For iOS (macOS only)
flutter run -d ios
```

## Project Structure

```
lib/
├── config/
│   └── app_config.dart           # App configuration
├── models/
│   ├── file_model.dart            # File data model
│   └── upload_result.dart         # Upload result models
├── providers/
│   └── file_manager_provider.dart # State management
├── screens/
│   └── dashboard_screen.dart      # Main dashboard
├── services/
│   └── api_service.dart           # API communication
├── widgets/
│   ├── file_list_item.dart        # File list item widget
│   ├── summary_card.dart          # Summary card widget
│   └── upload_progress_dialog.dart # Upload progress dialog
└── main.dart                      # App entry point
```

## Usage

### 1. Select a Folder
- Click the "Select Folder" button
- Choose a folder from your file system
- All files will be loaded and displayed

### 2. Review and Edit Files
- View file details (name, size, type)
- Click the edit icon to rename files
- Remove unwanted files using the delete icon

### 3. Upload Files
- Click "Upload Files" button
- Confirm the upload operation
- Monitor upload status for each file

### 4. View Results
- Check summary cards for upload statistics
- View individual file status (Done, Failed, Duplicate, Pending)
- Review error messages for failed uploads

## API Endpoints Used

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/files/list-folder` | POST | Load files from a folder |
| `/api/files/rename` | PUT | Update file names |
| `/api/files/upload` | POST | Upload files to server |
| `/api/files/stats` | GET | Get upload statistics |
| `/health` | GET | Health check |

## File Status Indicators

- 🟢 **Done**: File uploaded successfully
- 🔴 **Failed**: Upload failed (error message shown)
- 🟠 **Duplicate**: Duplicate file detected (same content)
- ⚪ **Pending**: Waiting to be uploaded

## Key Features Explained

### Duplicate Detection
The system checks for duplicate files based on content (MD5 hash), not just filename. If a duplicate is detected, the file won't be uploaded again.

### Name Conflict Resolution
If a file with the same name already exists in the uploads folder, the system automatically adds a timestamp to the filename to avoid conflicts.

### Error Handling
- **Invalid file names**: Automatically sanitized
- **Missing source files**: Reported as failed
- **Network errors**: User-friendly error messages
- **Server errors**: Detailed error information

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.2.0                    # HTTP requests
  file_picker: ^8.0.0+1           # Folder/file selection
  provider: ^6.1.1                # State management
  path: ^1.9.0                    # Path utilities
  intl: ^0.19.0                   # Internationalization
  shared_preferences: ^2.2.2      # Local storage
  flutter_spinkit: ^5.2.0         # Loading indicators
  font_awesome_flutter: ^10.7.0   # Icons
```

## Building for Production

### Windows
```bash
flutter build windows --release
```

### Web
```bash
flutter build web --release
```

### Android
```bash
flutter build apk --release
```

### iOS (macOS only)
```bash
flutter build ios --release
```

## Troubleshooting

### Backend Connection Issues
- Ensure the backend server is running on `http://localhost:3000`
- Check CORS settings in backend configuration
- Verify firewall settings

### File Picker Issues
- On Windows: Ensure proper permissions
- On Web: Browser security may limit file access
- On Mobile: Check storage permissions

### Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

ISC License

## Support

For issues and questions:
- Create an issue in the repository
- Contact the development team

## Version History

- **v1.0.0** (2025-10-15)
  - Initial release
  - Folder selection and file loading
  - File renaming functionality
  - Batch upload with status tracking
  - Duplicate detection
  - Beautiful dashboard UI
