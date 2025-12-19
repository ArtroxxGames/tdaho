import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tdah_organizer/models/note.dart';
import 'package:tdah_organizer/providers/note_provider.dart';
import 'package:tdah_organizer/widgets/add_note_form.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  void _showAddNoteForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddNoteForm(onAdd: (title, content) {
            final newNote = Note(title: title, content: content);
            Provider.of<NoteProvider>(context, listen: false).addNote(newNote);
          }),
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
        onPressed: () => _showAddNoteForm(context),
        child: const Icon(Icons.add),
        tooltip: "Añadir Nota",
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              note.content,
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
