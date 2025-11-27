import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../../models/project_info.dart';
import '../../models/project_tag.dart';

class ProjectCard extends StatelessWidget {
  final ProjectInfo project;
  final Function(ProjectTag) onTagChanged;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTagChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(
          project.hasGit ? Icons.folder_special : Icons.folder,
          color: Theme.of(context).colorScheme.primary,
          size: 32,
        ),
        title: Text(
          project.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              project.path,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.storage, size: 14, color: Theme.of(context).colorScheme.outline),
                const SizedBox(width: 4),
                Text(
                  project.formattedTotalSize,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(Icons.cleaning_services, size: 14, color: Theme.of(context).colorScheme.outline),
                const SizedBox(width: 4),
                Text(
                  project.formattedPurgeableSize,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: project.purgeableSizeBytes > 0
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                ),
              ],
            ),
          ],
        ),
        trailing: _buildTagChip(context, l10n),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informations détaillées
                _buildDetailRow(
                  context,
                  Icons.calendar_today,
                  l10n.lastModified,
                  dateFormat.format(project.lastModified),
                ),
                const SizedBox(height: 8),
                if (project.hasGit)
                  _buildDetailRow(
                    context,
                    Icons.source,
                    'Git',
                    'Repository detected',
                  ),
                const Divider(height: 24),

                // Sélection du tag
                Text(
                  'Project Tag',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: ProjectTag.values.map((tag) {
                    final isSelected = project.tag == tag;
                    return ChoiceChip(
                      label: Text(_getTagLabel(tag, l10n)),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          onTagChanged(tag);
                        }
                      },
                      avatar: isSelected ? const Icon(Icons.check, size: 16) : null,
                    );
                  }).toList(),
                ),

                // Warning pour Archive sans Git
                if (project.tag == ProjectTag.archive && !project.hasGit) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Warning: No Git repository detected. The archive will be your only local copy.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onErrorContainer,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(BuildContext context, AppLocalizations l10n) {
    Color chipColor;
    IconData chipIcon;

    switch (project.tag) {
      case ProjectTag.intact:
        chipColor = Colors.grey;
        chipIcon = Icons.lock;
        break;
      case ProjectTag.purgeSafe:
        chipColor = Colors.orange;
        chipIcon = Icons.cleaning_services;
        break;
      case ProjectTag.archive:
        chipColor = Colors.blue;
        chipIcon = Icons.archive;
        break;
    }

    return Chip(
      avatar: Icon(chipIcon, size: 16, color: chipColor),
      label: Text(
        _getTagLabel(project.tag, l10n),
        style: TextStyle(color: chipColor),
      ),
      backgroundColor: chipColor.withValues(alpha: 0.1),
      side: BorderSide(color: chipColor.withValues(alpha: 0.3)),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getTagLabel(ProjectTag tag, AppLocalizations l10n) {
    switch (tag) {
      case ProjectTag.intact:
        return l10n.tagIntact;
      case ProjectTag.purgeSafe:
        return l10n.tagPurgeSafe;
      case ProjectTag.archive:
        return l10n.tagArchive;
    }
  }
}
