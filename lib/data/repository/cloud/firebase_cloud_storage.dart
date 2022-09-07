import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/data/model/cloud/cloud_note.dart';
import 'package:notes/constants/strings_constants/cloud/cloud_storage_constants.dart';
import 'package:notes/constants/exception/cloud/cloud_storage_exception.dart';

class FirebaseCloudStorage {
  //we are instantiating our note from cloud to the variable notes
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
    //this is our function for deleting note
    //the function requires a documentId to know what to delete a document in a collection in thr storage
  }

  Future<void> updateNote({
    required String documentId,
    required String textTitle,
    required String textContent,
  }) async {
    try {
      await notes.doc(documentId).update({
        textTitleFieldName: textTitle,
        textContentFieldName: textContent,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
    //we require the textTitle, textContent and documentId(this will have be ...
    // ...given on creating a note), and all we do is update the parameters indicated (textTitle and textContent
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textTitleFieldName: '',
      textContentFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      textTitle: '',
      textContent: '',
    );

    //the note.add is adding a new document to the collection and requires the
    // the columns and it contents which in this case are empty strings
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots().map(
          (event) => event.docs.map(
            //as at here we have all the available documents
            (doc) {
              //we have gotten the document as at here
              //we are going to get an instance of CloudNote with the help of the constructor below
              return CloudNote.fromSnapshot(doc);
            },
          )
        );
  }

  //we are not using this function at all so i could just remove it but will let it be
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
        (value) {
          //here we try to get our document out of the many documents available on cloud
          return value.docs.map(
            (doc) {
              //as at here we have gotten the document(Snapshot) and we are trying to make an instance of CloudNote
              return CloudNote.fromSnapshot(doc);
            },
          );
        },
      );
    } catch (e) {
      throw CouldNotGetAllNoteException();
    }
    //to get a note, we check notes where ownerUserIdFieldName is equal to the ownerUserId provided
    //we get it
    //then we
  }

  // this is a singleton of FirebaseCloudStorage
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
