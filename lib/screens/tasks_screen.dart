import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/providers/task_provider.dart';
import 'package:myapp/widgets/add_task_form.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  void _showTaskForm(BuildContext context, {Task? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddTaskForm(
            task: task,
            onSave: (newTask) {
              final provider = Provider.of<TaskProvider>(context, listen: false);
              if (task == null) {
                provider.addTask(newTask);
              } else {
                provider.updateTask(task, newTask);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.tasks,
              style: GoogleFonts.oswald(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  if (taskProvider.tasks.isEmpty) {
                    return Center(
                      child: Text(
                        '¡No tienes tareas pendientes!',
                        style: GoogleFonts.roboto(fontSize: 18, color: Colors.white70),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: taskProvider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = taskProvider.tasks[index];
                      return _buildTaskCard(context, task);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Añadir Tarea",
        onPressed: () => _showTaskForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.alta:
        return Colors.red.shade300;
      case TaskPriority.media:
        return Colors.orange.shade300;
      case TaskPriority.baja:
        return Colors.blue.shade300;
    }
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    final isCompleted = task.status == TaskStatus.completada;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isCompleted,
                  onChanged: (bool? value) {
                    Provider.of<TaskProvider>(context, listen: false)
                        .toggleTaskStatus(task);
                  },
                  activeColor: Colors.green.shade400,
                  checkColor: Colors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task.title,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: isCompleted ? Colors.white54 : Colors.white,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(task.priority),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.priority.name.toUpperCase(),
                    style: GoogleFonts.roboto(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (task.description != null && task.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 48, top: 4),
                child: Text(
                  task.description!,
                  style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (task.dueDate != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 48.0),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.white70),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat.yMMMd().format(task.dueDate!),
                          style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20, color: Colors.white70),
                      onPressed: () => _showTaskForm(context, task: task),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.white70),
                      onPressed: () {
                        Provider.of<TaskProvider>(context, listen: false)
                            .deleteTask(task);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
