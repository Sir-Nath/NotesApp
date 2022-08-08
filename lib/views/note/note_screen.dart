import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants/route.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/cloud/cloud_note.dart';
import 'package:notes/services/cloud/firebase_cloud_storage.dart';
//import 'package:notes/services/crud/notes_service.dart';
import 'package:notes/views/note/note_list_view.dart';
import '../../enums/menu_action.dart';
//import '../../services/crud/database_note.dart';
import '../../utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _noteService;
  //we are sure every user who will use this note will definitely have an email.
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    //_noteService.open();
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
          style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                   context.read<AuthBloc>().add(const AuthEventLogOut());
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log Out'),
                ),
              ];
            },
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: StreamBuilder(
            stream: _noteService.allNotes(ownerUserId: userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allNote = snapshot.data as Iterable<CloudNote>;
                    return NoteListView(
                      notes: allNote,
                      onDeleteNote: (note) async {
                        await _noteService.deleteNote(
                          documentId: note.documentId,
                        );
                      },
                      onTap: (CloudNote note) {
                        Navigator.of(context).pushNamed(
                          createOrUpdateNoteRoute,
                          arguments: note,
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Column(
                        children: const [
                          Text('fetching your notes...'),
                          SizedBox(
                            height: 50,
                          ),
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }
                default:
                  return Center(
                    child: Column(
                      children: const [
                        Text('fetching your notes...'),
                        SizedBox(
                          height: 50,
                        ),
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
              }
            },
          )),
    );
  }
}
