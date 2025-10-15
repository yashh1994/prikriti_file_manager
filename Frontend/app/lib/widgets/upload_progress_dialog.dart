import 'package:flutter/material.dart';

/// Upload Progress Dialog
class UploadProgressDialog extends StatelessWidget {
  final int total;
  final int completed;

  const UploadProgressDialog({
    Key? key,
    required this.total,
    required this.completed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;

    return AlertDialog(
      title: const Text('Uploading Files'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: progress, minHeight: 10),
          const SizedBox(height: 16),
          Text(
            'Uploading $completed of $total files...',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
