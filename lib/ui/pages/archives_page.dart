import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../../models/archive_info.dart';
import '../../services/archive_manager_service.dart';

class ArchivesPage extends StatefulWidget {
  final String archiveFolderPath;

  const ArchivesPage({
    super.key,
    required this.archiveFolderPath,
  });

  @override
  State<ArchivesPage> createState() => _ArchivesPageState();
}

class _ArchivesPageState extends State<ArchivesPage> {
  final ArchiveManagerService _archiveManagerService = ArchiveManagerService();
  List<ArchiveInfo> _archives = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArchives();
  }

  Future<void> _loadArchives() async {
    setState(() {
      _isLoading = true;
    });

    final archives = await _archiveManagerService.getArchives(widget.archiveFolderPath);

    setState(() {
      _archives = archives;
      _isLoading = false;
    });
  }

  Future<void> _openInFinder() async {
    try {
      await _archiveManagerService.openInFinder(widget.archiveFolderPath);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorOpeningFolder(e.toString()))),
        );
      }
    }
  }

  Future<void> _deleteArchive(ArchiveInfo archive) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.deleteArchiveMessage(archive.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _archiveManagerService.deleteArchive(archive.path);
        _loadArchives();
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.archiveDeleted)),
          );
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorDeletingArchive(e.toString()))),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalSize = _archives.fold<int>(0, (sum, archive) => sum + archive.sizeBytes);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.archivesPageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadArchives,
            tooltip: l10n.rescan,
          ),
        ],
      ),
      body: Column(
        children: [
          // En-tête avec informations
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.archiveFolderLocation,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.archiveFolderPath,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _openInFinder,
                      icon: const Icon(Icons.folder_open),
                      label: Text(l10n.openInFinder),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(
                      l10n.totalArchives,
                      _archives.length.toString(),
                      Icons.archive,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      l10n.totalArchivesSize,
                      _formatSize(totalSize),
                      Icons.storage,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Liste des archives
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _archives.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.archive_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noArchivesFound,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _archives.length,
                        itemBuilder: (context, index) {
                          final archive = _archives[index];
                          return _buildArchiveCard(archive, l10n);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArchiveCard(ArchiveInfo archive, AppLocalizations l10n) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.archive, size: 40),
        title: Text(
          archive.projectName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${l10n.archiveDate}: ${dateFormat.format(archive.createdAt)}'),
            Text('${l10n.archiveSize}: ${archive.formattedSize}'),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _deleteArchive(archive),
          tooltip: l10n.delete,
        ),
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes >= 1073741824) {
      return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
    } else if (bytes >= 1048576) {
      return '${(bytes / 1048576).toStringAsFixed(2)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '$bytes B';
    }
  }
}
