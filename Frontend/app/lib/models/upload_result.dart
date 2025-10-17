import 'file_model.dart';

/// Upload Result Model
class UploadResult {
  final String id;
  final String originalName;
  final String newName;
  final UploadStatus status;
  final String? finalPath;
  final String? error;
  final int? size;
  final String? extension;

  UploadResult({
    required this.id,
    required this.originalName,
    required this.newName,
    required this.status,
    this.finalPath,
    this.error,
    this.size,
    this.extension,
  });

  factory UploadResult.fromJson(Map<String, dynamic> json) {
    return UploadResult(
      id: json['id'] ?? '',
      originalName: json['originalName'] ?? '',
      newName: json['newName'] ?? '',
      status: _parseStatus(json['status']),
      finalPath: json['finalPath'],
      error: json['error'],
      size: json['size'],
      extension: json['extension'],
    );
  }

  static UploadStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'done':
        return UploadStatus.done;
      case 'failed':
        return UploadStatus.failed;
      case 'duplicate':
        return UploadStatus.duplicate;
      default:
        return UploadStatus.pending;
    }
  }
}

/// Batch Upload Response
class BatchUploadResponse {
  final bool success;
  final String message;
  final List<UploadResult> results;
  final UploadSummary summary;

  BatchUploadResponse({
    required this.success,
    required this.message,
    required this.results,
    required this.summary,
  });

  factory BatchUploadResponse.fromJson(Map<String, dynamic> json) {
    return BatchUploadResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      results:
          (json['results'] as List?)
              ?.map((r) => UploadResult.fromJson(r))
              .toList() ??
          [],
      summary: UploadSummary.fromJson(json['summary'] ?? {}),
    );
  }
}

/// Upload Summary
class UploadSummary {
  final int total;
  final int done;
  final int failed;
  final int duplicate;
  final int pending;

  UploadSummary({
    required this.total,
    required this.done,
    required this.failed,
    required this.duplicate,
    required this.pending,
  });

  factory UploadSummary.fromJson(Map<String, dynamic> json) {
    return UploadSummary(
      total: json['total'] ?? 0,
      done: json['done'] ?? 0,
      failed: json['failed'] ?? 0,
      duplicate: json['duplicate'] ?? 0,
      pending: json['pending'] ?? 0,
    );
  }
}
