import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/project_info.dart';
import '../l10n/app_localizations.dart';
import 'log_service.dart';

class CleanupService {
  final LogService _logService;
  AppLocalizations? _l10n;

  // Liste des dossiers purgables (même que dans ScanService)
  static const List<String> _purgeableFolders = [
    'build',
    '.dart_tool',
    'ios/Pods',
    'ios/.symlinks',
    'android/.gradle',
    'android/app/build',
  ];

  CleanupService(this._logService);

  void setLocalization(AppLocalizations l10n) {
    _l10n = l10n;
  }

  Future<int> purgeProject(ProjectInfo project) async {
    final l10n = _l10n;
    _logService.info(project.name, l10n?.logStartingPurge ?? 'Starting purge operation');
    int totalFreed = 0;

    for (var folder in _purgeableFolders) {
      final folderPath = path.join(project.path, folder);
      final dir = Directory(folderPath);

      if (await dir.exists()) {
        try {
          // Calculer la taille avant suppression
          final size = await _calculateDirectorySize(folderPath);

          // Supprimer le dossier
          await dir.delete(recursive: true);

          totalFreed += size;
          _logService.success(
            project.name,
            l10n?.logPurgingFolder(folder) ?? 'Purging: $folder',
            sizeBytes: size,
          );
        } catch (e) {
          _logService.error(
            project.name,
            l10n?.logPurgeFailed(e.toString()) ?? 'Purge failed: $e',
          );
        }
      }
    }

    if (totalFreed > 0) {
      _logService.success(
        project.name,
        l10n?.logPurgeCompleted ?? 'Purge completed successfully',
        sizeBytes: totalFreed,
      );
    } else {
      _logService.info(project.name, l10n?.logPurgeCompleted ?? 'No purgeable folders found');
    }

    return totalFreed;
  }

  Future<Map<String, dynamic>> purgeMultipleProjects(
    List<ProjectInfo> projects,
  ) async {
    final l10n = _l10n;
    _logService.info('SYSTEM', l10n?.logBulkPurgeStarted ?? 'Starting bulk purge operation');

    int totalFreed = 0;
    int successCount = 0;
    int errorCount = 0;

    for (var project in projects) {
      try {
        final freed = await purgeProject(project);
        totalFreed += freed;
        successCount++;
      } catch (e) {
        _logService.error(project.name, l10n?.logPurgeFailed(e.toString()) ?? 'Purge failed: $e');
        errorCount++;
      }
    }

    _logService.success(
      'SYSTEM',
      l10n?.logBulkPurgeCompleted(successCount, errorCount) ??
        'Bulk purge completed: $successCount succeeded, $errorCount failed',
      sizeBytes: totalFreed,
    );

    return {
      'totalFreed': totalFreed,
      'successCount': successCount,
      'errorCount': errorCount,
    };
  }

  Future<int> _calculateDirectorySize(String dirPath) async {
    int totalSize = 0;
    final dir = Directory(dirPath);

    try {
      await for (var entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          try {
            final stat = await entity.stat();
            totalSize += stat.size;
          } catch (e) {
            // Ignorer les fichiers inaccessibles
          }
        }
      }
    } catch (e) {
      // Ignorer les erreurs
    }

    return totalSize;
  }
}
