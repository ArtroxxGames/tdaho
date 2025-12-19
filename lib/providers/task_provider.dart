import 'package:flutter/material.dart';
import 'package:myapp/models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [
    Task(
        title: 'Comprar comida para el perro',
        priority: TaskPriority.alta,
        dueDate: DateTime.now().add(const Duration(days: 1))),
    Task(
        title: 'Llamar al banco',
        priority: TaskPriority.media,
        status: TaskStatus.en_progreso,
        dueDate: DateTime.now()),
    Task(
        title: 'Terminar el informe de ventas',
        priority: TaskPriority.alta,
        description: 'Incluir gráficos del último trimestre.'),
    Task(
      title: 'Pagar la factura de la luz',
      priority: TaskPriority.baja,
      status: TaskStatus.completada,
    ),
  ];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    _sortTasks();
    notifyListeners();
  }

  void updateTask(Task oldTask, Task newTask) {
    final index = _tasks.indexOf(oldTask);
    if (index != -1) {
      _tasks[index] = newTask;
      _sortTasks();
      notifyListeners();
    }
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void toggleTaskStatus(Task task) {
    final newStatus = task.status == TaskStatus.completada
        ? TaskStatus.pendiente
        : TaskStatus.completada;
    final updatedTask = task.copyWith(status: newStatus);
    updateTask(task, updatedTask);
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      // Completadas van al final
      if (a.status == TaskStatus.completada && b.status != TaskStatus.completada) return 1;
      if (a.status != TaskStatus.completada && b.status == TaskStatus.completada) return -1;

      // Luego por prioridad
      if (a.priority.index < b.priority.index) return -1;
      if (a.priority.index > b.priority.index) return 1;

      // Finalmente por fecha de entrega (las más próximas primero)
      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      }
      if (a.dueDate != null) return -1; // Tareas con fecha van antes
      if (b.dueDate != null) return 1;

      return 0;
    });
  }
}
