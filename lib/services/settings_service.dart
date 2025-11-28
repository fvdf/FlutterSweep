import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../repositories/settings_repository.dart';
import 'secure_bookmark_service.dart';

class SettingsService {
  final SettingsRepository _repository;
  final SecureBookmarkService _secureBookmarkService = SecureBookmarkService();

  SettingsService(this._repository);

  Future<AppSettings> loadSettings() async {
    final settings = await _repository.getSettings();

    // Tenter de résoudre le signet si présent (macOS)
    if (settings.rootFolderPath != null && settings.rootFolderBookmark != null) {
      await _secureBookmarkService.resolveAndStartAccessing(settings.rootFolderBookmark!);
    }

    return settings;
  }

  Future<void> setRootFolder(String path) async {
    // Créer un signet si sur macOS
    final bookmark = await _secureBookmarkService.createBookmark(path);
    await _repository.updateRootFolder(path, bookmark: bookmark);
  }

  Future<void> setArchiveFolder(String path) async {
    await _repository.updateArchiveFolder(path);
  }

  Future<void> setLanguage(String languageCode) async {
    await _repository.updateLanguage(languageCode);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _repository.updateThemeMode(themeMode);
  }

  String? getRootFolder(AppSettings settings) {
    return settings.rootFolderPath;
  }

  String? getArchiveFolder(AppSettings settings) {
    return settings.archiveFolderPath;
  }

  Locale getLocale(AppSettings settings) {
    return Locale(settings.languageCode);
  }

  ThemeMode getThemeMode(AppSettings settings) {
    return settings.themeMode;
  }
}
