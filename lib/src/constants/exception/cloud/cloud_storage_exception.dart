import 'package:flutter/cupertino.dart';

@immutable
class CloudStorageException implements Exception{
  const CloudStorageException();
}
//C in CRUD
class CouldNotCreateNoteException extends CloudStorageException{}
//R in CRUD
class CouldNotGetAllNoteException extends CloudStorageException{}
//U in CRUD
class CouldNotUpdateNoteException extends CloudStorageException{}
//D in CRUD
class CouldNotDeleteNoteException extends CloudStorageException{}