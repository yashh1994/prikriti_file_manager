import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/file_manager_provider.dart';
import '../widgets/file_list_item.dart';
import '../widgets/summary_card.dart';
import '../models/file_model.dart';

/// Main Dashboard Screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Optionally fetch stats on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FileManagerProvider>().fetchUploadStats();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FileModel> _getFilteredFiles(List<FileModel> files) {
    if (_searchQuery.isEmpty) {
      return files;
    }

    final query = _searchQuery.toLowerCase();
    return files.where((file) {
      final fileName = (file.newName ?? file.name).toLowerCase();
      final extension = file.extension.toLowerCase();
      final size = file.formattedSize.toLowerCase();
      return fileName.contains(query) ||
          extension.contains(query) ||
          size.contains(query);
    }).toList();
  }

  void _showUploadResultsDialog(BuildContext context) {
    final provider = context.read<FileManagerProvider>();
    final response = provider.lastUploadResponse;

    if (response == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF34A853).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF34A853),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Upload Complete',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF202124),
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                response.message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5F6368),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 20),
              _buildSummaryRow(
                'Total',
                response.summary.total,
                const Color(0xFF1A73E8),
                Icons.insert_drive_file_rounded,
              ),
              const SizedBox(height: 12),
              _buildSummaryRow(
                'Uploaded',
                response.summary.done,
                const Color(0xFF34A853),
                Icons.check_circle_rounded,
              ),
              const SizedBox(height: 12),
              _buildSummaryRow(
                'Failed',
                response.summary.failed,
                const Color(0xFFEA4335),
                Icons.error_rounded,
              ),
              const SizedBox(height: 12),
              _buildSummaryRow(
                'Duplicates',
                response.summary.duplicate,
                const Color(0xFFFBBC04),
                Icons.content_copy_rounded,
              ),
              const SizedBox(height: 12),
              _buildSummaryRow(
                'Pending',
                response.summary.pending,
                const Color(0xFF5F6368),
                Icons.schedule_rounded,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1A73E8),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF202124),
                letterSpacing: 0.3,
              ),
            ),
          ),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderPathTags(String folderPath) {
    // Split the path into segments
    final pathParts = folderPath
        .split(RegExp(r'[/\\]'))
        .where((p) => p.isNotEmpty)
        .toList();

    // Get the folder name (last segment)
    final folderName = pathParts.isNotEmpty ? pathParts.last : '';

    // Get parent path segments (all except last)
    final parentParts = pathParts.length > 1
        ? pathParts.sublist(0, pathParts.length - 1)
        : <String>[];

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Show parent path segments as small tags
        ...parentParts.map(
          (part) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F4),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFE8EAED)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 14,
                  color: Color(0xFF5F6368),
                ),
                const SizedBox(width: 2),
                Text(
                  part,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5F6368),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Show folder name as prominent tag
        if (folderName.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF1A73E8).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF1A73E8).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.folder_rounded,
                  size: 16,
                  color: Color(0xFF1A73E8),
                ),
                const SizedBox(width: 6),
                Text(
                  folderName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A73E8),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _handleUpload(BuildContext context) async {
    final provider = context.read<FileManagerProvider>();

    if (provider.files.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.white),
              const SizedBox(width: 12),
              const Text(
                'No files to upload',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFFBBC04),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1A73E8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.cloud_upload_rounded,
                color: Color(0xFF1A73E8),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Confirm Upload',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF202124),
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        content: Text(
          'Upload ${provider.files.length} file(s) to the server?\n\nThis action will process all pending files.',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF5F6368),
            letterSpacing: 0.3,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF5F6368),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF34A853),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            child: const Text('Upload'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Perform upload
    await provider.uploadFiles();

    // Show results
    if (context.mounted) {
      _showUploadResultsDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1A73E8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.folder_special,
                color: Color(0xFF1A73E8),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prikriti File Manager',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202124),
                    letterSpacing: 0,
                  ),
                ),
                Text(
                  'Smart upload with duplicate detection',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF5F6368),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF5F6368)),
            onPressed: () {
              context.read<FileManagerProvider>().fetchUploadStats();
            },
            tooltip: 'Refresh Stats',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<FileManagerProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                // Top Section with File Selection & Summary
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // File Selection Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE8EAED),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A73E8).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.folder_open_rounded,
                                color: Color(0xFF1A73E8),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Selected Files',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF5F6368),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  if (provider.selectedFolderPath != null)
                                    _buildFolderPathTags(
                                      provider.selectedFolderPath!,
                                    )
                                  else
                                    const Text(
                                      'No files selected yet',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF9AA0A6),
                                        letterSpacing: 0,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed:
                                  provider.isLoading || provider.isUploading
                                  ? null
                                  : () => provider.selectAndLoadFiles(),
                              icon: const Icon(
                                Icons.file_copy_rounded,
                                size: 20,
                              ),
                              label: const Text('Browse'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A73E8),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Summary Cards Section
                      const Text(
                        'Upload Statistics',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF202124),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 140,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: 160,
                              child: SummaryCard(
                                title: 'Total Files',
                                value: provider.files.length.toString(),
                                icon: Icons.insert_drive_file_rounded,
                                color: const Color(0xFF1A73E8),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 160,
                              child: SummaryCard(
                                title: 'Uploaded',
                                value: provider
                                    .getFilesByStatus(UploadStatus.done)
                                    .length
                                    .toString(),
                                icon: Icons.check_circle_rounded,
                                color: const Color(0xFF34A853),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 160,
                              child: SummaryCard(
                                title: 'Failed',
                                value: provider
                                    .getFilesByStatus(UploadStatus.failed)
                                    .length
                                    .toString(),
                                icon: Icons.error_rounded,
                                color: const Color(0xFFEA4335),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 160,
                              child: SummaryCard(
                                title: 'Duplicates',
                                value: provider
                                    .getFilesByStatus(UploadStatus.duplicate)
                                    .length
                                    .toString(),
                                icon: Icons.content_copy_rounded,
                                color: const Color(0xFFFBBC04),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 160,
                              child: SummaryCard(
                                title: 'Pending',
                                value: provider
                                    .getFilesByStatus(UploadStatus.pending)
                                    .length
                                    .toString(),
                                icon: Icons.schedule_rounded,
                                color: const Color(0xFF5F6368),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Error Message Banner
                if (provider.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE8E6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFEA4335)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_rounded,
                          color: Color(0xFFEA4335),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            provider.errorMessage!,
                            style: const TextStyle(
                              color: Color(0xFFEA4335),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Loading State
                if (provider.isLoading)
                  Container(
                    height: 300,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: CircularProgressIndicator(
                              color: Color(0xFF1A73E8),
                              strokeWidth: 3,
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            'Loading files...',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF5F6368),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Empty State
                if (!provider.isLoading && provider.files.isEmpty)
                  Container(
                    height: 400,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F3F4),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: const Icon(
                              Icons.folder_open_rounded,
                              size: 64,
                              color: Color(0xFFBDC1C6),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'No files loaded yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF202124),
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Click "Browse" to select files for upload',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5F6368),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Files List Section
                if (!provider.isLoading && provider.files.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // File List Header with Search
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        color: Colors.white,
                        child: Column(
                          children: [
                            // Stats Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_getFilteredFiles(provider.files).length} of ${provider.files.length} file(s)',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF202124),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                Text(
                                  'Total size: ${provider.formattedTotalSize}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF5F6368),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Search Bar
                            Container(
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: _searchQuery.isNotEmpty
                                      ? const Color(0xFF1A73E8)
                                      : const Color(0xFFE8EAED),
                                  width: 1.5,
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      'Search files by name, extension, or size...',
                                  hintStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF9AA0A6),
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.2,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    color: Color(0xFF5F6368),
                                    size: 20,
                                  ),
                                  suffixIcon: _searchQuery.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.clear_rounded,
                                            color: Color(0xFF5F6368),
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _searchController.clear();
                                              _searchQuery = '';
                                            });
                                          },
                                          tooltip: 'Clear search',
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF202124),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // File List
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE8EAED),
                            width: 1,
                          ),
                        ),
                        child: Builder(
                          builder: (context) {
                            final filteredFiles = _getFilteredFiles(
                              provider.files,
                            );

                            if (filteredFiles.isEmpty &&
                                _searchQuery.isNotEmpty) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SingleChildScrollView(
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 200,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(32.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF1F3F4),
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: const Icon(
                                                Icons.search_off_rounded,
                                                size: 40,
                                                color: Color(0xFFBDC1C6),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            const Text(
                                              'No files found',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF202124),
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'No files match "${_searchQuery}"',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF5F6368),
                                                letterSpacing: 0.3,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              'Try a different search term',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF9AA0A6),
                                                letterSpacing: 0.2,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredFiles.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Color(0xFFE8EAED),
                                    ),
                                itemBuilder: (context, index) {
                                  final file = filteredFiles[index];
                                  return FileListItem(
                                    file: file,
                                    onRename: (newName) {
                                      provider.updateFileName(file.id, newName);
                                    },
                                    onRemove: () {
                                      provider.removeFile(file.id);
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
      // Bottom Action Bar
      bottomNavigationBar: Consumer<FileManagerProvider>(
        builder: (context, provider, child) {
          if (provider.files.isEmpty) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE8EAED), width: 1),
              ),
            ),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: provider.isUploading
                      ? null
                      : () => provider.clearFiles(),
                  icon: const Icon(Icons.clear_all_rounded, size: 20),
                  label: const Text('Clear All'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF5F6368),
                    side: const BorderSide(color: Color(0xFFDADCE0)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: provider.isUploading
                        ? null
                        : () => _handleUpload(context),
                    icon: provider.isUploading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.cloud_upload_rounded, size: 20),
                    label: Text(
                      provider.isUploading
                          ? 'Uploading...'
                          : 'Upload All Files',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF34A853),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
