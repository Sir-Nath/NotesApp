import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/strings_constants/cloud/cloud_storage_constants.dart';

@immutable
//every note going to the cloud will have it main contents which in this case is the textTitle, textContent and ownerUserId,
//the document Id is the primary key of the cloud storage
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String textTitle;
  final String textContent;
  CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.textTitle,
    required this.textContent,
  });

  //QueryDocumentSnapshot
  //the is a named constructor that takes a QueryDocumentSnapshot of a map.
  //this constructor returns an instance of our CloudNote
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName] as String,
        textTitle = snapshot.data()[textTitleFieldName] as String,
        textContent = snapshot.data()[textContentFieldName] as String;
}
