import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/constants/route.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/crud/notes_service.dart';
import '../../services/crud/database_note.dart';
import 'components/pop_up_button.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NoteService _noteService;
  //we are sure every user who will use this note will definitely have an email.
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _noteService = NoteService();
    _noteService.open();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _noteService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Note',
            style:
                TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 18),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newNoteRoute);
              },
              icon: Icon(Icons.add),
            ),
            PopUpButton(),
          ],
        ),
        body: FutureBuilder(
            future: _noteService.getOrCreateUser(email: userEmail),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return StreamBuilder(
                      stream: _noteService.allNotes,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              final allNote =
                                  snapshot.data as List<DatabaseNote>;
                              return ListView.builder(
                                itemCount: allNote.length,
                                itemBuilder: (context, index) {
                                  final note = allNote[index];
                                  return ListTile(
                                    leading: Icon(Icons.note),
                                    title: Text(note.text,
                                    maxLines: 1,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          default:
                            return const CircularProgressIndicator();
                        }
                      });
                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
