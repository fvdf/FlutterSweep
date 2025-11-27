import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;
import '../models/project_info.dart';
import '../l10n/app_localizations.dart';
import 'log_service.dart';
import 'cleanup_service.dart';

class ArchiveService {
  final LogService _logService;
  final CleanupService _cleanupService;
  AppLocalizations? _l10n;

  ArchiveService(this._logService, this._cleanupService);

  void setLocalization(AppLocalizations l10n) {
    _l10n = l10n;
    _cleanupService.setLocalization(l10n);
  }

  Future<bool> archiveProject(
    ProjectInfo project,
    String archiveFolderPath,
  ) async {
    final l10n = _l10n;
    _logService.info(project.name, l10n?.logStartingArchive ?? 'Starting archive operation');

    try {
      // 1. Purger d'abord
      _logService.progress(project.name, l10n?.logPurgingTempFiles ?? 'Purging temporary files');
      final purgedSize = await _cleanupService.purgeProject(project);

      // 2. Créer le dossier d'archives si nécessaire
      final archiveDir = Directory(archiveFolderPath);
      if (!await archiveDir.exists()) {
        await archiveDir.create(recursive: true);
        _logService.info(project.name, l10n?.logCreatedArchiveFolder ?? 'Created archive folder');
      }

      // 3. Créer le nom du fichier zip
      final timestamp = DateTime.now().toIso8601String().split('T')[0];
      final zipFileName = '${project.name}_$timestamp.zip';
      final zipFilePath = path.join(archiveFolderPath, zipFileName);

      // 4. Créer l'archive
      _logService.progress(project.name, l10n?.logCreatingZip ?? 'Creating ZIP archive');
      await _createZipArchive(project.path, zipFilePath);

      // Vérifier que le zip a été créé
      final zipFile = File(zipFilePath);
      if (!await zipFile.exists()) {
        throw Exception('Failed to create ZIP file');
      }

      final zipSize = await zipFile.length();
      _logService.success(
        project.name,
        l10n?.logArchiveCreated(zipFileName) ?? 'Archive created: $zipFileName',
        sizeBytes: zipSize,
      );

      // 5. Supprimer le dossier d'origine
      _logService.progress(project.name, l10n?.logRemovingOriginal ?? 'Removing original project folder');
      final projectDir = Directory(project.path);
      await projectDir.delete(recursive: true);

      _logService.success(
        project.name,
        l10n?.logArchiveCompleted ?? 'Archive operation completed successfully',
        sizeBytes: purgedSize,
      );

      return true;
    } catch (e) {
      _logService.error(project.name, l10n?.logArchiveFailed(e.toString()) ?? 'Archive operation failed: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> archiveMultipleProjects(
    List<ProjectInfo> projects,
    String archiveFolderPath,
  ) async {
    final l10n = _l10n;
    _logService.info('SYSTEM', l10n?.logBulkArchiveStarted ?? 'Starting bulk archive operation');

    int totalFreed = 0;
    int successCount = 0;
    int errorCount = 0;
    final List<String> failedProjects = [];

    for (var project in projects) {
      try {
        // Warning pour projets sans Git
        if (!project.hasGit) {
          _logService.warning(
            project.name,
            l10n?.logNoGitWarning ?? 'No Git repository detected - archive will be the only copy',
          );
        }

        final success = await archiveProject(project, archiveFolderPath);
        if (success) {
          totalFreed += project.totalSizeBytes;
          successCount++;
        } else {
          errorCount++;
          failedProjects.add(project.name);
        }
      } catch (e) {
        _logService.error(project.name, l10n?.logArchiveFailed(e.toString()) ?? 'Archive failed: $e');
        errorCount++;
        failedProjects.add(project.name);
      }
    }

    _logService.success(
      'SYSTEM',
      l10n?.logBulkArchiveCompleted(successCount, errorCount) ??
        'Bulk archive completed: $successCount succeeded, $errorCount failed',
      sizeBytes: totalFreed,
    );

    return {
      'totalFreed': totalFreed,
      'successCount': successCount,
      'errorCount': errorCount,
      'failedProjects': failedProjects,
    };
  }

  Future<void> _createZipArchive(String sourcePath, String zipPath) async {
    final encoder = ZipFileEncoder();
    encoder.create(zipPath);

    await _addDirectoryToZip(encoder, sourcePath, '');

    encoder.close();
  }

  Future<void> _addDirectoryToZip(
    ZipFileEncoder encoder,
    String dirPath,
    String zipDirPath,
  ) async {
    final dir = Directory(dirPath);

    await for (var entity in dir.list(followLinks: false)) {
      final entityName = path.basename(entity.path);
      final zipEntityPath = zipDirPath.isEmpty ? entityName : '$zipDirPath/$entityName';

      if (entity is File) {
        await encoder.addFile(entity, zipEntityPath);
      } else if (entity is Directory) {
        await _addDirectoryToZip(encoder, entity.path, zipEntityPath);
      }
    }
  }

  String getDefaultArchivePath(String rootFolderPath) {
    // Utiliser le dossier Documents de l'utilisateur pour éviter les problèmes de permissions
    final homeDir = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (homeDir != null) {
      return path.join(homeDir, 'Documents', 'FlutterSweepArchives');
    }
    // Fallback: utiliser le dossier parent du root folder
    final parentDir = Directory(rootFolderPath).parent.path;
    return path.join(parentDir, 'FlutterSweepArchives');
  }
}
