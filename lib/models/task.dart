import 'package:flutter/material.dart';

enum TaskPriority { alta, media, baja }

enum TaskStatus { pendiente, en_progreso, completada }

class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final List<String> etiquetas;

  Task({
    String? id,
    required this.title,
    this.description,
    this.dueDate,
    this.priority = TaskPriority.media,
    this.status = TaskStatus.pendiente,
    List<String>? etiquetas,
  }) : id = id ?? UniqueKey().toString(),
       etiquetas = etiquetas ?? [];

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskStatus? status,
    List<String>? etiquetas,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      etiquetas: etiquetas ?? this.etiquetas,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.name,
      'status': status.name,
      'etiquetas': etiquetas,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TaskPriority.media,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TaskStatus.pendiente,
      ),
      etiquetas: json['etiquetas'] != null
          ? List<String>.from(json['etiquetas'] as List)
          : [],
    );
  }
}
