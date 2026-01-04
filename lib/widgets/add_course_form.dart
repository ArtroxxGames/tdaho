import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/course.dart';

class AddCourseForm extends StatefulWidget {
  final Course? course;
  final Function(Course) onSave;

  const AddCourseForm({
    super.key,
    this.course,
    required this.onSave,
  });

  @override
  State<AddCourseForm> createState() => _AddCourseFormState();
}

class _AddCourseFormState extends State<AddCourseForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _urlController;
  late TextEditingController _notesController;
  late TextEditingController _progressController;
  late TextEditingController _durationController;
  late TextEditingController _timeController;

  String _selectedPlatform = 'Udemy';
  List<int> _selectedDays = [];
  TimeOfDay? _selectedTime;

  final List<String> _platforms = [
    'Udemy',
    'Coursera',
    'Platzi',
    'Domestika',
    'LinkedIn Learning',
    'YouTube',
    'Skillshare',
    'edX',
    'FreeCodeCamp',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.course?.name ?? '');
    _urlController = TextEditingController(text: widget.course?.url ?? '');
    _notesController = TextEditingController(text: widget.course?.notes ?? '');
    _progressController = TextEditingController(
      text: widget.course?.progress.toString() ?? '0',
    );
    _durationController = TextEditingController(
      text: widget.course?.durationMinutes?.toString() ?? '',
    );
    _selectedPlatform = widget.course?.platform ?? 'Udemy';
    _selectedDays = List.from(widget.course?.studyDays ?? []);
    
    if (widget.course?.startTime != null) {
      final parts = widget.course!.startTime!.split(':');
      _selectedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
      _timeController = TextEditingController(text: widget.course!.startTime);
    } else {
      _timeController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    _progressController.dispose();
    _durationController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final course = Course(
        id: widget.course?.id,
        name: _nameController.text.trim(),
        platform: _selectedPlatform,
        url: _urlController.text.trim().isEmpty ? null : _urlController.text.trim(),
        studyDays: _selectedDays,
        startTime: _selectedTime != null
            ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
            : null,
        durationMinutes: _durationController.text.trim().isEmpty
            ? null
            : int.tryParse(_durationController.text.trim()),
        progress: int.tryParse(_progressController.text.trim()) ?? 0,
        isActive: widget.course?.isActive ?? true,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        createdAt: widget.course?.createdAt,
      );

      widget.onSave(course);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.course == null ? 'Nuevo Curso' : 'Editar Curso',
                  style: GoogleFonts.oswald(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del curso *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedPlatform,
                  decoration: const InputDecoration(
                    labelText: 'Plataforma *',
                    border: OutlineInputBorder(),
                  ),
                  items: _platforms.map((platform) {
                    return DropdownMenuItem(
                      value: platform,
                      child: Text(platform),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPlatform = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'URL del curso (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _progressController,
                  decoration: const InputDecoration(
                    labelText: 'Progreso (%)',
                    border: OutlineInputBorder(),
                    helperText: '0-100',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final progress = int.tryParse(value);
                      if (progress == null || progress < 0 || progress > 100) {
                        return 'El progreso debe estar entre 0 y 100';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Días de estudio',
                  style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (int i = 0; i < 7; i++)
                      FilterChip(
                        label: Text(Course.getDayName(i)),
                        selected: _selectedDays.contains(i),
                        onSelected: (_) => _toggleDay(i),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: 'Hora de inicio (opcional)',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  readOnly: true,
                  onTap: _selectTime,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duración en minutos (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notas (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar', style: GoogleFonts.roboto()),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _save,
                      child: Text('Guardar', style: GoogleFonts.roboto()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

