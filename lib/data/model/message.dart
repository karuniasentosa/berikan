import 'package:berikan/data/model/account.dart' show accountDocumentReference;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat.dart';

class Message
{
  static const String collectionName = 'message';

  final String accountId;
  final DateTime when;
  final String content;
  final String? attachment;

  /// Constructs a new [Message] instance.
  Message({required this.accountId, required this.when, required this.content, this.attachment});

  /// Constructs a new [Message] instance with current [DateTime]
  factory Message.create(
      {required String accountId, required String content, String? attachment})
  {
    return Message(
        accountId: accountId,
        when: DateTime.now(),
        content: content,
        attachment: attachment
    );
  }

  /// Converts from a Firestore data to [Message] class.
  ///
  /// This function should not be called directly — and should be passed to
  /// [CollectionReference.withConverter] function.
  ///
  /// See: [CollectionReference.withConverter](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/CollectionReference/withConverter.html)
  ///
  /// See also: [FromFirestore](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/FromFirestore.html)
  static Message fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? _) {
    final data = snapshot.data()!;

    final accountId = (data['who'] as DocumentReference).id;
    final when = (data['when'] as Timestamp).toDate();
    final content = data['content'] as String;
    final attachment = data['attachment'] as String?;

    return Message(
        accountId: accountId,
        when: when,
        content: content,
        attachment: attachment
    );
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
  static Map<String, Object?> toFirestore(Message model, SetOptions? _) {
    return {
      'who'        : accountDocumentReference(FirebaseFirestore.instance, model.accountId),
      'when'       : Timestamp.fromDate(model.when),
      'content'    : model.content,
      'attachment' : model.attachment,
    };
  }
}

/// Returns a type-safe [CollectionReference] of [Message] class from [chatDocumentId].
///
/// [instance] is required to... because uh... it is required!
CollectionReference<Message> messageCollectionReference(FirebaseFirestore instance, String chatDocumentId)
{
  return instance.collection(Chat.collectionName).doc(chatDocumentId)
      .collection(Message.collectionName).withConverter<Message>(
        fromFirestore: Message.fromFirestore,
        toFirestore: Message.toFirestore
  );
}

DocumentReference<Message> messageDocumentReference(FirebaseFirestore instance, String chatDocumentId, String id)
{
  return instance.collection(Chat.collectionName).doc(chatDocumentId).collection(Message.collectionName)
      .doc(id).withConverter<Message>(
        fromFirestore: Message.fromFirestore,
        toFirestore: Message.toFirestore
  );
}

