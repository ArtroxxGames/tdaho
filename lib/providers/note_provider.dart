import 'package:flutter/material.dart';
import 'package:tdah_organizer/models/note.dart';

class NoteProvider with ChangeNotifier {
  final List<Note> _notes = [
    Note(title: "Ideas para el proyecto", content: "Recordar investigar sobre animaciones en Flutter y paletas de colores."),
    Note(title: "Lista de compras", content: "Leche, pan, huevos, y mantequilla."),
    Note(title: "Reunión de equipo", content: "Lunes a las 10 AM. Preparar la presentación."),
    Note(title: "Recordatorio", content: "Llamar a mamá."),
  ];

  List<Note> get notes => _notes;

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }
}
