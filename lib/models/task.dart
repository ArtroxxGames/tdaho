
enum TaskPriority { baja, media, alta }

enum TaskStatus { pendiente, enProgreso, completada }

class Task {
  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? dueDate;
  final List<String> tags;
  bool isCompleted; // This will be replaced by status

  Task({
    required this.title,
    this.description,
    this.priority = TaskPriority.media,
    this.status = TaskStatus.pendiente,
    this.dueDate,
    this.tags = const [],
    this.isCompleted = false, // Keep for now for backward compatibility
  });
}
