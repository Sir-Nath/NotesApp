import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import 'crud_exception.dart';



class NoteService {
  Database? _db;

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();

    await getNote(id: note.id);

    final updateCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      return await getNote(id: note.id);
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
    );
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
    // if(notes.isEmpty){
    //   throw CouldNotFindNote();
    // }else{
    //   return DatabaseNote.fromRow(notes.first);
    // }
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id =?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      return DatabaseNote.fromRow(notes.first);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id =?',
      whereArgs: [id],
    );

    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    //this check if the user is in the database with the correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    const text = '';

    final noteId = await db.insert(noteTable,
        {userIdColumn: owner.id, textColumn: text, isSyncedWithCloudColumn: 1});

    final note = DatabaseNote(
        id: noteId, userId: owner.id, text: text, isSyncedWithCloud: true);
    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email =?',
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
    final db = _getDatabaseOrThrow();

    //this query checks if there is already an instance of the user we try to input into the table
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email =?',
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
    final db = _getDatabaseOrThrow();
    //function db.delete returns an integer of either 0 or 1, 0 stands for not nothing to delete and 1 stands for a user deleted.
    final deletedCount = await db.delete(
      userTable,
      where: 'email',
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
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory(); // this exception is thrown if the database can't be created
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
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  DatabaseUser({
    required this.id,
    required this.email,
  });
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote(
      {required this.id,
      required this.userId,
      required this.text,
      required this.isSyncedWithCloud});

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map['idColumn'] as int,
        userId = map['userIdColumn'] as int,
        text = map['textColumn'] as String,
        isSyncedWithCloud =
            (map['isSyncedWithCloudColumn'] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Person, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}


const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_column';
const noteTable = 'note';
const userTable = 'user';
const dbName = 'notes.db';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';
const createNoteTable = '''CREATE TABLE "notes" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_sync_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id")
);''';
