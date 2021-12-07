import 'package:berikan/data/model/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat
{
  static const String collectionName = 'chat';

  final String id;
  final String endpointAccountId1;
  final String endpointAccountId2;

  Chat(this.id, {required this.endpointAccountId1, required this.endpointAccountId2});

  /// Converts from a Firestore data to [Chat] class.
  ///
  /// This function should not be called directly — and should be passed to
  /// [CollectionReference.withConverter] function.
  ///
  /// See: [CollectionReference.withConverter](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/CollectionReference/withConverter.html)
  ///
  /// See also: [FromFirestore](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/FromFirestore.html)
  static Chat fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? _) {
    final data = snapshot.data()!;

    final id = snapshot.reference.id;
    final endpoint1 = (data['endpoint1'] as DocumentReference).id;
    final endpoint2 = (data['endpoint2'] as DocumentReference).id;

    return Chat(id, endpointAccountId1: endpoint1, endpointAccountId2: endpoint2);
  }

  /// Converts from this data class to Firestore data.
  ///
  /// This function should not be called directly — and should be passed to
  /// [CollectionReference.withConverter] function.
  ///
  /// [Firebase.initializeApp] must be called before using this function,
  /// otherwise, it will throw an exception.
  ///
  /// See: [CollectionReference.withConverter](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/CollectionReference/withConverter.html)
  ///
  /// See also: [ToFirestore](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/ToFirestore.html)
  static Map<String, Object?> toFirestore(Chat model, SetOptions? _) {
    return {
      'endpoint1': accountDocumentReference(FirebaseFirestore.instance, model.endpointAccountId1),
      'endpoint2': accountDocumentReference(FirebaseFirestore.instance, model.endpointAccountId2),
    };
  }
}

/// Returns a type-safe [CollectionReference] of [Chat] class.
///
/// [instance] is required to... because uh... it is required!
CollectionReference<Chat> chatCollectionReference(FirebaseFirestore instance) =>
  instance.collection(Chat.collectionName)
    .withConverter<Chat>(
      fromFirestore: Chat.fromFirestore,
      toFirestore: Chat.toFirestore
    );


/// Returns a type-safe [DocumentReference] of [Chat] class within the document [id].
///
/// [instance] is required to... because uh... it is required!
DocumentReference<Chat> chatDocumentReference(FirebaseFirestore instance, String id) =>
  chatCollectionReference(instance).doc(id);
