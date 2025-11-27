import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'ui/pages/home_page.dart';
import 'services/settings_service.dart';
import 'repositories/settings_repository.dart';

class FlutterSweepApp extends StatefulWidget {
  const FlutterSweepApp({super.key});

  @override
  State<FlutterSweepApp> createState() => _FlutterSweepAppState();
}

class _FlutterSweepAppState extends State<FlutterSweepApp> {
  final SettingsService _settingsService = SettingsService(SettingsRepository());

  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _settingsService.loadSettings();
    setState(() {
      _locale = Locale(settings.languageCode);
      _themeMode = settings.themeMode;
      _isLoading = false;
    });
  }

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'FlutterSweep',
      debugShowCheckedModeBanner: false,

      // Localization
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('es'),
      ],

      // Theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _themeMode,

      // Routes
      home: HomePage(
        onLocaleChange: _setLocale,
        onThemeModeChange: _setThemeMode,
      ),
    );
  }
}
