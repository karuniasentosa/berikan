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
  final Uint8List? _imageData;
  final String? _name;
  final DateTime? _lastChat;
  final String? _lastMessage;

  Uint8List get imageData => _imageData!;
  String get name => _name!;
  DateTime get lastChat => _lastChat!;
  String get lastMessage => _lastMessage!;

  ChatData._(this.chatId, this._imageData, this._lastMessage, this._lastChat, this._name);

  static Future<ChatData> of(Chat chat) async {
    final firebaseStorage = FirebaseStorage.instance;
    final firebaseFirestore = FirebaseFirestore.instance;

    final uid = AccountService.getCurrentUser()!.uid;

    // chat that has to be shown
    String showUid;
    if (uid == chat.endpointAccountId1) {
      showUid = chat.endpointAccountId2;
    } else {
      showUid = chat.endpointAccountId1;
    }

    final imageRef = firebaseStorage.ref('/user_profile/${showUid}.jpg');
    final accountDocRef = accountDocumentReference(firebaseFirestore, showUid);
    final snapshot = await accountDocRef.get();

    // get the data (assign _imageData and the other things)
    final latestMessage = await chat.latestMessage;
    final name = '${snapshot.data()!.firstName} ${snapshot.data()!.lastName}';
    final imageData = await StorageService.getData(imageRef);
    final message = latestMessage.content;
    final when = latestMessage.when;

    return ChatData._(chat.id, imageData, message, when, name);
  }
}