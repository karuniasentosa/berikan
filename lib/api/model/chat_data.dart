import 'dart:typed_data';

import 'package:berikan/api/account_service.dart';
import 'package:berikan/api/model/account.dart';
import 'package:berikan/api/model/chat.dart';
import 'package:berikan/api/model/extensions/chat_extensions.dart';
import 'package:berikan/api/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// This class is used to represent chats in chat page.
class ChatData
{
  final String chatId;
  final Uint8List theirImageData;
  final String theirName;
  final DateTime lastChat;
  final String? lastMessage;
  final String lastSentId;

  ChatData._(this.chatId, this.theirImageData, this.lastMessage, this.lastChat, this.theirName, this.lastSentId);

  static Future<ChatData> of(Chat chat) async {
    final firebaseStorage = FirebaseStorage.instance;
    final firebaseFirestore = FirebaseFirestore.instance;

    final myUid = AccountService.getCurrentUser()!.uid;

    // chat that has to be shown
    String theirUid;
    if (myUid == chat.endpointAccountId1) {
      theirUid = chat.endpointAccountId2;
    } else {
      theirUid = chat.endpointAccountId1;
    }

    final theirImageRef = firebaseStorage.ref('/user_profile/${theirUid}.jpg');
    final theirAccountDocRef = accountDocumentReference(firebaseFirestore, theirUid);
    final theirSnapshot = await theirAccountDocRef.get();
    final theirName = '${theirSnapshot.data()!.firstName} ${theirSnapshot.data()!.lastName}';
    final theirImageData = await StorageService.getData(theirImageRef);
    
    // get the data (assign _imageData and the other things)
    final latestMessage = await chat.latestMessage;
    final message = latestMessage.content;
    final when = latestMessage.when;
    final lastSentId = latestMessage.accountId;

    return ChatData._(chat.id, theirImageData!, message, when, theirName, lastSentId);
  }
}