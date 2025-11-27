# FlutterSweep

FlutterSweep is a Flutter desktop application designed to help developers manage disk space by cleaning up temporary files from Flutter projects.

## Description

FlutterSweep helps you:
- Scan a folder containing multiple Flutter projects
- Calculate total and purgeable sizes for each project
- Identify which files can be safely removed (build artifacts, dependencies, etc.)
- Organize projects with tags (Intact, Purge Safe, Archive)
- Clean up disk space efficiently

## Current Status (Development in Progress)

### ✅ Completed Features (Phase 0-4) - Application Complète

- **Internationalization (i18n)**
  - English, French, and Spanish support
  - Easy language switching in settings
  - All UI elements fully localized

- **Theme Support**
  - Light theme
  - Dark theme
  - System theme (follows OS preference)

- **Settings Management**
  - Persistent settings using Hive
  - Language selection
  - Theme selection
  - Root folder configuration

- **Project Scanning**
  - Automatic detection of Flutter projects (via `pubspec.yaml` + `lib/`)
  - Size calculation for each project
  - Detection of purgeable folders:
    - `build/`
    - `.dart_tool/`
    - `ios/Pods/`
    - `ios/.symlinks/`
    - `android/.gradle/`
    - `android/app/build/`
  - Git repository detection
  - Last modification date tracking

- **Dashboard**
  - Project count
  - Total disk space used
  - Total purgeable space
  - Visual statistics

- **Tag Management**
  - Three tag types: Intact, Purge Safe, Archive
  - Visual tag editor in expandable project cards
  - Persistent tag storage
  - Warning for projects tagged for archive without Git

- **Project List**
  - Expandable cards with detailed information
  - Visual indicators (Git repository, file sizes, dates)
  - Tag assignment interface

- **Filtering & Sorting**
  - Filter by tag (All, Intact, Purge Safe, Archive)
  - Sort by: Name, Total Size, Purgeable Size, Last Modified
  - Search by project name or path
  - Real-time filtering

- **Purge Operations**
  - Bulk purge of projects tagged as "Purge Safe"
  - Safe deletion of temporary files (build, .dart_tool, etc.)
  - Confirmation dialog with project list
  - Real-time progress tracking
  - Automatic size recalculation after purge

- **Archive Operations**
  - Bulk archive of projects tagged as "Archive"
  - Three-step process: purge → ZIP → delete original
  - Warning system for projects without Git
  - Configurable archive folder location
  - Safe operation (ZIP created before deletion)
  - Failed projects tracking

- **Integrated Logs Console**
  - Real-time log streaming
  - Expandable/collapsible console
  - Color-coded log levels (Info, Success, Warning, Error, Progress)
  - Display of file sizes freed
  - Auto-scroll to latest logs
  - Clear logs functionality
  - Last 50 logs displayed
  - Fully localized (EN/FR)

- **Archives Management**
  - Dedicated archives page
  - View all archived projects
  - Display archive date and size
  - Open archive folder directly in Finder/Explorer
  - Delete archives functionality
  - Statistics (total archives, total size)
  - Archive folder location: `~/Documents/FlutterSweepArchives`

## Platform Support

- **macOS**: ✅ Tested and working
- **Windows**: 🔄 Planned (architecture supports it)
- **Linux**: 🔄 Planned (architecture supports it)

The application is currently developed and tested on macOS. Windows and Linux support is planned but not yet tested.

## Installation

### Prerequisites

- Flutter SDK (>=3.9.2)
- macOS (for now)
- Xcode (for macOS builds)

### Steps

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd fluttersweep
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate localization files:
   ```bash
   flutter gen-l10n
   ```

4. Run the application:
   ```bash
   flutter run -d macos
   ```

## Architecture

The application follows a clean architecture pattern:

```
lib/
├── main.dart                 # App entry point with Hive initialization
├── app.dart                  # MaterialApp configuration
├── models/                   # Data models
│   ├── app_settings.dart
│   ├── project_info.dart
│   ├── project_tag.dart
│   └── scan_summary.dart
├── repositories/             # Data persistence layer
│   ├── settings_repository.dart
│   └── project_repository.dart
├── services/                 # Business logic
│   ├── settings_service.dart
│   └── scan_service.dart
├── ui/                       # User interface
│   ├── pages/
│   │   ├── home_page.dart
│   │   └── settings_page.dart
│   └── widgets/
│       └── project_card.dart
└── l10n/                     # Localization files
    ├── app_en.arb
    └── app_fr.arb
```

## Development Roadmap

See [PLAN.md](PLAN.md) for the complete development plan.

### Phase 0: Setup ✅
- Dependencies and folder structure
- i18n and theme configuration

### Phase 1: Settings ✅
- Settings page
- Language and theme selection
- Persistent storage

### Phase 2: Scanning ✅
- Root folder selection
- Project detection and analysis
- Dashboard with statistics

### Phase 3: Tags and Filters ✅
- Tag assignment to projects
- Filtering by tag
- Sorting options
- Search functionality

### Phase 4: Cleanup Operations ✅
- Purge functionality
- Archive functionality
- Integrated logs console

### Phase 5: Polish and Release
- Testing on all platforms
- Documentation
- Open source preparation

## Technologies Used

- **Flutter**: Cross-platform UI framework
- **Hive**: Lightweight and fast key-value database
- **file_picker**: File and directory selection
- **archive**: ZIP file creation for archiving
- **path**: Cross-platform path manipulation
- **flutter_localizations**: Internationalization support

## Contributing

This project is currently in active development. Contributions will be welcome once the core features are complete.

## Download

### Latest Release

Download the latest version for your platform from the [Releases page](https://github.com/rudydubos/FlutterSweep/releases).

**Available Platforms:**
- **macOS**: Universal Binary (Intel + Apple Silicon)
  - Download `FlutterSweep-v{version}-macos-universal.zip`
  - Extract and move `fluttersweep.app` to Applications
  - Right-click and select "Open" on first launch (macOS security)

- **Windows**: x64
  - Download `FlutterSweep-v{version}-windows-x64.zip`
  - Extract to desired location
  - Run `fluttersweep.exe`

- **Linux**: x64 (requires GTK+ 3.0)
  - Download `FlutterSweep-v{version}-linux-x64.tar.gz`
  - Extract: `tar -xzf FlutterSweep-v{version}-linux-x64.tar.gz`
  - Ensure GTK+ 3.0 is installed: `sudo apt-get install libgtk-3-0`
  - Run: `./fluttersweep`

## License

[MIT License](LICENSE) - Copyright (c) 2025 FlutterSweep Contributors

## Warnings

⚠️ **Important Safety Notes:**
- FlutterSweep never deletes entire projects
- Only temporary/build files are removed during purge operations
- Archive operations create a ZIP backup before removing the original
- Projects tagged as "Intact" are never modified
- Always ensure projects are backed up (use Git!)

## Contact

For questions or feedback, please open an issue in the repository.

---

**Status**: ✅ Core Features Complete - Phase 4 Complete (Ready for Testing & Polish)
**Last Updated**: 2025-11-27
