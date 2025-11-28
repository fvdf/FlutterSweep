import 'package:flutter/material.dart';

class AppSettings {
  final String? rootFolderPath;
  final String? rootFolderBookmark; // For macOS secure bookmark
  final String? archiveFolderPath;
  final String languageCode;
  final ThemeMode themeMode;

  AppSettings({
    this.rootFolderPath,
    this.rootFolderBookmark,
    this.archiveFolderPath,
    this.languageCode = 'en',
    this.themeMode = ThemeMode.system,
  });

  AppSettings copyWith({
    String? rootFolderPath,
    String? rootFolderBookmark,
    String? archiveFolderPath,
    String? languageCode,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      rootFolderPath: rootFolderPath ?? this.rootFolderPath,
      rootFolderBookmark: rootFolderBookmark ?? this.rootFolderBookmark,
      archiveFolderPath: archiveFolderPath ?? this.archiveFolderPath,
      languageCode: languageCode ?? this.languageCode,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rootFolderPath': rootFolderPath,
      'rootFolderBookmark': rootFolderBookmark,
      'archiveFolderPath': archiveFolderPath,
      'languageCode': languageCode,
      'themeMode': themeMode.index,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      rootFolderPath: map['rootFolderPath'],
      rootFolderBookmark: map['rootFolderBookmark'],
      archiveFolderPath: map['archiveFolderPath'],
      languageCode: map['languageCode'] ?? 'en',
      themeMode: ThemeMode.values[map['themeMode'] ?? 0],
    );
  }
}
