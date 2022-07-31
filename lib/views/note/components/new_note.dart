import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
import '../../../services/crud/database_note.dart';
import '../../../services/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({Key? key}) : super(key: key);

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote?
      _note; // calling an instance of DatabaseNote to a private variable
  late final NoteService
      _noteService; //calling an instance of the class NoteService and making it private
  late final TextEditingController
      _textBody; //calling an private instance of the class TextEditingController to access the methods available to read our text from text field

  Future<DatabaseNote> createNewNote() async {
    final existingNote =
        _note; //existingNote is our DatabaseNote and if it is open then we return it
    if (existingNote != null) {
      //if there is already a note then we return it
      return existingNote;
    }
    final currentUser = AuthService.firebase()
        .currentUser!; //we are getting our current AuthUser from AuthService
    final email = currentUser.email!; //retrieving the AuthUser email
    final owner = await _noteService.getUser(
        email: email); //we are getting the DatabaseUser attached to this email
    return await _noteService.createNote(
        owner:
            owner); // we are using this DatabaseUser detail to create a new DatabaseNote
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note; //note is now our DatabaseNote to a User
    if (_textBody.text.isEmpty && note != null) {
      //if text is empty and we have a note
      _noteService.deleteNote(
          id: note
              .id); //we are deleting the note attached to the id of the DatabaseNote
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textBody.text;
    if (note != null && text.isNotEmpty) {
      //if note is not null and text is not empty, then perform the operation below
      await _noteService.updateNote(
        //update note
        note: note,
        text: text,
      );
    }
  }

  @override
  void initState() {
    //on creating a state we call these
    _noteService =
        NoteService(); //we are creating an instance of NoteService which is a singleton
    _textBody =
        TextEditingController(); //we are creating an instance of TextEditingController
    super.initState();
  }

  @override
  void dispose() {
    //on disposing a screen we want to perform the following function and dispose the TextEditingController
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textBody.dispose();
    super.dispose();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textBody.text;
    await _noteService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textBody.removeListener(_textControllerListener);
    _textBody.addListener(_textControllerListener);
  }

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
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          //we got here in our code
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNote?;
              _setupTextControllerListener();
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _textBody,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Start typing into your Note...',
                          hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                              fontStyle: FontStyle.italic)),
                    ),
                  ],
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
