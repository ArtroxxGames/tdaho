import 'package:flutter/material.dart';
import 'package:myapp/models/note.dart';
import 'package:myapp/services/storage_service.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];

  NoteProvider() {
    _loadNotes();
  }

  List<Note> get notes => _notes;

  void _loadNotes() {
    _notes = StorageService.loadList<Note>(
      StorageService.notesBox,
      (json) => Note.fromJson(json),
    );

    // Si no hay datos, cargar datos de muestra
    if (_notes.isEmpty) {
      _notes = [
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
      _saveNotes();
    }
  }

  Future<void> _saveNotes() async {
    await StorageService.saveList(StorageService.notesBox, _notes);
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    _notes.add(note);
    await _saveNotes();
  }

  Future<void> updateNote(Note oldNote, Note newNote) async {
    final index = _notes.indexOf(oldNote);
    if (index != -1) {
      _notes[index] = newNote;
      await _saveNotes();
    }
  }

  Future<void> deleteNote(Note note) async {
    _notes.remove(note);
    await _saveNotes();
  }

  Future<void> deleteAll() async {
    _notes.clear();
    await _saveNotes();
  }
}
