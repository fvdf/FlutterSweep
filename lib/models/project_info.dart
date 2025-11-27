import 'project_tag.dart';

class ProjectInfo {
  final String name;
  final String path;
  final int totalSizeBytes;
  final int purgeableSizeBytes;
  final DateTime lastModified;
  final bool hasGit;
  final ProjectTag tag;

  ProjectInfo({
    required this.name,
    required this.path,
    required this.totalSizeBytes,
    required this.purgeableSizeBytes,
    required this.lastModified,
    required this.hasGit,
    this.tag = ProjectTag.intact,
  });

  ProjectInfo copyWith({
    String? name,
    String? path,
    int? totalSizeBytes,
    int? purgeableSizeBytes,
    DateTime? lastModified,
    bool? hasGit,
    ProjectTag? tag,
  }) {
    return ProjectInfo(
      name: name ?? this.name,
      path: path ?? this.path,
      totalSizeBytes: totalSizeBytes ?? this.totalSizeBytes,
      purgeableSizeBytes: purgeableSizeBytes ?? this.purgeableSizeBytes,
      lastModified: lastModified ?? this.lastModified,
      hasGit: hasGit ?? this.hasGit,
      tag: tag ?? this.tag,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'path': path,
      'totalSizeBytes': totalSizeBytes,
      'purgeableSizeBytes': purgeableSizeBytes,
      'lastModified': lastModified.toIso8601String(),
      'hasGit': hasGit,
      'tag': tag.toStorageString(),
    };
  }

  factory ProjectInfo.fromMap(Map<String, dynamic> map) {
    return ProjectInfo(
      name: map['name'] ?? '',
      path: map['path'] ?? '',
      totalSizeBytes: map['totalSizeBytes'] ?? 0,
      purgeableSizeBytes: map['purgeableSizeBytes'] ?? 0,
      lastModified: DateTime.parse(map['lastModified']),
      hasGit: map['hasGit'] ?? false,
      tag: ProjectTag.fromString(map['tag'] ?? 'intact'),
    );
  }

  String get formattedTotalSize => _formatBytes(totalSizeBytes);
  String get formattedPurgeableSize => _formatBytes(purgeableSizeBytes);

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
}
