import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/providers/task_provider.dart';
import 'package:myapp/widgets/add_task_form.dart';
import 'package:myapp/theme/app_colors.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  void _showTaskForm(BuildContext context, {Task? task, TaskStatus? initialStatus}) {
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
            initialStatus: initialStatus,
            onSave: (newTask) async {
              final provider = Provider.of<TaskProvider>(context, listen: false);
              if (task == null) {
                await provider.addTask(newTask);
              } else {
                await provider.updateTask(task, newTask);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.tasks,
                  style: GoogleFonts.oswald(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Consumer<TaskProvider>(
                  builder: (context, provider, child) {
                    final enProgreso = provider.getTaskCountByStatus(TaskStatus.en_progreso);
                    if (enProgreso >= 3) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade900.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade400),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info_outline, size: 16, color: Colors.orange.shade300),
                            const SizedBox(width: 6),
                            Text(
                              'Límite: $enProgreso/3',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: Colors.orange.shade300,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Stats por columna
            Consumer<TaskProvider>(
              builder: (context, provider, child) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Pendientes',
                        provider.getTaskCountByStatus(TaskStatus.pendiente),
                        Colors.orange,
                        Icons.access_time,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'En Progreso',
                        provider.getTaskCountByStatus(TaskStatus.en_progreso),
                        Colors.blue,
                        Icons.info_outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Completadas',
                        provider.getTaskCountByStatus(TaskStatus.completada),
                        Colors.green,
                        Icons.check_circle_outline,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            // Vista Kanban
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, provider, child) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildKanbanColumn(
                          context,
                          'Pendientes',
                          TaskStatus.pendiente,
                          Colors.orange,
                          Icons.access_time,
                          provider.getTasksByStatus(TaskStatus.pendiente),
                          provider,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildKanbanColumn(
                          context,
                          'En Progreso',
                          TaskStatus.en_progreso,
                          Colors.blue,
                          Icons.info_outline,
                          provider.getTasksByStatus(TaskStatus.en_progreso),
                          provider,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildKanbanColumn(
                          context,
                          'Completadas',
                          TaskStatus.completada,
                          Colors.green,
                          Icons.check_circle_outline,
                          provider.getTasksByStatus(TaskStatus.completada),
                          provider,
                        ),
                      ),
                    ],
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

  Widget _buildStatCard(BuildContext context, String title, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: GoogleFonts.oswald(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanColumn(
    BuildContext context,
    String title,
    TaskStatus status,
    Color color,
    IconData icon,
    List<Task> tasks,
    TaskProvider provider,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.oswald(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tasks.length.toString(),
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Lista de tareas
          Expanded(
            child: DragTarget<Task>(
              onAccept: (draggedTask) {
                // Validar límite de 3 tareas en progreso
                if (status == TaskStatus.en_progreso) {
                  final enProgreso = provider.getTaskCountByStatus(TaskStatus.en_progreso);
                  if (enProgreso >= 3 && draggedTask.status != TaskStatus.en_progreso) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Límite de 3 tareas "En Progreso" alcanzado. Tip TDAH: Completa una tarea antes de empezar otra.',
                          style: GoogleFonts.roboto(),
                        ),
                        backgroundColor: Colors.orange.shade700,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    return;
                  }
                }
                provider.updateTaskStatus(draggedTask, status);
              },
              builder: (context, candidateData, rejectedData) {
                final isDraggingOver = candidateData.isNotEmpty;
                return Container(
                  decoration: BoxDecoration(
                    color: isDraggingOver
                        ? color.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: tasks.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(icon, color: Colors.white24, size: 48),
                                const SizedBox(height: 8),
                                Text(
                                  'Sin tareas',
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.white38,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () => _showTaskForm(context, initialStatus: status),
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Agregar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: color.withOpacity(0.2),
                                    foregroundColor: color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            return _buildTaskCard(context, tasks[index], provider, color);
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task, TaskProvider provider, Color columnColor) {
    final priorityColor = _getPriorityColor(task.priority);
    final isCompleted = task.status == TaskStatus.completada;

    return LongPressDraggable<Task>(
      data: task,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.05,
          child: Opacity(
            opacity: 0.9,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.28,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.bgSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(color: priorityColor, width: 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: _buildTaskCardContent(context, task, provider, columnColor, priorityColor, isCompleted),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: priorityColor, width: 4),
            ),
          ),
          child: _buildTaskCardContent(context, task, provider, columnColor, priorityColor, isCompleted),
        ),
      ),
      child: Container(
        key: ValueKey(task.id),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: priorityColor, width: 4),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showTaskForm(context, task: task),
            child: _buildTaskCardContent(context, task, provider, columnColor, priorityColor, isCompleted),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCardContent(
    BuildContext context,
    Task task,
    TaskProvider provider,
    Color columnColor,
    Color priorityColor,
    bool isCompleted,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título y prioridad
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.white54 : Colors.white,
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  task.priority.name.toUpperCase(),
                  style: GoogleFonts.roboto(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: priorityColor,
                  ),
                ),
              ),
            ],
          ),
          // Descripción
          if (task.description != null && task.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              task.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
          // Etiquetas
          if (task.etiquetas.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: task.etiquetas.map((etiqueta) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: columnColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    etiqueta,
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      color: columnColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          // Fecha límite y acciones
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (task.dueDate != null)
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.white54),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat.yMMMd().format(task.dueDate!),
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                )
              else
                const SizedBox.shrink(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botón mover a siguiente estado
                  if (task.status != TaskStatus.completada)
                    IconButton(
                      icon: Icon(
                        task.status == TaskStatus.pendiente
                            ? Icons.arrow_forward
                            : Icons.check,
                        size: 18,
                        color: columnColor,
                      ),
                      onPressed: () async {
                        final newStatus = task.status == TaskStatus.pendiente
                            ? TaskStatus.en_progreso
                            : TaskStatus.completada;
                        
                        // Validar límite de 3 tareas en progreso
                        if (newStatus == TaskStatus.en_progreso) {
                          final enProgreso = provider.getTaskCountByStatus(TaskStatus.en_progreso);
                          if (enProgreso >= 3) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Límite de 3 tareas "En Progreso" alcanzado. Tip TDAH: Completa una tarea antes de empezar otra.',
                                    style: GoogleFonts.roboto(),
                                  ),
                                  backgroundColor: Colors.orange.shade700,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                            return;
                          }
                        }
                        
                        await provider.updateTaskStatus(task, newStatus);
                      },
                      tooltip: task.status == TaskStatus.pendiente
                          ? 'Mover a En Progreso'
                          : 'Marcar como Completada',
                    ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18, color: Colors.white54),
                    onPressed: () => _showTaskForm(context, task: task),
                    tooltip: 'Editar',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Eliminar tarea', style: GoogleFonts.oswald()),
                          content: Text(
                            '¿Estás seguro de eliminar "${task.title}"?',
                            style: GoogleFonts.roboto(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Cancelar', style: GoogleFonts.roboto()),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text('Eliminar', style: GoogleFonts.roboto()),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await provider.deleteTask(task);
                      }
                    },
                    tooltip: 'Eliminar',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.alta:
        return Colors.red.shade400;
      case TaskPriority.media:
        return Colors.orange.shade400;
      case TaskPriority.baja:
        return Colors.green.shade400;
    }
  }
}
