import 'package:flutter/material.dart';
import 'database_user.dart';

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