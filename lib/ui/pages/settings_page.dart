import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/app_settings.dart';
import '../../services/settings_service.dart';
import '../../repositories/settings_repository.dart';

class SettingsPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  final Function(ThemeMode) onThemeModeChange;

  const SettingsPage({
    super.key,
    required this.onLocaleChange,
    required this.onThemeModeChange,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsService _settingsService = SettingsService(SettingsRepository());
  AppSettings? _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _settingsService.loadSettings();
    setState(() {
      _settings = settings;
      _isLoading = false;
    });
  }

  Future<void> _updateLanguage(String languageCode) async {
    await _settingsService.setLanguage(languageCode);
    widget.onLocaleChange(Locale(languageCode));
    await _loadSettings();
  }

  Future<void> _updateThemeMode(ThemeMode themeMode) async {
    await _settingsService.setThemeMode(themeMode);
    widget.onThemeModeChange(themeMode);
    await _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.settings),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.language,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'en',
                        label: Text('English'),
                        icon: Icon(Icons.flag),
                      ),
                      ButtonSegment(
                        value: 'fr',
                        label: Text('Français'),
                        icon: Icon(Icons.flag),
                      ),
                      ButtonSegment(
                        value: 'es',
                        label: Text('Español'),
                        icon: Icon(Icons.flag),
                      ),
                    ],
                    selected: {_settings!.languageCode},
                    onSelectionChanged: (Set<String> newSelection) {
                      _updateLanguage(newSelection.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Theme Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.theme,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    segments: [
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text(l10n.themeLight),
                        icon: const Icon(Icons.light_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text(l10n.themeDark),
                        icon: const Icon(Icons.dark_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text(l10n.themeSystem),
                        icon: const Icon(Icons.settings_brightness),
                      ),
                    ],
                    selected: {_settings!.themeMode},
                    onSelectionChanged: (Set<ThemeMode> newSelection) {
                      _updateThemeMode(newSelection.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Archive Folder Section
          Card(
            child: ListTile(
              leading: const Icon(Icons.archive),
              title: Text(l10n.archiveFolder),
              subtitle: Text(
                _settings!.archiveFolderPath ?? 'Default',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.folder_open),
                onPressed: () {
                  // TODO: Implement folder selection
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Version Section
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.version),
              subtitle: const Text('1.0.0+1'),
            ),
          ),
        ],
      ),
    );
  }
}
