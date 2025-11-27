import 'package:flutter/material.dart';
import '../../models/log_entry.dart';
import '../../services/log_service.dart';

class LogsConsole extends StatefulWidget {
  final LogService logService;
  final bool isExpanded;
  final VoidCallback onToggle;

  const LogsConsole({
    super.key,
    required this.logService,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  State<LogsConsole> createState() => _LogsConsoleState();
}

class _LogsConsoleState extends State<LogsConsole> {
  final ScrollController _scrollController = ScrollController();
  final List<LogEntry> _logs = [];

  @override
  void initState() {
    super.initState();
    widget.logService.logsStream.listen((log) {
      if (mounted) {
        setState(() {
          _logs.add(log);
          // Garder seulement les 50 derniers pour l'affichage
          if (_logs.length > 50) {
            _logs.removeAt(0);
          }
        });

        // Auto-scroll vers le bas
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Color _getLogColor(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return Colors.blue;
      case LogLevel.success:
        return Colors.green;
      case LogLevel.warning:
        return Colors.orange;
      case LogLevel.error:
        return Colors.red;
      case LogLevel.progress:
        return Colors.purple;
    }
  }

  IconData _getLogIcon(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return Icons.info_outline;
      case LogLevel.success:
        return Icons.check_circle_outline;
      case LogLevel.warning:
        return Icons.warning_amber_rounded;
      case LogLevel.error:
        return Icons.error_outline;
      case LogLevel.progress:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: widget.isExpanded ? 250 : 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: widget.onToggle,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    widget.isExpanded ? Icons.expand_more : Icons.expand_less,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.terminal,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Logs Console',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  if (_logs.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_logs.length}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.clear_all, size: 20),
                    onPressed: () {
                      setState(() {
                        _logs.clear();
                      });
                      widget.logService.clear();
                    },
                    tooltip: 'Clear logs',
                  ),
                ],
              ),
            ),
          ),

          // Logs content
          if (widget.isExpanded)
            Expanded(
              child: _logs.isEmpty
                  ? Center(
                      child: Text(
                        'No logs yet',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        final log = _logs[index];
                        return _buildLogEntry(log);
                      },
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogEntry(LogEntry log) {
    final color = _getLogColor(log.level);
    final icon = _getLogIcon(log.level);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time
          Text(
            log.formattedTime,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(width: 6),

          // Icon
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),

          // Project name
          Container(
            constraints: const BoxConstraints(minWidth: 80, maxWidth: 140),
            child: Text(
              log.projectName,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),

          // Message
          Expanded(
            child: Text(
              log.message,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                color: Theme.of(context).colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Size
          if (log.sizeBytes != null) ...[
            const SizedBox(width: 6),
            Text(
              log.formattedSize,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
