import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat.dart';
import 'account.dart' show accountDocumentReference;


enum AttachmentType {
  image,
  item,
}

class Message
{
  static const String collectionName = 'message';

  /// The sender of the [Message]
  final String accountId;

  final DateTime when;
  final String? content;

  /// The attached item to this [Message]
  ///
  /// This could be link to an item or
  /// to an image (uploaded by [accountId])
  final String? attachment;

  final AttachmentType? attachmentType;

  /// Constructs a new [Message] instance.
  Message({required this.accountId, required this.when, this.content, this.attachment, this.attachmentType});

  /// Constructs a new [Message] instance with current [DateTime]
  factory Message.text({required String accountId, required String content})
  {
    return Message(
        accountId: accountId,
        when: DateTime.now(),
        content: content,
    );
  }

  factory Message.imageAttachment({required String accountId, required String imageRef})
  {
    return Message(
      accountId: accountId,
      when: DateTime.now(),
      attachment: imageRef,
      attachmentType: AttachmentType.image,
    );
  }

  factory Message.itemAttachment({required String accountId, required String itemId})
  {
    return Message(
      accountId: accountId,
      when: DateTime.now(),
      attachment: itemId,
      attachmentType: AttachmentType.item,
    );
  }

  /// Converts from a Firestore api to [Message] class.
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
    final content = data['content'] as String?;
    final attachment = data['attachment'] as String?;
    final attachmentTypeString = data['attachment_type'] as String?;

    AttachmentType attachmentType;
    if (attachmentTypeString == null) {
      attachmentType = AttachmentType.image;
    } else if (attachmentTypeString == 'item') {
      attachmentType = AttachmentType.item;
    } else {
      attachmentType = AttachmentType.image;
    }

    return Message(
        accountId: accountId,
        when: when,
        content: content,
        attachment: attachment,
        attachmentType: attachmentType,
    );
  }

  /// Converts from this api class to Firestore api.
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
      'attachment_type' : model.attachmentType == AttachmentType.item ? 'item' : 'image',
    };
  }
}

/// Returns a type-safe [CollectionReference] of [Message] class from [chatDocumentId].
///
/// [instance] is required to... because uh... it is required!
CollectionReference<Message> messageCollectionReference(
    FirebaseFirestore instance, String chatDocumentId) =>
  instance.collection(Chat.collectionName).doc(chatDocumentId)
      .collection(Message.collectionName).withConverter<Message>(
        fromFirestore: Message.fromFirestore,
        toFirestore: Message.toFirestore
  );


DocumentReference<Message> messageDocumentReference(
    FirebaseFirestore instance, String chatDocumentId, String id) =>
  messageCollectionReference(instance, chatDocumentId).doc(id);

