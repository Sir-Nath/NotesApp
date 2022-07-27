import 'package:flutter/material.dart';
import '../../../services/crud/notes_service.dart';


class Body extends StatelessWidget {
  const Body({
    Key? key,
    required NoteService noteService,
    required this.userEmail,
  }) : _noteService = noteService, super(key: key);

  final NoteService _noteService;
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
                      return NoteBody();
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

class NoteBody extends StatefulWidget {
  const NoteBody({
    Key? key,
  }) : super(key: key);

  @override
  State<NoteBody> createState() => _NoteBodyState();
}

class _NoteBodyState extends State<NoteBody> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Notes',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
          ),
          Text(
            'Main page',
            style:
            TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 14),
          ),
        ],
      ),
    );
  }
}