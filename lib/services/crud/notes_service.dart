import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'crud_constants.dart';
import 'crud_exception.dart';
import 'database_note.dart';
import 'database_user.dart';

class NoteService {
  //we create an instance of the Database from package SQlite
  Database? _db; //our database is _db

  List<DatabaseNote> _notes = []; //we are creating an empty list which should
  // contain our databaseNote which is a map of string and objects.

  DatabaseUser? _user;
  //creating a singleton
  static final NoteService _shared = NoteService._sharedInstance();
  NoteService._sharedInstance(){
    //this is a private constructor
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }
   //we instantiate an object _shared which is an instance of the private Constructor
  factory NoteService() => _shared; //our factory constructor returns the instantiated object
  //singleton: The singleton pattern is a pattern used in object-oriented programming
  // which ensures that a class has only one instance and also provides a global point
  //of access to it. Sometimes it's important for a class to have exactly one instance,
  // or you might force your app into a weird state.


  late final StreamController<List<DatabaseNote>> _notesStreamController;

  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);

  }

  Future<DatabaseNote> updateNote(
      { // to update our note we need the previous note and the text to add to it
        required DatabaseNote note,
        required String text,
      }) async {
    await _ensureDbIsOpen(); //ensures db is open
    final db = _getDatabaseOrThrow(); //either returns db or throws an exception of database not open
    // which don't expect to see due to the previous function called

    await getNote(id: note.id);

    final updateCount = await db.update(noteTable, {
      textColumn: text,
    },
        where: 'id = ?',
        whereArgs: [note.id]
    );

    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {


    final db = _getDatabaseOrThrow();

    final notes = await db.query(
      noteTable,
    );
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  //this function grabs a note for us using the id of the note
  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    //the previous two function sees to opening the database or throwing an exception

    //the .query fetches our note for us based on id inputted
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    //if the note exist, we expect to find the note else it doesn't exist
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final note = DatabaseNote.fromRow(notes.first);
      //this constructor takes a map and .first return the first element
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDelete = await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDelete;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    //this check if the user is in the database with the correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    const text = 'hi';
    final noteId = await db.insert(noteTable,
        {userIdColumn: owner.id, textColumn: text});
    final note = DatabaseNote(
      id: noteId, userId: owner.id, text: text,);
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {

    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isEmpty) {
      throw CouldNotFindUser();
    } else {

      return DatabaseUser.fromRow(result.first);
    }
  }
  //this function create a User in the userTable
  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    //this query checks if there is already an instance of the user we try to input into the table
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    //if the user exist before then the returned list should not be empty
    if (result.isNotEmpty) {
      throw UserAlreadyExist();
    }
    //on inserting a fresh user, an integer ID is returned which then becomes the id of the instance of a DatabaseUser we get back
    final userId =
    await db.insert(userTable, {emailColumn: email.toLowerCase()});
    return DatabaseUser(id: userId, email: email);
  }

  //this function deletes a user
  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    //function db.delete returns an integer of either 0 or 1, 0 stands for not nothing to delete and 1 stands for a user deleted.
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  //this is a function that either throws an exception if the database is null or return the instance of the created Database
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  //this function open/create a database
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      //code syntax for creating database path by joining the application document directory with the file name
      final docsPath =
      await getApplicationDocumentsDirectory(); // this gets the application directory
      final dbpath = join(
          docsPath.path, dbName); // this join the directory with the file name
      final db = await openDatabase(dbpath); // this opens the database
      _db =
          db; //this assign the open database to the created instance of a Database
      //create user table if doesn't exist
      await db.execute(createUserTable);
      //create note table if doesn't exist
      await db.execute(createNoteTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory(); // this exception is thrown if the database can't be created
  }
}
  //this function ensure our db is opened
  Future<void> _ensureDbIsOpen() async{
    try{
      await open(); //it opens it
    }on DatabaseAlreadyOpenException{
      //upon this exception that it is opened already, we let nothing happens than just leave the database open
    }
}
  //this function closes a database
  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<DatabaseUser> getOrCreateUser({required String email}) async{
    try{
      final user = await getUser(email: email);
      return user;
    }on CouldNotFindUser{
      final createdUser = await createUser(email: email);
      return createdUser;
    }catch(e){
      rethrow;
    }
  }
}




