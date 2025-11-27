import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/project_info.dart';
import '../models/project_tag.dart';
import '../models/scan_summary.dart';
import '../repositories/project_repository.dart';

class ScanService {
  final ProjectRepository _projectRepository;

  // Liste des dossiers purgables selon le PLAN.md
  static const List<String> _purgeableFolders = [
    'build',
    '.dart_tool',
    'ios/Pods',
    'ios/.symlinks',
    'android/.gradle',
    'android/app/build',
  ];

  ScanService(this._projectRepository);

  Future<ScanSummary> scanRootFolder(String rootPath) async {
    final projects = await _findFlutterProjects(rootPath);
    final tags = await _projectRepository.getAllProjectTags();

    // Appliquer les tags sauvegardés
    final projectsWithTags = projects.map((project) {
      final tag = tags[project.path] ?? ProjectTag.intact;
      return project.copyWith(tag: tag);
    }).toList();

    final totalSize = projectsWithTags.fold<int>(
      0,
      (sum, project) => sum + project.totalSizeBytes,
    );

    final totalPurgeable = projectsWithTags.fold<int>(
      0,
      (sum, project) => sum + project.purgeableSizeBytes,
    );

    return ScanSummary(
      projects: projectsWithTags,
      totalSizeBytes: totalSize,
      totalPurgeableBytes: totalPurgeable,
      scannedAt: DateTime.now(),
    );
  }

  Future<List<ProjectInfo>> _findFlutterProjects(String rootPath) async {
    final List<ProjectInfo> projects = [];
    final rootDir = Directory(rootPath);

    if (!await rootDir.exists()) {
      return projects;
    }

    await for (var entity in rootDir.list(recursive: false)) {
      if (entity is Directory) {
        final isFlutterProject = await _isFlutterProject(entity.path);
        if (isFlutterProject) {
          final projectInfo = await _analyzeProject(entity.path);
          if (projectInfo != null) {
            projects.add(projectInfo);
          }
        }
      }
    }

    return projects;
  }

  Future<bool> _isFlutterProject(String dirPath) async {
    final pubspecFile = File(path.join(dirPath, 'pubspec.yaml'));
    final libDir = Directory(path.join(dirPath, 'lib'));

    return await pubspecFile.exists() && await libDir.exists();
  }

  Future<ProjectInfo?> _analyzeProject(String projectPath) async {
    try {
      final projectDir = Directory(projectPath);
      final name = path.basename(projectPath);

      // Calculer la taille totale
      final totalSize = await _calculateDirectorySize(projectPath);

      // Calculer la taille purgeable
      final purgeableSize = await _calculatePurgeableSize(projectPath);

      // Dernière modification
      final lastModified = await _getLastModified(projectPath);

      // Vérifier présence de .git
      final hasGit = await Directory(path.join(projectPath, '.git')).exists();

      return ProjectInfo(
        name: name,
        path: projectPath,
        totalSizeBytes: totalSize,
        purgeableSizeBytes: purgeableSize,
        lastModified: lastModified,
        hasGit: hasGit,
      );
    } catch (e) {
      print('Error analyzing project $projectPath: $e');
      return null;
    }
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
      print('Error calculating size for $dirPath: $e');
    }

    return totalSize;
  }

  Future<int> _calculatePurgeableSize(String projectPath) async {
    int purgeableSize = 0;

    for (var folder in _purgeableFolders) {
      final folderPath = path.join(projectPath, folder);
      final dir = Directory(folderPath);

      if (await dir.exists()) {
        purgeableSize += await _calculateDirectorySize(folderPath);
      }
    }

    return purgeableSize;
  }

  Future<DateTime> _getLastModified(String dirPath) async {
    DateTime lastModified = DateTime.fromMillisecondsSinceEpoch(0);
    final dir = Directory(dirPath);

    try {
      await for (var entity in dir.list(recursive: true, followLinks: false)) {
        try {
          final stat = await entity.stat();
          if (stat.modified.isAfter(lastModified)) {
            lastModified = stat.modified;
          }
        } catch (e) {
          // Ignorer les fichiers inaccessibles
        }
      }
    } catch (e) {
      print('Error getting last modified for $dirPath: $e');
    }

    return lastModified;
  }
}
