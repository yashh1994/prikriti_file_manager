import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:io' show File, Directory, FileSystemEntity, Platform;
import '../models/file_model.dart';
import '../models/upload_result.dart';
import '../services/api_service.dart';
import '../utils/toast_helper.dart';

/// File Manager Provider
/// Manages the state of files and upload operations
class FileManagerProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<FileModel> _files = [];
  List<FileModel> get files => _files;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String? _selectedFolderPath;
  String? get selectedFolderPath => _selectedFolderPath;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  BatchUploadResponse? _lastUploadResponse;
  BatchUploadResponse? get lastUploadResponse => _lastUploadResponse;

  Map<String, dynamic>? _uploadStats;
  Map<String, dynamic>? get uploadStats => _uploadStats;

  // Store file bytes for web platform
  final Map<String, Uint8List> _webFileBytes = {};

  /// Select files/folder based on platform
  Future<void> selectAndLoadFolder() async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      if (kIsWeb) {
        // Web platform: Select multiple files instead of directory
        await _selectFilesForWeb();
      } else {
        // Desktop/Mobile: Select directory
        await _selectDirectoryForDesktop();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to select files: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Select directory for desktop platforms
  Future<void> _selectDirectoryForDesktop() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // User canceled the picker
        return;
      }

      _selectedFolderPath = selectedDirectory;
      await loadFilesFromFolderWithBytes(selectedDirectory);
    } catch (e) {
      throw Exception('Failed to select directory: $e');
    }
  }

  /// Select multiple files for web platform
  Future<void> _selectFilesForWeb() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: true, // Important for web - loads file bytes
      );

      if (result == null) {
        // User canceled the picker
        return;
      }

      _selectedFolderPath = 'Web Files (${result.files.length} selected)';

      // Convert PlatformFile to FileModel
      _files = result.files.map((platformFile) {
        final id =
            DateTime.now().millisecondsSinceEpoch.toString() +
            platformFile.name.hashCode.toString();

        // Store file bytes for later upload
        if (platformFile.bytes != null) {
          _webFileBytes[id] = platformFile.bytes!;
        }

        return FileModel(
          id: id,
          name: platformFile.name,
          originalName: platformFile.name,
          extension: platformFile.extension ?? '',
          size: platformFile.size,
          path: platformFile
              .name, // Use name as path for web (path is unavailable)
          mimetype: _getMimeType(platformFile.extension ?? ''),
          createdAt: DateTime.now(),
          modifiedAt: DateTime.now(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to select files: $e');
    }
  }

  /// Get MIME type from extension
  String _getMimeType(String extension) {
    final ext = extension.toLowerCase();
    final mimeTypes = {
      'pdf': 'application/pdf',
      'doc': 'application/msword',
      'docx':
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'xls': 'application/vnd.ms-excel',
      'xlsx':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'txt': 'text/plain',
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'zip': 'application/zip',
      'rar': 'application/x-rar-compressed',
      '7z': 'application/x-7z-compressed',
      'mp4': 'video/mp4',
      'avi': 'video/x-msvideo',
      'mp3': 'audio/mpeg',
    };
    return mimeTypes[ext] ?? 'application/octet-stream';
  }

  /// Load files from a specific folder with bytes (for desktop upload to remote server)
  Future<void> loadFilesFromFolderWithBytes(String folderPath) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _webFileBytes.clear(); // Clear previous file bytes
      notifyListeners();

      // List files directly from local file system (desktop only)
      if (!kIsWeb) {
        final directory = Directory(folderPath);
        final List<FileSystemEntity> entities = await directory.list().toList();
        final List<FileModel> fileModels = [];

        for (var entity in entities) {
          if (entity is File) {
            try {
              final fileName = entity.path.split(Platform.pathSeparator).last;
              final fileStats = await entity.stat();
              final extension = fileName.contains('.')
                  ? fileName.split('.').last
                  : '';
              final fileBytes = await entity.readAsBytes();
              final fileId =
                  DateTime.now().millisecondsSinceEpoch.toString() +
                  fileName.hashCode.toString();

              // Store file bytes
              _webFileBytes[fileId] = Uint8List.fromList(fileBytes);

              // Create file model
              fileModels.add(
                FileModel(
                  id: fileId,
                  name: fileName,
                  originalName: fileName,
                  extension: extension,
                  size: fileStats.size,
                  path: entity.path,
                  mimetype: _getMimeType(extension),
                  createdAt: fileStats.changed,
                  modifiedAt: fileStats.modified,
                ),
              );
            } catch (e) {
              print('Failed to read file ${entity.path}: $e');
            }
          }
        }

        _files = fileModels;
      }

      _selectedFolderPath = folderPath;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load files: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update file name
  void updateFileName(String fileId, String newName) {
    final index = _files.indexWhere((f) => f.id == fileId);
    if (index != -1) {
      final oldName = _files[index].name;
      _files[index].newName = newName;
      ToastHelper.showSuccess('✏️ Renamed: $oldName → $newName');
      notifyListeners();
    }
  }

  /// Clear file rename
  void clearFileRename(String fileId) {
    final index = _files.indexWhere((f) => f.id == fileId);
    if (index != -1) {
      _files[index].newName = null;
      ToastHelper.showInfo('Rename cancelled');
      notifyListeners();
    }
  }

  /// Upload all files with modifications (one by one with real-time updates)
  Future<void> uploadFiles() async {
    try {
      _isUploading = true;
      _errorMessage = null;
      _lastUploadResponse = null;

      // Initialize all files as pending
      for (var file in _files) {
        file.status = UploadStatus.pending;
      }
      notifyListeners();

      int doneCount = 0;
      int failedCount = 0;
      int duplicateCount = 0;

      // Upload files one by one for real-time updates
      final List<UploadResult> allResults = [];

      for (var file in List.from(_files)) {
        try {
          // Upload single file
          final result = await _apiService.uploadSingleFileWeb(
            file,
            _webFileBytes[file.id]!,
          );

          allResults.add(result);

          // Update file status immediately
          final index = _files.indexWhere((f) => f.id == file.id);
          if (index != -1) {
            _files[index].status = result.status;
            _files[index].error = result.error;
            _files[index].finalPath = result.finalPath;

            // Update counters
            if (result.status == UploadStatus.done) {
              doneCount++;
              // Remove successfully uploaded file immediately
              _files.removeAt(index);
              _webFileBytes.remove(file.id);
            } else if (result.status == UploadStatus.failed) {
              failedCount++;
            } else if (result.status == UploadStatus.duplicate) {
              duplicateCount++;
            }

            // Notify listeners for real-time UI update
            notifyListeners();
          }
        } catch (e) {
          // Mark as failed if exception occurs
          final index = _files.indexWhere((f) => f.id == file.id);
          if (index != -1) {
            _files[index].status = UploadStatus.failed;
            _files[index].error = e.toString();
            failedCount++;
            notifyListeners();
          }
        }
      }

      // Create final response
      _lastUploadResponse = BatchUploadResponse(
        success: true,
        message: 'Upload completed',
        results: allResults,
        summary: UploadSummary(
          total: allResults.length,
          done: doneCount,
          failed: failedCount,
          duplicate: duplicateCount,
          pending: 0,
        ),
      );

      // Show toast notification with upload summary
      ToastHelper.showUploadSummary(
        done: doneCount,
        failed: failedCount,
        duplicate: duplicateCount,
      );

      // Refresh folder files only if some uploads were successful
      if (doneCount > 0 && _selectedFolderPath != null && !kIsWeb) {
        try {
          await refreshSelectedFolder();
        } catch (e) {
          // Don't fail the entire upload if refresh fails
          print('Failed to refresh folder after upload: $e');
        }
      }

      _isUploading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Upload failed: $e';
      ToastHelper.showError('Upload failed: ${e.toString()}');
      _isUploading = false;
      notifyListeners();
    }
  }

  /// Get upload statistics and refresh folder if selected
  Future<void> fetchUploadStats() async {
    try {
      _uploadStats = await _apiService.getUploadStats();

      // Also refresh the selected folder files if available
      if (_selectedFolderPath != null) {
        await refreshSelectedFolder();
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch stats: $e';
      notifyListeners();
    }
  }

  /// Refresh files from the currently selected folder
  Future<void> refreshSelectedFolder() async {
    if (_selectedFolderPath == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      if (kIsWeb) {
        // For web, we can't refresh folder - show message
        ToastHelper.showInfo(
          'Please re-select files to refresh on web platform',
        );
      } else {
        // For desktop, reload files from the same folder
        await loadFilesFromFolderWithBytes(_selectedFolderPath!);
        ToastHelper.showSuccess('Folder refreshed: $_selectedFolderPath');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to refresh folder: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear all files and selected folder
  void clearFiles() {
    _files = [];
    _selectedFolderPath = null; // Clear selected folder path
    _lastUploadResponse = null;
    _errorMessage = null;
    _webFileBytes.clear(); // Clear web file bytes
    ToastHelper.showInfo('All files and folder selection cleared');
    notifyListeners();
  }

  /// Remove a specific file from list
  void removeFile(String fileId) {
    final index = _files.indexWhere((f) => f.id == fileId);
    if (index != -1) {
      final fileName = _files[index].name;
      _files.removeWhere((f) => f.id == fileId);
      _webFileBytes.remove(fileId);
      ToastHelper.showWarning('🗑️ Removed: $fileName');
      notifyListeners();
    }
  }

  /// Get files by status
  List<FileModel> getFilesByStatus(UploadStatus status) {
    return _files.where((f) => f.status == status).toList();
  }

  /// Get upload summary
  Map<String, int> getUploadSummary() {
    return {
      'total': _files.length,
      'done': _files.where((f) => f.status == UploadStatus.done).length,
      'failed': _files.where((f) => f.status == UploadStatus.failed).length,
      'duplicate': _files
          .where((f) => f.status == UploadStatus.duplicate)
          .length,
      'pending': _files.where((f) => f.status == UploadStatus.pending).length,
    };
  }

  /// Get total size
  int get totalSize {
    return _files.fold(0, (sum, file) => sum + file.size);
  }

  /// Get formatted total size
  String get formattedTotalSize {
    return _formatBytes(totalSize);
  }

  /// Format bytes to human-readable string
  String _formatBytes(int bytes) {
    if (bytes == 0) return '0 Bytes';
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    final i = (bytes == 0) ? 0 : (bytes.bitLength - 1) ~/ 10;
    final formattedSize = bytes / (1 << (i * 10));
    return '${formattedSize.toStringAsFixed(2)} ${sizes[i]}';
  }
}
