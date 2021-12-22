import 'package:cloud_firestore/cloud_firestore.dart';

import '../message.dart';
import '../chat.dart';

extension ChatExtension on Chat
{
  /// The stream of this chat
  Stream<QuerySnapshot<Message>> get messages {
    final messageColRef = messageCollectionReference(FirebaseFirestore.instance, id);
    final query = messageColRef.orderBy('when', descending: true);
    return query.snapshots();
  }

  /// Puts a message and send to our Cloud Firestore
  Future<void> pushMessage(Message message) async {
    final messageColRef = messageCollectionReference(FirebaseFirestore.instance, id);
    messageColRef.add(message);
  }
  
  /// gets the latest message
  Future<Message> get latestMessage async {
    final messageColRef = messageCollectionReference(FirebaseFirestore.instance, id);
    // to bring latest message front.
    final query = messageColRef.orderBy('when', descending: true).limit(1);
    final snapshot = await  query.get();
    return snapshot.docs[0].data();
  }
}