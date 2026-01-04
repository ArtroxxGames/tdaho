import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/theme/app_colors.dart';

class AddTaskForm extends StatefulWidget {
  final Task? task;
  final TaskStatus? initialStatus;
  final Function(Task) onSave;

  const AddTaskForm({
    super.key,
    this.task,
    this.initialStatus,
    required this.onSave,
  });

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _etiquetaController = TextEditingController();
  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.media;
  TaskStatus _status = TaskStatus.pendiente;
  List<String> _etiquetas = [];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
      _status = widget.task!.status;
      _etiquetas = List<String>.from(widget.task!.etiquetas);
    } else if (widget.initialStatus != null) {
      _status = widget.initialStatus!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _etiquetaController.dispose();
    super.dispose();
  }

  void _addEtiqueta() {
    final etiqueta = _etiquetaController.text.trim();
    if (etiqueta.isNotEmpty && !_etiquetas.contains(etiqueta)) {
      setState(() {
        _etiquetas.add(etiqueta);
        _etiquetaController.clear();
      });
    }
  }

  void _removeEtiqueta(String etiqueta) {
    setState(() {
      _etiquetas.remove(etiqueta);
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: widget.task?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
        status: _status,
        etiquetas: _etiquetas,
      );
      widget.onSave(newTask);
      Navigator.of(context).pop();
    }
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.task == null ? 'Nueva Tarea' : 'Editar Tarea',
                    style: GoogleFonts.oswald(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Título
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppColors.bgSecondary,
                ),
                style: GoogleFonts.roboto(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, introduce un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Descripción
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppColors.bgSecondary,
                ),
                style: GoogleFonts.roboto(),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Prioridad
              Text(
                'Prioridad *',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: TaskPriority.values.map((priority) {
                  final isSelected = _priority == priority;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () => setState(() => _priority = priority),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _getPriorityColor(priority).withOpacity(0.2)
                                : AppColors.bgSecondary,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? _getPriorityColor(priority)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                priority == TaskPriority.alta
                                    ? Icons.priority_high
                                    : priority == TaskPriority.media
                                        ? Icons.remove
                                        : Icons.arrow_downward,
                                color: _getPriorityColor(priority),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                priority.name.toUpperCase(),
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _getPriorityColor(priority),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Estado
              Text(
                'Estado *',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<TaskStatus>(
                value: _status,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppColors.bgSecondary,
                ),
                items: TaskStatus.values.map((status) {
                  IconData icon;
                  Color color;
                  switch (status) {
                    case TaskStatus.pendiente:
                      icon = Icons.access_time;
                      color = Colors.orange;
                      break;
                    case TaskStatus.en_progreso:
                      icon = Icons.info_outline;
                      color = Colors.blue;
                      break;
                    case TaskStatus.completada:
                      icon = Icons.check_circle_outline;
                      color = Colors.green;
                      break;
                  }
                  return DropdownMenuItem(
                    value: status,
                    child: Row(
                      children: [
                        Icon(icon, color: color, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          status.name.replaceAll('_', ' ').toUpperCase(),
                          style: GoogleFonts.roboto(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _status = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              // Fecha límite
              InkWell(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() => _dueDate = pickedDate);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.bgSecondary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white70),
                      const SizedBox(width: 12),
                      Text(
                        _dueDate == null
                            ? 'Sin fecha de entrega'
                            : DateFormat.yMMMd().format(_dueDate!),
                        style: GoogleFonts.roboto(
                          color: _dueDate == null ? Colors.white54 : Colors.white,
                        ),
                      ),
                      const Spacer(),
                      if (_dueDate != null)
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => setState(() => _dueDate = null),
                          color: Colors.white54,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Etiquetas
              Text(
                'Etiquetas',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _etiquetaController,
                      decoration: InputDecoration(
                        hintText: 'Agregar etiqueta',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: AppColors.bgSecondary,
                      ),
                      style: GoogleFonts.roboto(),
                      onSubmitted: (_) => _addEtiqueta(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addEtiqueta,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.accentPrimary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              if (_etiquetas.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _etiquetas.map((etiqueta) {
                    return Chip(
                      label: Text(etiqueta, style: GoogleFonts.roboto(fontSize: 12)),
                      onDeleted: () => _removeEtiqueta(etiqueta),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      backgroundColor: AppColors.accentPrimary.withOpacity(0.2),
                      labelStyle: const TextStyle(color: Colors.white),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 24),
              // Botón guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Guardar',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
