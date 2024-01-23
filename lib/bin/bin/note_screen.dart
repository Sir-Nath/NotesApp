import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes/src/constants/routes/route.dart';
import 'package:notes/src/data/repository/auth/auth_service.dart';
import 'package:notes/src/bloc/auth/auth_bloc.dart';
import 'package:notes/src/model/cloud/cloud_note.dart';
import 'package:notes/src/data/repository/cloud/firebase_cloud_storage.dart';
import 'package:notes/bin/bin/note_list_view.dart';
import '../../src/bloc/auth/auth_event.dart';
import '../../src/constants/enums/menu_action.dart';
import '../../src/utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.15,
        foregroundColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:  IconButton(
          onPressed: (){
            context.read<AuthBloc>().add(const AuthEventInitialize());
          },
          icon: const Icon(
          Icons.arrow_back,
          ),
        ),
        title: const Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 32),
        ),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    if(context.mounted){
                    context.read<AuthBloc>().add(const AuthEventLogOut());

                    }
                  }
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
        child: Stack(
          children: [

            StreamBuilder(
              stream: _noteService.allNotes(ownerUserId: userId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allNote = snapshot.data as Iterable<CloudNote>;
                      if (allNote.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width,
                              height: width * 0.5,
                              child:
                                  SvgPicture.asset('assets/svgs/Empty box.svg'),
                            ),
                            const Text(
                              'Your Notepad is Empty',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: width * 0.05,
                            ),
                            const Text(
                              'Tap the button below to start creating a \n'
                              'note. Once you create a note, it will \n'
                              'appear here',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        );
                      }
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
                      return const Center(
                        child: Column(
                          children: [
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
                    return const Center(
                      child: Column(
                        children: [
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
            ),
            Positioned(
                bottom: 50,
                left: width * 0.5 - 48,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xff3454CC),
                      borderRadius: BorderRadius.circular(28)
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
