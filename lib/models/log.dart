import 'package:flutter/material.dart';

enum LogLevel { debug, info, warning, error }

extension LogLevelExtension on LogLevel {
  String get displayName {
    switch (this) {
      case LogLevel.debug:
        return 'Debug';
      case LogLevel.info:
        return 'Info';
      case LogLevel.warning:
        return 'Warning';
      case LogLevel.error:
        return 'Error';
    }
  }

  IconData get icon {
    switch (this) {
      case LogLevel.debug:
        return Icons.bug_report;
      case LogLevel.info:
        return Icons.info_outline;
      case LogLevel.warning:
        return Icons.warning_amber;
      case LogLevel.error:
        return Icons.error_outline;
    }
  }

  Color get color {
    switch (this) {
      case LogLevel.debug:
        return Colors.grey;
      case LogLevel.info:
        return Colors.blue;
      case LogLevel.warning:
        return Colors.orange;
      case LogLevel.error:
        return Colors.red;
    }
  }
}

class AppLog {
  final String id;
  final LogLevel level;
  final String category;
  final String message;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  AppLog({
    String? id,
    required this.level,
    required this.category,
    required this.message,
    this.metadata,
    DateTime? createdAt,
  })  : id = id ?? UniqueKey().toString(),
        createdAt = createdAt ?? DateTime.now();

  AppLog copyWith({
    String? id,
    LogLevel? level,
    String? category,
    String? message,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return AppLog(
      id: id ?? this.id,
      level: level ?? this.level,
      category: category ?? this.category,
      message: message ?? this.message,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level.name,
      'category': category,
      'message': message,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppLog.fromJson(Map<String, dynamic> json) {
    return AppLog(
      id: json['id'] as String,
      level: LogLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => LogLevel.info,
      ),
      category: json['category'] as String,
      message: json['message'] as String,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'AppLog(level: ${level.name}, category: $category, message: $message)';
  }
}

