import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes/data/model/cloud/cloud_note.dart';
import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NoteListView extends StatelessWidget {
  final NoteCallback onDeleteNote;
  final Iterable<CloudNote> notes;
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
        final note = notes.elementAt(index);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: ListTile(
            onTap: () {
              onTap(note);
            },
            title: Text(
              note.textTitle,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            subtitle: Text(
              note.textContent,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            trailing: GestureDetector(
              onTap: () async {
            final shouldDelete = await showDeleteDialog(context);
            if (shouldDelete) {
            onDeleteNote(note);
            }
            },
              child: SvgPicture.asset(
                'assets/svgs/Delete.svg',

              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

          ),
        );
      },
    );
  }
}
