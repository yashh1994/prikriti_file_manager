import 'package:flutter/material.dart';
import '../models/file_model.dart';

/// Modern File List Item Widget - Google Drive Style
class FileListItem extends StatefulWidget {
  final FileModel file;
  final Function(String) onRename;
  final VoidCallback onRemove;

  const FileListItem({
    Key? key,
    required this.file,
    required this.onRename,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<FileListItem> createState() => _FileListItemState();
}

class _FileListItemState extends State<FileListItem> {
  bool _isHovered = false;
  bool _isEditing = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.file.newName ?? widget.file.name,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Color _getFileTypeColor() {
    final ext = widget.file.extension.toLowerCase();

    // Images - Red
    if (['jpg', 'jpeg', 'png', 'gif', 'svg', 'webp', 'bmp'].contains(ext)) {
      return const Color(0xFFEA4335);
    }
    // PDFs - Red
    if (ext == 'pdf') {
      return const Color(0xFFEA4335);
    }
    // Documents - Blue
    if (['doc', 'docx', 'txt', 'rtf', 'odt'].contains(ext)) {
      return const Color(0xFF1A73E8);
    }
    // Spreadsheets - Green
    if (['xls', 'xlsx', 'csv', 'ods'].contains(ext)) {
      return const Color(0xFF34A853);
    }
    // Presentations - Yellow
    if (['ppt', 'pptx', 'odp'].contains(ext)) {
      return const Color(0xFFFBBC04);
    }
    // Archives - Purple
    if (['zip', 'rar', '7z', 'tar', 'gz'].contains(ext)) {
      return const Color(0xFF9334E6);
    }
    // Audio/Video - Pink
    if (['mp3', 'mp4', 'avi', 'mkv', 'wav', 'flac', 'mov'].contains(ext)) {
      return const Color(0xFFD81B60);
    }
    // Default - Gray
    return const Color(0xFF5F6368);
  }

  IconData _getFileTypeIcon() {
    final ext = widget.file.extension.toLowerCase();

    if (['jpg', 'jpeg', 'png', 'gif', 'svg', 'webp', 'bmp'].contains(ext)) {
      return Icons.image_rounded;
    }
    if (ext == 'pdf') {
      return Icons.picture_as_pdf_rounded;
    }
    if (['doc', 'docx', 'txt', 'rtf', 'odt'].contains(ext)) {
      return Icons.description_rounded;
    }
    if (['xls', 'xlsx', 'csv', 'ods'].contains(ext)) {
      return Icons.table_chart_rounded;
    }
    if (['ppt', 'pptx', 'odp'].contains(ext)) {
      return Icons.slideshow_rounded;
    }
    if (['zip', 'rar', '7z', 'tar', 'gz'].contains(ext)) {
      return Icons.folder_zip_rounded;
    }
    if (['mp3', 'mp4', 'avi', 'mkv', 'wav', 'flac', 'mov'].contains(ext)) {
      return Icons.play_circle_rounded;
    }
    return Icons.insert_drive_file_rounded;
  }

  Color _getStatusColor() {
    switch (widget.file.status) {
      case UploadStatus.done:
        return const Color(0xFF34A853);
      case UploadStatus.failed:
        return const Color(0xFFEA4335);
      case UploadStatus.duplicate:
        return const Color(0xFFFBBC04);
      case UploadStatus.pending:
        return const Color(0xFF5F6368);
    }
  }

  IconData _getStatusIcon() {
    switch (widget.file.status) {
      case UploadStatus.done:
        return Icons.check_circle_rounded;
      case UploadStatus.failed:
        return Icons.error_rounded;
      case UploadStatus.duplicate:
        return Icons.content_copy_rounded;
      case UploadStatus.pending:
        return Icons.schedule_rounded;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _getFileTypeColor();
    final iconData = _getFileTypeIcon();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFFF1F3F4) : Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // File Type Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(iconData, color: iconColor, size: 24),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // File Name (Editable)
                  Expanded(
                    flex: 3,
                    child: _isEditing
                        ? TextField(
                            controller: _nameController,
                            autofocus: true,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF202124),
                              letterSpacing: 0.2,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: Color(0xFF1A73E8),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: Color(0xFF1A73E8),
                                  width: 2,
                                ),
                              ),
                            ),
                            onSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                widget.onRename(value.trim());
                              }
                              setState(() => _isEditing = false);
                            },
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.file.newName ?? widget.file.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF202124),
                                  letterSpacing: 0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.file.formattedSize} • ${_formatDate(widget.file.modifiedAt)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF5F6368),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                  ),

                  const SizedBox(width: 16),

                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor().withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(),
                          size: 14,
                          color: _getStatusColor(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.file.status.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Actions
                  if (!_isEditing) ...[
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, size: 18),
                      color: const Color(0xFF5F6368),
                      onPressed: () {
                        setState(() => _isEditing = true);
                      },
                      tooltip: 'Rename',
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded, size: 18),
                      color: const Color(0xFFEA4335),
                      onPressed: widget.onRemove,
                      tooltip: 'Remove',
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ],
              ),

              // Error Message
              if (widget.file.error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.file.status == UploadStatus.duplicate
                        ? const Color(0xFFFEF7E0)
                        : const Color(0xFFFCE8E6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.file.status == UploadStatus.duplicate
                          ? const Color(0xFFFBBC04)
                          : const Color(0xFFEA4335),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.file.status == UploadStatus.duplicate
                            ? Icons.warning_rounded
                            : Icons.error_rounded,
                        size: 16,
                        color: widget.file.status == UploadStatus.duplicate
                            ? const Color(0xFFF57F17)
                            : const Color(0xFFEA4335),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.file.error!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: widget.file.status == UploadStatus.duplicate
                                ? const Color(0xFFF57F17)
                                : const Color(0xFFEA4335),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
