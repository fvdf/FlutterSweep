import 'project_info.dart';

class ScanSummary {
  final List<ProjectInfo> projects;
  final int totalSizeBytes;
  final int totalPurgeableBytes;
  final DateTime scannedAt;

  ScanSummary({
    required this.projects,
    required this.totalSizeBytes,
    required this.totalPurgeableBytes,
    required this.scannedAt,
  });

  int get projectCount => projects.length;

  String get formattedTotalSize => _formatBytes(totalSizeBytes);
  String get formattedPurgeableSize => _formatBytes(totalPurgeableBytes);

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  factory ScanSummary.empty() {
    return ScanSummary(
      projects: [],
      totalSizeBytes: 0,
      totalPurgeableBytes: 0,
      scannedAt: DateTime.now(),
    );
  }
}
