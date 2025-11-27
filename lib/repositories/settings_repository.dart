import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  static const String _boxName = 'settings';
  static const String _settingsKey = 'app_settings';

  Box get _box => Hive.box(_boxName);

  Future<AppSettings> getSettings() async {
    final data = _box.get(_settingsKey);
    if (data == null) {
      debugPrint('SettingsRepository: No settings found, returning defaults');
      return AppSettings();
    }
    debugPrint('SettingsRepository: Loading settings: $data');
    return AppSettings.fromMap(Map<String, dynamic>.from(data));
  }

  Future<void> saveSettings(AppSettings settings) async {
    final map = settings.toMap();
    debugPrint('SettingsRepository: Saving settings: $map');
    await _box.put(_settingsKey, map);
    await _box.flush(); // Force flush to disk
    debugPrint('SettingsRepository: Settings saved and flushed');
  }

  Future<void> updateRootFolder(String path) async {
    final settings = await getSettings();
    await saveSettings(settings.copyWith(rootFolderPath: path));
  }

  Future<void> updateArchiveFolder(String path) async {
    final settings = await getSettings();
    await saveSettings(settings.copyWith(archiveFolderPath: path));
  }

  Future<void> updateLanguage(String languageCode) async {
    final settings = await getSettings();
    await saveSettings(settings.copyWith(languageCode: languageCode));
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    final settings = await getSettings();
    await saveSettings(settings.copyWith(themeMode: themeMode));
  }
}
