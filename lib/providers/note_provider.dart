import 'package:flutter/material.dart';
import 'package:myapp/models/note.dart';

class NoteProvider with ChangeNotifier {
  final List<Note> _notes = [
    Note(
      id: '1',
      title: 'Idea para proyecto',
      content: 'Desarrollar una app que ayude a organizar tareas y finanzas.',
    ),
    Note(
      id: '2',
      title: 'Lista de la compra',
      content: 'Leche, huevos, pan, y algo de fruta.',
    ),
  ];

  List<Note> get notes => _notes;

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void updateNote(Note oldNote, Note newNote) {
    final index = _notes.indexOf(oldNote);
    if (index != -1) {
      _notes[index] = newNote;
      notifyListeners();
    }
  }

  void deleteNote(Note note) {
    _notes.remove(note);
    notifyListeners();
  }
}
