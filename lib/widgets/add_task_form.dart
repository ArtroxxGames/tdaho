import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tdah_organizer/models/task.dart';

class AddTaskForm extends StatefulWidget {
  final Task? task; // Tarea existente para editar
  final Function(Task) onSave; // Callback que devuelve la tarea completa

  const AddTaskForm({required this.onSave, this.task, super.key});

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  TaskPriority _selectedPriority = TaskPriority.media;
  TaskStatus _selectedStatus = TaskStatus.pendiente;
  DateTime? _selectedDueDate;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final task = widget.task;

    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _tagsController = TextEditingController(text: task?.tags.join(', ') ?? '');
    _selectedPriority = task?.priority ?? TaskPriority.media;
    _selectedStatus = task?.status ?? TaskStatus.pendiente;
    _selectedDueDate = task?.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEditing ? 'Editar Tarea' : 'Añadir Nueva Tarea',
                style: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título de la Tarea'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor, introduce un título'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción (Opcional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TaskPriority>(
                      value: _selectedPriority,
                      decoration: const InputDecoration(labelText: 'Prioridad'),
                      items: TaskPriority.values.map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(priority.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _selectedPriority = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<TaskStatus>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(labelText: 'Estado'),
                      items: TaskStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _selectedStatus = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(labelText: 'Etiquetas (separadas por coma)'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDueDate == null
                          ? 'Sin fecha límite'
                          : 'Fecha Límite: ${DateFormat.yMd().format(_selectedDueDate!)}',
                      style: GoogleFonts.roboto(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: _pickDate,
                    tooltip: 'Seleccionar Fecha Límite',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(isEditing ? 'Guardar Cambios' : 'Añadir Tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDueDate) {
      setState(() => _selectedDueDate = pickedDate);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final savedTask = Task(
        title: _titleController.text,
        description: _descriptionController.text,
        priority: _selectedPriority,
        status: _selectedStatus,
        dueDate: _selectedDueDate,
        tags: tags,
        isCompleted: _selectedStatus == TaskStatus.completada,
      );

      widget.onSave(savedTask);
      Navigator.of(context).pop();
    }
  }
}
