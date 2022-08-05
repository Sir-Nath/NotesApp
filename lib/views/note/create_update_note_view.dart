import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/utilities/generics/get_arguments.dart';
import 'package:share_plus/share_plus.dart';
//import '../../services/crud/database_note.dart';
//import '../../services/crud/notes_service.dart';
import '../../services/cloud/cloud_note.dart';
//import '../../services/cloud/cloud_storage_exception.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../utilities/dialogs/cannot_share_empty_note_dialog.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  // calling an instance of DatabaseNote to a private variable
  //DatabaseNote? _note;
  CloudNote? _note;
  //calling an instance of the class NoteService and making it private
  //late final NoteService _noteService;
  late final FirebaseCloudStorage _noteService;

//calling an private instance of the class TextEditingController to access the methods available to read our text from text field
  late final TextEditingController _textTitle;

  late final TextEditingController _textContent;

  Future<CloudNote> createOrUpdateExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textTitle.text = widgetNote.textTitle;
      _textContent.text = widgetNote.textContent;
      return widgetNote;
    }
    final existingNote =
        _note; //existingNote is our DatabaseNote and if it is open then we return it
    if (existingNote != null) {
      //if there is already a note then we return it
      return existingNote;
    }
    final currentUser = AuthService.firebase()
        .currentUser!; //we are getting our current AuthUser from AuthService
    //final email = currentUser.email; //retrieving the AuthUser email
    //final owner = await _noteService.getUser(email: email); //we are getting the DatabaseUser attached to this email
    final userId = currentUser.id;
    final newNote = await _noteService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote; // we are using this DatabaseUser detail to create a new DatabaseNote
  }

  Future<void> _deleteNoteIfTextIsEmpty() async {
    final note = _note; //note is now our DatabaseNote to a User
    if (_textContent.text.isEmpty && note != null) {
      //if text is empty and we have a note
      await _noteService.deleteNote(
          documentId: note
              .documentId); //we are deleting the note attached to the id of the DatabaseNote
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final textTitle = _textTitle.text;
    final textContent = _textContent.text;
    if (note != null && textContent.isNotEmpty) {
      //if note is not null and text is not empty, then perform the operation below
      await _noteService.updateNote(
          //update note
          documentId: note.documentId,
          textContent: textContent,
          textTitle: textTitle);
    }
  }

  @override
  void initState() {
    //on creating a state we call these
    //_noteService = NoteService(); //we are creating an instance of NoteService which is a singleton
    _noteService = FirebaseCloudStorage();
    _textTitle =
        TextEditingController(); //we are creating an instance of TextEditingController
    _textContent = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    //on disposing a screen we want to perform the following function and dispose the TextEditingController
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textTitle.dispose();
    _textContent.dispose();
    super.dispose();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final textTitle = _textTitle.text;
    final textContent = _textContent.text;
    await _noteService.updateNote(
        documentId: note.documentId,
        textTitle: textTitle,
        textContent: textContent);
  }

  void _setupTextControllerListener() {
    _textTitle.removeListener(_textControllerListener);
    _textTitle.addListener(_textControllerListener);
    _textContent.removeListener(_textControllerListener);
    _textContent.addListener(_textControllerListener);
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
        actions: [
          IconButton(
            onPressed: () async {
              final textContent = _textContent.text;
              if (_note == null || textContent.isEmpty) {
                await showCannotShareEmptyNoteDialog(context);
              }else{
                Share.share(textContent);
              }
            },
            icon: const Icon(Icons.share_outlined),
          )
        ],
      ),
      body: FutureBuilder(
        future: createOrUpdateExistingNote(context),
        builder: (context, snapshot) {
          //we got here in our code
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _textTitle,
                      maxLines: 1,
                      style:
                          const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.4), fontSize: 24),
                      ),
                    ),
                    TextField(
                      controller: _textContent,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Start typing into your Note...',
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            default:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
