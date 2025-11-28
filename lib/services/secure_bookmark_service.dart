import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';

class SecureBookmarkService {
  final SecureBookmarks? _secureBookmarks;

  SecureBookmarkService()
      : _secureBookmarks =
            defaultTargetPlatform == TargetPlatform.macOS ? SecureBookmarks() : null;

  /// Crée un signet sécurisé pour un dossier donné (macOS seulement)
  Future<String?> createBookmark(String path) async {
    if (_secureBookmarks == null) return null;

    try {
      final file = File(path);
      if (!await file.exists()) {
        debugPrint('SecureBookmarkService: Directory does not exist: $path');
        // Essayons quand même si c'est un répertoire
        if (!await Directory(path).exists()) {
             return null;
        }
      }

      return await _secureBookmarks!.bookmark(File(path));
    } catch (e) {
      debugPrint('SecureBookmarkService: Error creating bookmark: $e');
      return null;
    }
  }

  /// Résout un signet et commence à accéder à la ressource (macOS seulement)
  /// Retourne le chemin résolu ou null si échec
  Future<String?> resolveAndStartAccessing(String bookmark) async {
    if (_secureBookmarks == null) return null;

    try {
      final resolvedFile = await _secureBookmarks!.resolveBookmark(bookmark);
      final startAccess = await _secureBookmarks!.startAccessingSecurityScopedResource(resolvedFile);

      if (startAccess) {
        debugPrint('SecureBookmarkService: Successfully started accessing: ${resolvedFile.path}');
        return resolvedFile.path;
      } else {
        debugPrint('SecureBookmarkService: Failed to start accessing resource');
        return null;
      }
    } catch (e) {
      debugPrint('SecureBookmarkService: Error resolving bookmark: $e');
      return null;
    }
  }

  /// Arrête d'accéder à la ressource
  Future<void> stopAccessing(String path) async {
      if (_secureBookmarks == null) return;
      try {
          await _secureBookmarks!.stopAccessingSecurityScopedResource(File(path));
      } catch (e) {
           debugPrint('SecureBookmarkService: Error stopping access: $e');
      }
  }
}
