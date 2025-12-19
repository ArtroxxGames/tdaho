import 'package:flutter/material.dart';
import 'package:tdah_organizer/models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [
    Task(title: "Pagar la tarjeta de crédito", isCompleted: false),
    Task(title: "Comprar víveres", isCompleted: true),
    Task(title: "Llamar al médico", isCompleted: false),
    Task(title: "Terminar el informe del proyecto", isCompleted: false),
  ];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTaskStatus(Task task) {
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }
}
