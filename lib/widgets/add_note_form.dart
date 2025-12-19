import 'package:flutter/material.dart';
import 'package:myapp/models/note.dart';

class AddNoteForm extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;

  const AddNoteForm({super.key, this.note, required this.onSave});

  @override
  _AddNoteFormState createState() => _AddNoteFormState();
}

class _AddNoteFormState extends State<AddNoteForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _title = widget.note!.title;
      _content = widget.note!.content;
    } else {
      _title = '';
      _content = '';
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newNote = Note(
        id: widget.note?.id ?? DateTime.now().toString(),
        title: _title,
        content: _content,
      );
      widget.onSave(newNote);
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
              initialValue: _title,
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
              initialValue: _content,
              decoration: const InputDecoration(labelText: 'Contenido'),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduce contenido';
                }
                return null;
              },
              onSaved: (value) => _content = value!,
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
