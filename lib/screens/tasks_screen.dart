import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tdah_organizer/models/task.dart';
import 'package:tdah_organizer/providers/task_provider.dart';
import 'package:tdah_organizer/widgets/add_task_form.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  void _showAddTaskForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddTaskForm(onAdd: (title) {
            final newTask = Task(title: title);
            Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
          }),
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
        onPressed: () => _showAddTaskForm(context),
        child: const Icon(Icons.add),
        tooltip: "Añadir Tarea",
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) {
                Provider.of<TaskProvider>(context, listen: false).toggleTaskStatus(task);
              },
              activeColor: Colors.green.shade400,
              checkColor: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: task.isCompleted ? Colors.white54 : Colors.white,
                  decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
