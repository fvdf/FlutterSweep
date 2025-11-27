import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../repositories/settings_repository.dart';

class SettingsService {
  final SettingsRepository _repository;

  SettingsService(this._repository);

  Future<AppSettings> loadSettings() async {
    return await _repository.getSettings();
  }

  Future<void> setRootFolder(String path) async {
    await _repository.updateRootFolder(path);
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
