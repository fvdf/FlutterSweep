import 'dart:io';
import '../models/archive_info.dart';

class ArchiveManagerService {
  Future<List<ArchiveInfo>> getArchives(String archiveFolderPath) async {
    final List<ArchiveInfo> archives = [];
    final archiveDir = Directory(archiveFolderPath);

    if (!await archiveDir.exists()) {
      return archives;
    }

    try {
      await for (var entity in archiveDir.list()) {
        if (entity is File && entity.path.endsWith('.zip')) {
          final archiveInfo = await ArchiveInfo.fromFile(entity);
          if (archiveInfo != null) {
            archives.add(archiveInfo);
          }
        }
      }

      // Trier par date de création (plus récent en premier)
      archives.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      // Ignorer les erreurs de lecture
    }

    return archives;
  }

  Future<void> openInFinder(String archiveFolderPath) async {
    // Créer le dossier s'il n'existe pas
    final dir = Directory(archiveFolderPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    // Ouvrir dans Finder (macOS) ou Explorer (Windows)
    if (Platform.isMacOS) {
      await Process.run('open', [archiveFolderPath]);
    } else if (Platform.isWindows) {
      await Process.run('explorer', [archiveFolderPath]);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', [archiveFolderPath]);
    }
  }

  Future<void> deleteArchive(String archivePath) async {
    final file = File(archivePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
