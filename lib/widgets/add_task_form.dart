import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/task.dart';

class AddTaskForm extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const AddTaskForm({super.key, this.task, required this.onSave});

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String? _description;
  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.media;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTask = Task(
        id: widget.task?.id,
        title: _title,
        description: _description,
        dueDate: _dueDate,
        priority: _priority,
        status: widget.task?.status ?? TaskStatus.pendiente,
      );
      widget.onSave(newTask);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: widget.task?.title,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduce un título';
                }
                return null;
              },
              onSaved: (value) => _title = value!,
            ),
            TextFormField(
              initialValue: widget.task?.description,
              decoration: const InputDecoration(labelText: 'Descripción'),
              onSaved: (value) => _description = value,
            ),
            DropdownButtonFormField<TaskPriority>(
              value: _priority,
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Prioridad'),
            ),
            ListTile(
              title: Text(_dueDate == null
                  ? 'Sin fecha de entrega'
                  : DateFormat.yMMMd().format(_dueDate!)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dueDate = pickedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveForm,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
