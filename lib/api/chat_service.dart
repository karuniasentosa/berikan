import 'package:berikan/api/model/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'account_service.dart';
import 'model/chat.dart';

class ChatService
{
  /// No constructor.
  ChatService._();

  static Future<List<Chat>?> getMyChats() async {
    final uid = AccountService.getCurrentUser()!.uid;

    final query = chatCollectionReference(FirebaseFirestore.instance)
        .where('endpoints', arrayContains: accountDocumentReference(FirebaseFirestore.instance, uid));

    final snapshot = await query.get();

    if (snapshot.size == 0) return null;

    return snapshot.docs.map((e) => e.data()).toList();
  }

  /// Gets a chat between two endpoints.
  /// If there doesn't exists, it will create a new one.
  static Future<Chat> getChatFromEndpoints({required String endpointUid1, required String endpointUid2}) async {
    final instance = FirebaseFirestore.instance;

    final colRef = chatCollectionReference(instance);

    final query = colRef.where(
        'endpoints',
        whereIn: [
          [accountDocumentReference(instance, endpointUid1), accountDocumentReference(instance, endpointUid2)],
          [accountDocumentReference(instance, endpointUid2), accountDocumentReference(instance, endpointUid1)],
        ]).limit(1);

    final snapshot = await query.get();

    if (snapshot.size == 0) {
      // create a chat
      final docRef = await colRef.add(
          Chat.create(
              endpointAccountId1: endpointUid1,
              endpointAccountId2: endpointUid2)
      );
      final snapshot = await docRef.get();
      return await snapshot.data()!;
    } else {
      return snapshot.docs[0].data();
    }
  }
}