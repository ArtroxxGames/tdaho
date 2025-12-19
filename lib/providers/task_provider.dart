import 'package:flutter/material.dart';
import 'package:tdah_organizer/models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      title: "Pagar la tarjeta de crédito",
      description: "Revisar el estado de cuenta y pagar antes del vencimiento.",
      priority: TaskPriority.alta,
      status: TaskStatus.pendiente,
      dueDate: DateTime.now().add(const Duration(days: 5)),
      tags: ['finanzas', 'urgente'],
    ),
    Task(
      title: "Comprar víveres para la semana",
      description: "Leche, pan, huevos, frutas y verduras.",
      priority: TaskPriority.media,
      status: TaskStatus.completada,
      isCompleted: true, // Keep for compatibility
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      tags: ['hogar'],
    ),
    Task(
      title: "Llamar al médico para cita",
      description: "Agendar chequeo anual.",
      priority: TaskPriority.media,
      status: TaskStatus.enProgreso,
      tags: ['salud'],
    ),
    Task(
      title: "Terminar el informe del proyecto X",
      description: "Completar la sección de análisis y enviar a revisión.",
      priority: TaskPriority.alta,
      status: TaskStatus.pendiente,
      dueDate: DateTime.now().add(const Duration(days: 2)),
      tags: ['trabajo', 'proyecto'],
    ),
    Task(
      title: "Hacer ejercicio 30 minutos",
      priority: TaskPriority.baja,
      status: TaskStatus.pendiente,
      tags: ['salud', 'rutina'],
    ),
  ];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task oldTask, Task newTask) {
    final index = _tasks.indexOf(oldTask);
    if (index != -1) {
      _tasks[index] = newTask;
      notifyListeners();
    }
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void toggleTaskStatus(Task task) {
    final index = _tasks.indexOf(task);
    if (index != -1) {
      final currentTask = _tasks[index];
      final newStatus = currentTask.status == TaskStatus.completada
          ? TaskStatus.pendiente
          : TaskStatus.completada;

      _tasks[index] = Task(
          title: currentTask.title,
          description: currentTask.description,
          priority: currentTask.priority,
          status: newStatus,
          dueDate: currentTask.dueDate,
          tags: currentTask.tags,
          isCompleted: newStatus == TaskStatus.completada);
      notifyListeners();
    }
  }
}
