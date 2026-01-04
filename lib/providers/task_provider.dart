import 'package:flutter/material.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/providers/log_provider.dart';
import 'package:myapp/services/storage_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  TaskProvider() {
    _loadTasks();
  }

  List<Task> get tasks => _tasks;

  void _loadTasks() {
    _tasks = StorageService.loadList<Task>(
      StorageService.tasksBox,
      (json) => Task.fromJson(json),
    );

    // Si no hay datos, cargar datos de muestra
    if (_tasks.isEmpty) {
      _tasks = [
        Task(
          title: 'Comprar comida para el perro',
          priority: TaskPriority.alta,
          dueDate: DateTime.now().add(const Duration(days: 1)),
        ),
        Task(
          title: 'Llamar al banco',
          priority: TaskPriority.media,
          status: TaskStatus.en_progreso,
          dueDate: DateTime.now(),
        ),
        Task(
          title: 'Terminar el informe de ventas',
          priority: TaskPriority.alta,
          description: 'Incluir gráficos del último trimestre.',
        ),
        Task(
          title: 'Pagar la factura de la luz',
          priority: TaskPriority.baja,
          status: TaskStatus.completada,
        ),
      ];
      _saveTasks();
    } else {
      _sortTasks();
    }
  }

  Future<void> _saveTasks() async {
    await StorageService.saveList(StorageService.tasksBox, _tasks);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    _sortTasks();
    await _saveTasks();
    LogProvider.instance?.info('Tareas', 'Nueva tarea creada: ${task.title}', metadata: {
      'prioridad': task.priority.name,
      'estado': task.status.name,
    });
  }

  Future<void> updateTask(Task oldTask, Task newTask) async {
    final index = _tasks.indexOf(oldTask);
    if (index != -1) {
      _tasks[index] = newTask;
      _sortTasks();
      await _saveTasks();
    }
  }

  Future<void> deleteTask(Task task) async {
    _tasks.remove(task);
    await _saveTasks();
    LogProvider.instance?.warning('Tareas', 'Tarea eliminada: ${task.title}');
  }

  Future<void> toggleTaskStatus(Task task) async {
    final newStatus = task.status == TaskStatus.completada
        ? TaskStatus.pendiente
        : TaskStatus.completada;
    final updatedTask = task.copyWith(status: newStatus);
    await updateTask(task, updatedTask);
  }

  Future<void> updateTaskStatus(Task task, TaskStatus newStatus) async {
    final updatedTask = task.copyWith(status: newStatus);
    await updateTask(task, updatedTask);
    
    // Log especial cuando se completa una tarea
    if (newStatus == TaskStatus.completada) {
      LogProvider.instance?.info('Tareas', '🎉 Tarea completada: ${task.title}');
    } else {
      LogProvider.instance?.debug('Tareas', 'Estado de tarea cambiado', metadata: {
        'tarea': task.title,
        'nuevoEstado': newStatus.name,
      });
    }
  }

  List<Task> getTasksByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  int getTaskCountByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).length;
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

  Future<void> deleteAll() async {
    _tasks.clear();
    await _saveTasks();
  }
}
