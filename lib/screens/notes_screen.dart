import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/note.dart';
import 'package:myapp/providers/note_provider.dart';
import 'package:myapp/widgets/add_note_form.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  void _showNoteForm(BuildContext context, {Note? note}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddNoteForm(
            note: note,
            onSave: (newNote) {
              final provider = Provider.of<NoteProvider>(context, listen: false);
              if (note == null) {
                provider.addNote(newNote);
              } else {
                provider.updateNote(note, newNote);
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
            Text(
              l10n.notes,
              style: GoogleFonts.oswald(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<NoteProvider>(
                builder: (context, noteProvider, child) {
                  if (noteProvider.notes.isEmpty) {
                    return Center(
                      child: Text(
                        'No tienes notas guardadas.',
                        style: GoogleFonts.roboto(fontSize: 18, color: Colors.white70),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: noteProvider.notes.length,
                    itemBuilder: (context, index) {
                      final note = noteProvider.notes[index];
                      return _buildNoteCard(context, note);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteForm(context),
        child: const Icon(Icons.add),
        tooltip: "Añadir Nota",
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: Text(note.title, style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
        subtitle: Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white70),
              onPressed: () => _showNoteForm(context, note: note),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white70),
              onPressed: () {
                Provider.of<NoteProvider>(context, listen: false).deleteNote(note);
              },
            ),
          ],
        ),
        onTap: () => _showNoteForm(context, note: note),
      ),
    );
  }
}
