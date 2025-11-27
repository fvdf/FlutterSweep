import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../l10n/app_localizations.dart';
import '../../services/settings_service.dart';
import '../../services/scan_service.dart';
import '../../services/log_service.dart';
import '../../services/cleanup_service.dart';
import '../../services/archive_service.dart';
import '../../repositories/settings_repository.dart';
import '../../repositories/project_repository.dart';
import '../../models/scan_summary.dart';
import '../../models/project_tag.dart';
import '../../models/project_info.dart';
import '../widgets/project_card.dart';
import '../widgets/logs_console.dart';
import 'settings_page.dart';
import 'archives_page.dart';

class HomePage extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  final Function(ThemeMode) onThemeModeChange;

  const HomePage({
    super.key,
    required this.onLocaleChange,
    required this.onThemeModeChange,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SettingsService _settingsService = SettingsService(SettingsRepository());
  final ProjectRepository _projectRepository = ProjectRepository();
  final LogService _logService = LogService();
  late final ScanService _scanService;
  late final CleanupService _cleanupService;
  late final ArchiveService _archiveService;

  String? _rootFolderPath;
  ScanSummary? _scanSummary;
  bool _isScanning = false;
  bool _isLoading = true;
  bool _isLogsExpanded = false;
  bool _isProcessing = false;

  // Filtres et recherche
  ProjectTag? _selectedTagFilter;
  String _searchQuery = '';
  String _sortBy = 'name'; // 'name', 'totalSize', 'purgeableSize', 'lastModified'

  @override
  void initState() {
    super.initState();
    _scanService = ScanService(_projectRepository);
    _cleanupService = CleanupService(_logService);
    _archiveService = ArchiveService(_logService, _cleanupService);
    _loadRootFolder();
  }

  @override
  void dispose() {
    _logService.dispose();
    super.dispose();
  }

  Future<void> _updateProjectTag(ProjectInfo project, ProjectTag newTag) async {
    await _projectRepository.setProjectTag(project.path, newTag);

    // Mettre à jour localement
    setState(() {
      final updatedProjects = _scanSummary!.projects.map((p) {
        if (p.path == project.path) {
          return p.copyWith(tag: newTag);
        }
        return p;
      }).toList();

      _scanSummary = ScanSummary(
        projects: updatedProjects,
        totalSizeBytes: _scanSummary!.totalSizeBytes,
        totalPurgeableBytes: _scanSummary!.totalPurgeableBytes,
        scannedAt: _scanSummary!.scannedAt,
      );
    });
  }

  Future<void> _loadRootFolder() async {
    final settings = await _settingsService.loadSettings();
    debugPrint('HomePage: Loaded root folder path: ${settings.rootFolderPath}');
    setState(() {
      _rootFolderPath = settings.rootFolderPath;
      _isLoading = false;
    });

    // Si un dossier racine existe, scanner automatiquement
    if (_rootFolderPath != null) {
      debugPrint('HomePage: Auto-scanning root folder');
      _performScan();
    } else {
      debugPrint('HomePage: No root folder found, showing welcome screen');
    }
  }

  Future<void> _selectRootFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      await _settingsService.setRootFolder(selectedDirectory);
      setState(() {
        _rootFolderPath = selectedDirectory;
      });
      _performScan();
    }
  }

  Future<void> _performScan() async {
    if (_rootFolderPath == null) return;

    setState(() {
      _isScanning = true;
    });

    try {
      final summary = await _scanService.scanRootFolder(_rootFolderPath!);
      setState(() {
        _scanSummary = summary;
        _isScanning = false;
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorScanning(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Mettre à jour la localisation des services
    _archiveService.setLocalization(l10n);
    _cleanupService.setLocalization(l10n);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.appTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          if (_rootFolderPath != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _isScanning ? null : _performScan,
              tooltip: l10n.rescan,
            ),
          IconButton(
            icon: const Icon(Icons.archive),
            onPressed: () async {
              final settings = await _settingsService.loadSettings();
              final archivePath = settings.archiveFolderPath ??
                  _archiveService.getDefaultArchivePath(_rootFolderPath ?? '');
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArchivesPage(
                      archiveFolderPath: archivePath,
                    ),
                  ),
                );
              }
            },
            tooltip: l10n.archives,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    onLocaleChange: widget.onLocaleChange,
                    onThemeModeChange: widget.onThemeModeChange,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _rootFolderPath == null
                ? _buildWelcomeScreen(l10n)
                : _buildProjectsView(l10n),
          ),
          if (_rootFolderPath != null)
            LogsConsole(
              logService: _logService,
              isExpanded: _isLogsExpanded,
              onToggle: () {
                setState(() {
                  _isLogsExpanded = !_isLogsExpanded;
                });
              },
            ),
        ],
      ),
      floatingActionButton: _rootFolderPath != null && _scanSummary != null
          ? _buildActionButtons(l10n)
          : null,
    );
  }

  Widget _buildWelcomeScreen(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_special,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.welcome,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              l10n.welcomeMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _selectRootFolder,
            icon: const Icon(Icons.folder_open),
            label: Text(l10n.chooseProjectFolder),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsView(AppLocalizations l10n) {
    if (_isScanning) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.scanning),
          ],
        ),
      );
    }

    if (_scanSummary == null || _scanSummary!.projects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(l10n.noProjectsFound),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _selectRootFolder,
              icon: const Icon(Icons.folder_open),
              label: Text(l10n.changeFolder),
            ),
          ],
        ),
      );
    }

    final filteredProjects = _getFilteredAndSortedProjects();

    return Column(
      children: [
        _buildDashboard(l10n),
        _buildFiltersBar(l10n),
        Expanded(
          child: filteredProjects.isEmpty
              ? Center(
                  child: Text(
                    'No projects match your filters',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredProjects.length,
                  itemBuilder: (context, index) {
                    final project = filteredProjects[index];
                    return ProjectCard(
                      project: project,
                      onTagChanged: (newTag) => _updateProjectTag(project, newTag),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDashboard(AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDashboardItem(
                  l10n.projectCount,
                  '${_scanSummary!.projectCount}',
                  Icons.folder,
                ),
                _buildDashboardItem(
                  l10n.totalSize,
                  _scanSummary!.formattedTotalSize,
                  Icons.storage,
                ),
                _buildDashboardItem(
                  l10n.purgeableSize,
                  _scanSummary!.formattedPurgeableSize,
                  Icons.cleaning_services,
                ),
              ],
            ),
            if (_scanSummary!.totalPurgeableBytes > 0) ...[
              const SizedBox(height: 16),
              Text(
                l10n.potentialSavings(_scanSummary!.formattedPurgeableSize),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildFiltersBar(AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Barre de recherche
            TextField(
              decoration: InputDecoration(
                hintText: l10n.search,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 12),

            // Filtres par tag
            Row(
              children: [
                Text(
                  'Filter:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: Text(l10n.all),
                          selected: _selectedTagFilter == null,
                          onSelected: (selected) {
                            setState(() {
                              _selectedTagFilter = null;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: Text(l10n.tagIntact),
                          selected: _selectedTagFilter == ProjectTag.intact,
                          onSelected: (selected) {
                            setState(() {
                              _selectedTagFilter = selected ? ProjectTag.intact : null;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: Text(l10n.tagPurgeSafe),
                          selected: _selectedTagFilter == ProjectTag.purgeSafe,
                          onSelected: (selected) {
                            setState(() {
                              _selectedTagFilter = selected ? ProjectTag.purgeSafe : null;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: Text(l10n.tagArchive),
                          selected: _selectedTagFilter == ProjectTag.archive,
                          onSelected: (selected) {
                            setState(() {
                              _selectedTagFilter = selected ? ProjectTag.archive : null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tri
            Row(
              children: [
                Text(
                  l10n.sortBy,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'name',
                        label: Text(l10n.sortByName),
                        icon: const Icon(Icons.sort_by_alpha, size: 16),
                      ),
                      ButtonSegment(
                        value: 'totalSize',
                        label: Text(l10n.sortBySize),
                        icon: const Icon(Icons.storage, size: 16),
                      ),
                      ButtonSegment(
                        value: 'purgeableSize',
                        label: Text(l10n.sortByPurgeable),
                        icon: const Icon(Icons.cleaning_services, size: 16),
                      ),
                      ButtonSegment(
                        value: 'lastModified',
                        label: Text(l10n.sortByDate),
                        icon: const Icon(Icons.calendar_today, size: 16),
                      ),
                    ],
                    selected: {_sortBy},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _sortBy = newSelection.first;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<ProjectInfo> _getFilteredAndSortedProjects() {
    if (_scanSummary == null) return [];

    var projects = _scanSummary!.projects;

    // Filtrer par tag
    if (_selectedTagFilter != null) {
      projects = projects.where((p) => p.tag == _selectedTagFilter).toList();
    }

    // Filtrer par recherche
    if (_searchQuery.isNotEmpty) {
      projects = projects.where((p) {
        return p.name.toLowerCase().contains(_searchQuery) ||
            p.path.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Trier
    switch (_sortBy) {
      case 'name':
        projects.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case 'totalSize':
        projects.sort((a, b) => b.totalSizeBytes.compareTo(a.totalSizeBytes));
        break;
      case 'purgeableSize':
        projects.sort((a, b) => b.purgeableSizeBytes.compareTo(a.purgeableSizeBytes));
        break;
      case 'lastModified':
        projects.sort((a, b) => b.lastModified.compareTo(a.lastModified));
        break;
    }

    return projects;
  }

  Widget _buildActionButtons(AppLocalizations l10n) {
    final purgeableProjects = _scanSummary!.projects
        .where((p) => p.tag == ProjectTag.purgeSafe)
        .toList();
    final archivableProjects = _scanSummary!.projects
        .where((p) => p.tag == ProjectTag.archive)
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (archivableProjects.isNotEmpty)
          FloatingActionButton.extended(
            onPressed: _isProcessing ? null : () => _confirmArchive(archivableProjects),
            icon: const Icon(Icons.archive),
            label: Text('${l10n.archiveProjects} (${archivableProjects.length})'),
            backgroundColor: Colors.blue,
            heroTag: 'archive',
          ),
        if (archivableProjects.isNotEmpty && purgeableProjects.isNotEmpty)
          const SizedBox(height: 12),
        if (purgeableProjects.isNotEmpty)
          FloatingActionButton.extended(
            onPressed: _isProcessing ? null : () => _confirmPurge(purgeableProjects),
            icon: const Icon(Icons.cleaning_services),
            label: Text('${l10n.purgeProjects} (${purgeableProjects.length})'),
            backgroundColor: Colors.orange,
            heroTag: 'purge',
          ),
      ],
    );
  }

  Future<void> _confirmPurge(List<ProjectInfo> projects) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.confirmPurge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.purgeMessage(projects.length)),
              const SizedBox(height: 12),
              ...projects.take(5).map((p) => Text('• ${p.name}')),
              if (projects.length > 5) Text(l10n.andMore(projects.length - 5)),
              const SizedBox(height: 12),
              const Text(
                'This will delete temporary build files and dependencies.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.purge),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await _performPurge(projects);
    }
  }

  Future<void> _performPurge(List<ProjectInfo> projects) async {
    setState(() {
      _isProcessing = true;
      _isLogsExpanded = true;
    });

    try {
      final result = await _cleanupService.purgeMultipleProjects(projects);

      // Re-scanner pour mettre à jour les tailles
      await _performScan();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Purge completed: ${result['successCount']} succeeded, '
              '${result['errorCount']} failed. '
              'Freed: ${_formatBytes(result['totalFreed'])}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.purgeFailedMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _confirmArchive(List<ProjectInfo> projects) async {
    final noGitProjects = projects.where((p) => !p.hasGit).toList();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.confirmArchive),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.archiveMessage(projects.length)),
                const SizedBox(height: 12),
                ...projects.take(5).map((p) => Text('• ${p.name}')),
                if (projects.length > 5) Text(l10n.andMore(projects.length - 5)),
                const SizedBox(height: 12),
                const Text(
                  'This will:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(l10n.archiveStep1),
                Text(l10n.archiveStep2),
                Text(l10n.archiveStep3),
                if (noGitProjects.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Warning: No Git Repository',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${noGitProjects.length} project(s) have no Git repository. '
                          'The archive will be your only copy!',
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.orange),
              child: Text(l10n.archive),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await _performArchive(projects);
    }
  }

  Future<void> _performArchive(List<ProjectInfo> projects) async {
    setState(() {
      _isProcessing = true;
      _isLogsExpanded = true;
    });

    try {
      final settings = await _settingsService.loadSettings();
      final archivePath = settings.archiveFolderPath ??
          _archiveService.getDefaultArchivePath(_rootFolderPath!);

      final result = await _archiveService.archiveMultipleProjects(
        projects,
        archivePath,
      );

      // Re-scanner pour mettre à jour la liste
      await _performScan();

      if (mounted) {
        final failedProjects = result['failedProjects'] as List<String>;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Archive completed: ${result['successCount']} succeeded, '
              '${result['errorCount']} failed. '
              'Freed: ${_formatBytes(result['totalFreed'])}'
              '${failedProjects.isNotEmpty ? '\nFailed: ${failedProjects.join(", ")}' : ''}',
            ),
            backgroundColor: result['errorCount'] == 0 ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.archiveFailedMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
