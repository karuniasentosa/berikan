
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

    final uid = account.user!.uid;
    // TODO: Comeback later and check this code.
    final query = chatCollectionReference(FirebaseFirestore.instance)
        .where('endpoints', arrayContains: accountDocumentReference(FirebaseFirestore.instance, uid));

    final snapshot = await query.get();

    return snapshot.docs.map((e) => e.data()).toList();
  }
}