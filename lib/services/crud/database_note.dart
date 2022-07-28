import 'package:flutter/material.dart';
import 'crud_constants.dart';
import 'database_user.dart';

@immutable
//this class is a model for our Note database
class DatabaseNote {
  //the following variables are the column to be provider per note content
  final int id;
  final int userId;
  final String text;

//our constructor
  DatabaseNote(
      {required this.id,
        required this.userId,
        required this.text,
      });

//this is a custom constructor that takes a map of Strings and optional objects. there is no objects in the constructor map. since there is no content to put in it for now
  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String;
        //isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  //we are overriding the toString() function to return the following contents. upon calling it on the class object, we get the result as written here.
  @override
  String toString() =>
      'Note, ID = $id, userId = $userId,text = $text';
  //we are overriding the == operator to allow us compare parameters of the same type using the id(in this case of our Note)
  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;
  @override
  int get hashCode => id.hashCode;
}