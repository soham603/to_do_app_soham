import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:play_store/data/firestore.dart';
import 'package:play_store/model/notes_model.dart';
import 'package:play_store/widgets/task_widget.dart';

class DoneNotes extends StatelessWidget {
  bool done;
  DoneNotes(this.done, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore_Datasource().stream(done),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final notesList = Firestore_Datasource().getNotes(snapshot);
        return ListView.builder(
          shrinkWrap: true,
          itemCount: notesList.length,
          itemBuilder: (context, index) {
            final note = notesList[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (direction){
                if (direction == DismissDirection.endToStart) {
                  final Note deletedNote = note; // Store the deleted note for undo
                  Firestore_Datasource().delete_note(note.id);

                  // Show a Snackbar with an Undo action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 30),
                      content: Text('Note deleted'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Perform undo action by adding the note back
                          Firestore_Datasource().AddNote(
                              deletedNote.title, deletedNote.subtitle,
                              deletedNote.image);
                        },
                      ),
                    ),
                  );
                }
              },
              child: TaskWidget(note),
            );
          },
        );
      },
    );
  }
}
