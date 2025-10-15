/// App Configuration
class AppConfig {
  // API Base URL
  static const String apiBaseUrl = 'http://localhost:3000/api/files';

  // API Endpoints
  static const String listFolderEndpoint = '/list-folder';
  static const String renameEndpoint = '/rename';
  static const String uploadEndpoint = '/upload';
  static const String statsEndpoint = '/stats';
  static const String healthEndpoint = '/health';

  // App Settings
  static const String appName = 'Prikriti File Manager';
  static const String appVersion = '1.0.0';

  // File Settings
  static const int maxFileNameLength = 255;
  static const List<String> allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'pdf',
    'doc',
    'docx',
    'txt',
    'xls',
    'xlsx',
    'csv',
    'zip',
    'rar',
    '7z',
    'mp4',
    'avi',
    'mov',
    'mkv',
    'mp3',
    'wav',
    'flac',
  ];

  // UI Settings
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  static const double defaultPadding = 16.0;
}
