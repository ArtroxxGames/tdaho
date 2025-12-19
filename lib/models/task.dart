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

  Task({
    String? id,
    required this.title,
    this.description,
    this.dueDate,
    this.priority = TaskPriority.media,
    this.status = TaskStatus.pendiente,
  }) : id = id ?? UniqueKey().toString();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskStatus? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }
}
