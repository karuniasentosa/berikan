
import 'package:berikan/api/model/account.dart';
import 'package:berikan/api/model/message.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/chat.dart';
import 'account_service.dart';
import 'model/extensions/account_extensions.dart';

class ChatService
{
  /// No constructor.
  ChatService._();

  static Future<List<Chat>?> getMyChats() async {
    // TODO: Delete this as this is not used. Will be replaced by `onAuthStateChanges`
    final account = await AccountService.getCurrentAccount();
    if (account == null) return null;

    final uid = AccountService.getCurrentUser()!.uid;

    final query = chatCollectionReference(FirebaseFirestore.instance)
        .where('endpoints', arrayContains: accountDocumentReference(FirebaseFirestore.instance, uid));

    final snapshot = await query.get();

    if (snapshot.size == 0) return null;

    return snapshot.docs.map((e) => e.data()).toList();
  }

  static Future<Chat> createChatWith(String userId) async {
    final uid = AccountService.getCurrentUser()!.uid;

    final collectionReference = chatCollectionReference(FirebaseFirestore.instance);

    final newChat = Chat.create(
        endpointAccountId1: uid,
        endpointAccountId2: userId);

    final docRef = await collectionReference.add(newChat);

    final snapshot = await docRef.get();

    return snapshot.data()!;
  }
}