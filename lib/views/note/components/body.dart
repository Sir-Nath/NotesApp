import 'package:flutter/material.dart';
import '../../../services/crud/database_note.dart';
import '../../../services/crud/notes_service.dart';


class Body extends StatelessWidget {
  late final NoteService _noteService;
  Body({
    Key? key,
    required NoteService noteService,
    required this.userEmail,
  }) : _noteService = noteService, super(key: key);


  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _noteService.getOrCreateUser(email: userEmail),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return StreamBuilder(
                stream: _noteService.allNotes,
                builder: (context, snapshot){
                  switch (snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if(snapshot.hasData){
                        final allNote = snapshot.data as List<DatabaseNote>;
                        return Center(child: Text('${allNote.length}'));
                        //   ListView.builder(
                        //   itemCount: allNote.length,
                        //   itemBuilder: (context, index){
                        //     return Text('item');
                        //   },
                        // );
                      }else{
                        return CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                }
            );
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

