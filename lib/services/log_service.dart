import 'dart:async';
import '../models/log_entry.dart';

class LogService {
  final _logsController = StreamController<LogEntry>.broadcast();
  final List<LogEntry> _logs = [];
  final int maxLogs = 100; // Garder les 100 derniers logs

  Stream<LogEntry> get logsStream => _logsController.stream;
  List<LogEntry> get allLogs => List.unmodifiable(_logs);

  void addLog(LogEntry entry) {
    _logs.add(entry);

    // Limiter la taille
    if (_logs.length > maxLogs) {
      _logs.removeAt(0);
    }

    _logsController.add(entry);
  }

  void info(String projectName, String message, {int? sizeBytes}) {
    addLog(LogEntry(
      timestamp: DateTime.now(),
      projectName: projectName,
      message: message,
      level: LogLevel.info,
      sizeBytes: sizeBytes,
    ));
  }

  void success(String projectName, String message, {int? sizeBytes}) {
    addLog(LogEntry(
      timestamp: DateTime.now(),
      projectName: projectName,
      message: message,
      level: LogLevel.success,
      sizeBytes: sizeBytes,
    ));
  }

  void warning(String projectName, String message, {int? sizeBytes}) {
    addLog(LogEntry(
      timestamp: DateTime.now(),
      projectName: projectName,
      message: message,
      level: LogLevel.warning,
      sizeBytes: sizeBytes,
    ));
  }

  void error(String projectName, String message, {int? sizeBytes}) {
    addLog(LogEntry(
      timestamp: DateTime.now(),
      projectName: projectName,
      message: message,
      level: LogLevel.error,
      sizeBytes: sizeBytes,
    ));
  }

  void progress(String projectName, String message, {int? sizeBytes}) {
    addLog(LogEntry(
      timestamp: DateTime.now(),
      projectName: projectName,
      message: message,
      level: LogLevel.progress,
      sizeBytes: sizeBytes,
    ));
  }

  void clear() {
    _logs.clear();
  }

  void dispose() {
    _logsController.close();
  }
}
