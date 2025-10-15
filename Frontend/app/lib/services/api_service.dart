import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/file_model.dart';
import '../models/upload_result.dart';

/// API Service for backend communication
/// All file operations now send file bytes to backend
/// Backend saves files to its uploads folder
class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'http://localhost:3000/api/files'});

  /// Rename files (update metadata before upload)
  Future<bool> renameFiles(List<FileModel> files) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/rename'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'files': files.map((f) => f.toJson()).toList()}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Failed to rename files: $e');
    }
  }

  /// Upload files to server (both web and desktop)
  /// Sends file bytes via multipart form data
  /// Files are saved to backend's uploads folder
  Future<BatchUploadResponse> uploadFilesWeb(
    List<FileModel> files,
    Map<String, Uint8List> fileBytes,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload-web'),
      );

      // Add files
      for (var file in files) {
        if (fileBytes.containsKey(file.id)) {
          final bytes = fileBytes[file.id]!;
          final filename = file.newName ?? file.name;

          request.files.add(
            http.MultipartFile.fromBytes('files', bytes, filename: filename),
          );

          // Add metadata for each file
          request.fields['metadata_${file.id}'] = jsonEncode({
            'id': file.id,
            'originalName': file.originalName,
            'newName': file.newName,
            'extension': file.extension,
            'size': file.size,
          });
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BatchUploadResponse.fromJson(data);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload files: $e');
    }
  }

  /// Upload single file to server (for real-time updates)
  /// Sends single file bytes via multipart form data
  Future<UploadResult> uploadSingleFileWeb(
    FileModel file,
    Uint8List fileBytes,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload-web'),
      );

      final filename = file.newName ?? file.name;

      // Add single file
      request.files.add(
        http.MultipartFile.fromBytes('files', fileBytes, filename: filename),
      );

      // Add metadata
      request.fields['files'] = jsonEncode([
        {
          'id': file.id,
          'originalName': file.originalName,
          'newName': file.newName,
          'extension': file.extension,
          'size': file.size,
        },
      ]);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final batchResponse = BatchUploadResponse.fromJson(data);

        // Return the first result (since we uploaded only one file)
        if (batchResponse.results.isNotEmpty) {
          return batchResponse.results.first;
        } else {
          throw Exception('No upload result returned');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Return failed result
      return UploadResult(
        id: file.id,
        originalName: file.originalName,
        newName: file.newName ?? file.name,
        status: UploadStatus.failed,
        error: e.toString(),
      );
    }
  }

  /// Get upload statistics
  Future<Map<String, dynamic>> getUploadStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['data'];
        } else {
          throw Exception(data['message'] ?? 'Failed to get stats');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get stats: $e');
    }
  }

  /// Health check
  Future<bool> healthCheck() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/health'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
