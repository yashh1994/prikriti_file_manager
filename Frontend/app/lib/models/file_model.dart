/// File Model
/// Represents a file with all metadata
class FileModel {
  final String id;
  final String name;
  final String originalName;
  final String extension;
  final int size;
  final String path;
  final String? mimetype;
  final DateTime createdAt;
  final DateTime modifiedAt;
  String? newName;
  UploadStatus status;
  String? error;
  String? finalPath;

  FileModel({
    required this.id,
    required this.name,
    required this.originalName,
    required this.extension,
    required this.size,
    required this.path,
    this.mimetype,
    required this.createdAt,
    required this.modifiedAt,
    this.newName,
    this.status = UploadStatus.pending,
    this.error,
    this.finalPath,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      originalName: json['originalName'] ?? '',
      extension: json['extension'] ?? '',
      size: json['size'] ?? 0,
      path: json['path'] ?? '',
      mimetype: json['mimetype'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      modifiedAt: DateTime.parse(
        json['modifiedAt'] ?? DateTime.now().toIso8601String(),
      ),
      newName: json['newName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'originalName': originalName,
      'extension': extension,
      'size': size,
      'path': path,
      'mimetype': mimetype,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'newName': newName,
    };
  }

  String get displayName => newName ?? name;

  String get formattedSize => _formatBytes(size);

  static String _formatBytes(int bytes) {
    if (bytes == 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    final i = (bytes == 0) ? 0 : (bytes.bitLength - 1) ~/ 10;
    final formattedSize = bytes / (1 << (i * 10));
    return '${formattedSize.toStringAsFixed(2)} ${sizes[i]}';
  }
}

enum UploadStatus { pending, done, failed, duplicate }

extension UploadStatusExtension on UploadStatus {
  String get displayName {
    switch (this) {
      case UploadStatus.pending:
        return 'Pending';
      case UploadStatus.done:
        return 'Done';
      case UploadStatus.failed:
        return 'Failed';
      case UploadStatus.duplicate:
        return 'Duplicate';
    }
  }
}
