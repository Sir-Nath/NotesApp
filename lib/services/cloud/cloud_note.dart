import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/services/cloud/cloud_storage_constants.dart';

@immutable
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
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        textTitle = snapshot.data()[textTitleFieldName] as String,
        textContent = snapshot.data()[textContentFieldName] as String;
}
