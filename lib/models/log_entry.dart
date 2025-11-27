enum LogLevel {
  info,
  success,
  warning,
  error,
  progress;

  String get displayName {
    switch (this) {
      case LogLevel.info:
        return 'INFO';
      case LogLevel.success:
        return 'SUCCESS';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.progress:
        return 'PROGRESS';
    }
  }
}

class LogEntry {
  final DateTime timestamp;
  final String projectName;
  final String message;
  final LogLevel level;
  final int? sizeBytes;

  LogEntry({
    required this.timestamp,
    required this.projectName,
    required this.message,
    required this.level,
    this.sizeBytes,
  });

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  String get formattedSize {
    if (sizeBytes == null) return '';

    if (sizeBytes! < 1024) return '${sizeBytes} B';
    if (sizeBytes! < 1024 * 1024) {
      return '${(sizeBytes! / 1024).toStringAsFixed(2)} KB';
    }
    if (sizeBytes! < 1024 * 1024 * 1024) {
      return '${(sizeBytes! / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(sizeBytes! / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  @override
  String toString() {
    final sizeStr = sizeBytes != null ? ' ($formattedSize)' : '';
    return '[$formattedTime] [$projectName] ${level.displayName} → $message$sizeStr';
  }
}
