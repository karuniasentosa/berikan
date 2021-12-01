import 'package:berikan/data/model/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../message.dart';

extension ChatService on Chat
{
  Stream<QuerySnapshot<Message>> get messages {
    final messageColRef = messageCollectionReference(FirebaseFirestore.instance, id);
    final query = messageColRef.orderBy('when');
    return query.snapshots();
  }

  Future<void> pushMessage(Message message) async {
    final messageColRef = messageCollectionReference(FirebaseFirestore.instance, id);
    messageColRef.add(message);
  }
}