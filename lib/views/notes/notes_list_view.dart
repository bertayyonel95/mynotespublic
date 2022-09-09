import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final List<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;
  final int sortVar;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
    required this.sortVar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        switch (sortVar) {
          case 1:
            notes.sort(
              (a, b) {
                return a.text.compareTo(b.text);
              },
            );
            break;
          case 2:
            notes.sort(
              (a, b) {
                return b.text.compareTo(a.text);
              },
            );
            break;
          case 3:
            notes.sort(
              (a, b) {
                return a.date.compareTo(b.date);
              },
            );
            break;
          case 4:
            notes.sort(
              (a, b) {
                return b.date.compareTo(a.date);
              },
            );
            break;
          default:
        }
        final note = notes.elementAt(index);
        return ListTile(
            onTap: () {
              onTap(note);
            },
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete),
            ));
      },
    );
  }
}
