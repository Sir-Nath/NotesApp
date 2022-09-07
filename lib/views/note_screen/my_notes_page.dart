import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../constants/enums/menu_action.dart';
import '../../constants/routes/route.dart';
import '../../data/model/cloud/cloud_note.dart';
import '../../data/repository/auth/auth_service.dart';
import '../../data/repository/cloud/firebase_cloud_storage.dart';
import '../../utilities/dialogs/logout_dialog.dart';
import 'note_list_view.dart';

class MyNotesPage extends StatefulWidget {
  const MyNotesPage({Key? key}) : super(key: key);

  @override
  State<MyNotesPage> createState() => _MyNotesPageState();
}

class _MyNotesPageState extends State<MyNotesPage> {
  late final FirebaseCloudStorage _noteService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    //_noteService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.07,
        ),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.08,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset('assets/svgs/Back.svg'),
                Text(
                  'My Notes',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 32),
                ),
                PopupMenuButton<MenuAction>(
                  onSelected: (value) async {
                    switch (value) {
                      case MenuAction.logout:
                        final shouldLogout = await showLogoutDialog(context);
                        if (shouldLogout) {
                          context.read<AuthBloc>().add(const AuthEventLogOut());
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
            SizedBox(
              height: height * 0.04,
            ),
            Row(
              children: [
                SizedBox(
                  child: SvgPicture.asset(
                    'assets/svgs/search.svg',
                  ),
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                const Text(
                  'Search notes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                )
              ],
            ),
            SizedBox(
              height: height * 0.04,
            ),
            StreamBuilder(
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
            ),
            SvgPicture.asset(
              'assets/svgs/Frame 151.svg',
            )
          ],
        ),
      ),
    );
  }
}
