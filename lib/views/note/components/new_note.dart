import 'package:flutter/material.dart';
import 'package:notes/views/note/components/body.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({Key? key}) : super(key: key);

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'New Note',
          style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 18),
        ),
      ),
      body: NoteBody()
    );
  }
}
