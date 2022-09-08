import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:keframe/keframe.dart';
import '../../model/cloud/cloud_note.dart';
import '../../data/repository/auth/auth_service.dart';
import '../../data/repository/cloud/firebase_cloud_storage.dart';
import '../widget/note_card.dart';
import 'note_editor.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
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
  
    return Scaffold(
        body: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 32),
        StreamBuilder(
            stream: _noteService.allNotes(ownerUserId: userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  final notes = snapshot.data as Iterable<CloudNote>;

                  return SizeCacheWidget(
                    estimateCount: notes.length * 2,
                    child: MasonryGridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notes.length,
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      itemBuilder: (context, index) {
                        return FrameSeparateWidget(
                          index: index,
                          placeHolder: const NoteCard(
                            title: '',
                            content: '',
                            isPlaceholder: true,
                          ),
                          child: NoteCard(
                            title: notes.elementAt(index).textTitle,
                            content: notes.elementAt(index).textContent,
                            widget: CreateUpdateNoteView(
                              widgetNote: notes.elementAt(index),
                            ),
                          ),
                        );
                      },
                    ),
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
            })
      ],
    ));
  }
}
