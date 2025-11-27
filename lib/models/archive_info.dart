import 'dart:io';

class ArchiveInfo {
  final String name;
  final String path;
  final int sizeBytes;
  final DateTime createdAt;

  ArchiveInfo({
    required this.name,
    required this.path,
    required this.sizeBytes,
    required this.createdAt,
  });

  String get formattedSize {
    if (sizeBytes >= 1073741824) {
      return '${(sizeBytes / 1073741824).toStringAsFixed(2)} GB';
    } else if (sizeBytes >= 1048576) {
      return '${(sizeBytes / 1048576).toStringAsFixed(2)} MB';
    } else if (sizeBytes >= 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '$sizeBytes B';
    }
  }

  String get projectName {
    // Extraire le nom du projet du nom du fichier (format: projectname_2025-11-27.zip)
    final parts = name.split('_');
    if (parts.length >= 2) {
      // Retirer la date et l'extension
      return parts.sublist(0, parts.length - 1).join('_');
    }
    return name.replaceAll('.zip', '');
  }

  static Future<ArchiveInfo?> fromFile(File file) async {
    try {
      final stat = await file.stat();
      return ArchiveInfo(
        name: file.uri.pathSegments.last,
        path: file.path,
        sizeBytes: stat.size,
        createdAt: stat.modified,
      );
    } catch (e) {
      return null;
    }
  }
}
