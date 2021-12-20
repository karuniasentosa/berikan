
import 'package:berikan/api/model/account.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/chat.dart';
import 'account_service.dart';
import 'model/extensions/account_extensions.dart';

class ChatService
{
  /// No constructor.
  ChatService._();

  static Future<List<Chat>?> getMyChats() async {
    final account = await AccountService.getCurrentAccount();
    if (account == null) return null;

    final uid = AccountService.getCurrentUser()!.uid;

    final query = chatCollectionReference(FirebaseFirestore.instance)
        .where('endpoints', arrayContains: accountDocumentReference(FirebaseFirestore.instance, uid));

    final snapshot = await query.get();

    if (snapshot.size == 0) return null;

    return snapshot.docs.map((e) => e.data()).toList();
  }
}