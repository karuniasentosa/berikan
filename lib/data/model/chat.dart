import 'package:berikan/data/model/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat
{
  static const String collectionName = 'chat';

  final String id;
  final String endpointAccountId1;
  final String endpointAccountId2;

  Chat(this.id, {required this.endpointAccountId1, required this.endpointAccountId2});

  static Chat fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? _) {
    final data = snapshot.data()!;

    final id = snapshot.reference.id;
    final endpoint1 = (data['endpoint1'] as DocumentReference).id;
    final endpoint2 = (data['endpoint2'] as DocumentReference).id;

    return Chat(id, endpointAccountId1: endpoint1, endpointAccountId2: endpoint2);
  }

  static Map<String, Object?> toFirestore(Chat model, SetOptions? _) {
    return {
      'endpoint1': accountDocumentReference(FirebaseFirestore.instance, model.endpointAccountId1),
      'endpoint2': accountDocumentReference(FirebaseFirestore.instance, model.endpointAccountId2),
    };
  }
}

CollectionReference<Chat> chatCollectionReference(FirebaseFirestore instance) {
  return instance.collection(Chat.collectionName)
      .withConverter<Chat>(
        fromFirestore: Chat.fromFirestore,
        toFirestore: Chat.toFirestore
      );
}

DocumentReference<Chat> chatDocumentReference(FirebaseFirestore instance, String id) {
  return instance.collection(Chat.collectionName).doc(id)
      .withConverter(
        fromFirestore: Chat.fromFirestore,
        toFirestore: Chat.toFirestore
      );
}