import 'package:flutter/material.dart';
import '../../services/crud/database_note.dart';
import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(DatabaseNote note);

class NoteListView extends StatelessWidget {
  final NoteCallback onDeleteNote;
  final List<DatabaseNote> notes;
  final NoteCallback onTap;
  const NoteListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            onTap: (){
              onTap(note);
            },
            leading: const Icon(Icons.note),
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete),
            ),
            tileColor: Colors.yellow.shade300,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
          ),
        );
      },
    );
  }
}
