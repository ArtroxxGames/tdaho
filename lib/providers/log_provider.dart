import 'package:flutter/material.dart';
import 'package:myapp/models/log.dart';
import 'package:myapp/services/storage_service.dart';

class LogProvider with ChangeNotifier {
  List<AppLog> _logs = [];
  static LogProvider? _instance;

  LogProvider() {
    _instance = this;
    _loadLogs();
  }

  /// Singleton para acceso global al logger
  static LogProvider? get instance => _instance;

  List<AppLog> get logs => _logs;

  void _loadLogs() {
    _logs = StorageService.loadList<AppLog>(
      StorageService.logsBox,
      (json) => AppLog.fromJson(json),
    );
    _sortLogs();
  }

  Future<void> _saveLogs() async {
    await StorageService.saveList(StorageService.logsBox, _logs);
    notifyListeners();
  }

  void _sortLogs() {
    _logs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // ============ LOGGING METHODS ============

  Future<void> log({
    required LogLevel level,
    required String category,
    required String message,
    Map<String, dynamic>? metadata,
  }) async {
    final logEntry = AppLog(
      level: level,
      category: category,
      message: message,
      metadata: metadata,
    );
    _logs.insert(0, logEntry);
    await _saveLogs();
  }

  Future<void> debug(String category, String message, {Map<String, dynamic>? metadata}) async {
    await log(level: LogLevel.debug, category: category, message: message, metadata: metadata);
  }

  Future<void> info(String category, String message, {Map<String, dynamic>? metadata}) async {
    await log(level: LogLevel.info, category: category, message: message, metadata: metadata);
  }

  Future<void> warning(String category, String message, {Map<String, dynamic>? metadata}) async {
    await log(level: LogLevel.warning, category: category, message: message, metadata: metadata);
  }

  Future<void> error(String category, String message, {Map<String, dynamic>? metadata}) async {
    await log(level: LogLevel.error, category: category, message: message, metadata: metadata);
  }

  // ============ QUERY METHODS ============

  List<AppLog> getLogsByDate(DateTime date) {
    return _logs.where((log) {
      return log.createdAt.year == date.year &&
          log.createdAt.month == date.month &&
          log.createdAt.day == date.day;
    }).toList();
  }

  List<AppLog> getLogsByLevel(LogLevel level) {
    return _logs.where((log) => log.level == level).toList();
  }

  List<AppLog> getLogsByCategory(String category) {
    return _logs.where((log) => log.category == category).toList();
  }

  List<AppLog> getFilteredLogs({
    DateTime? date,
    LogLevel? level,
    String? category,
  }) {
    return _logs.where((log) {
      bool matches = true;
      
      if (date != null) {
        matches = matches &&
            log.createdAt.year == date.year &&
            log.createdAt.month == date.month &&
            log.createdAt.day == date.day;
      }
      
      if (level != null) {
        matches = matches && log.level == level;
      }
      
      if (category != null && category.isNotEmpty) {
        matches = matches && log.category == category;
      }
      
      return matches;
    }).toList();
  }

  /// Obtiene todas las categorías únicas
  List<String> get categories {
    return _logs.map((log) => log.category).toSet().toList()..sort();
  }

  /// Estadísticas de logs por día (últimos 14 días)
  Map<DateTime, Map<String, int>> getLast14DaysStats() {
    final now = DateTime.now();
    final stats = <DateTime, Map<String, int>>{};

    for (int i = 0; i < 14; i++) {
      final date = DateTime(now.year, now.month, now.day - i);
      final logsForDay = getLogsByDate(date);
      
      stats[date] = {
        'total': logsForDay.length,
        'debug': logsForDay.where((l) => l.level == LogLevel.debug).length,
        'info': logsForDay.where((l) => l.level == LogLevel.info).length,
        'warning': logsForDay.where((l) => l.level == LogLevel.warning).length,
        'error': logsForDay.where((l) => l.level == LogLevel.error).length,
      };
    }

    return stats;
  }

  /// Estadísticas del día específico
  Map<String, int> getStatsForDate(DateTime date) {
    final logsForDay = getLogsByDate(date);
    return {
      'total': logsForDay.length,
      'debug': logsForDay.where((l) => l.level == LogLevel.debug).length,
      'info': logsForDay.where((l) => l.level == LogLevel.info).length,
      'warning': logsForDay.where((l) => l.level == LogLevel.warning).length,
      'error': logsForDay.where((l) => l.level == LogLevel.error).length,
    };
  }

  // ============ MAINTENANCE METHODS ============

  /// Eliminar logs anteriores a X días
  Future<void> deleteLogsOlderThan(int days) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    _logs.removeWhere((log) => log.createdAt.isBefore(cutoffDate));
    await _saveLogs();
  }

  /// Eliminar todos los logs
  Future<void> deleteAll() async {
    _logs.clear();
    await _saveLogs();
  }

  /// Exportar logs a JSON
  List<Map<String, dynamic>> exportToJson({DateTime? fromDate, DateTime? toDate}) {
    var logsToExport = _logs;
    
    if (fromDate != null) {
      logsToExport = logsToExport.where((log) => 
        log.createdAt.isAfter(fromDate) || log.createdAt.isAtSameMomentAs(fromDate)
      ).toList();
    }
    
    if (toDate != null) {
      logsToExport = logsToExport.where((log) => 
        log.createdAt.isBefore(toDate) || log.createdAt.isAtSameMomentAs(toDate)
      ).toList();
    }
    
    return logsToExport.map((log) => log.toJson()).toList();
  }

  /// Cantidad total de logs
  int get totalLogs => _logs.length;

  /// Cantidad de errores
  int get errorCount => _logs.where((l) => l.level == LogLevel.error).length;

  /// Cantidad de warnings
  int get warningCount => _logs.where((l) => l.level == LogLevel.warning).length;
}

