import 'package:berikan/api/model/account.dart';
import 'dart:typed_data';
import 'package:berikan/api/model/chat.dart';
import 'package:berikan/api/model/item.dart';

class Arguments {
  final String name;
  final String imageUrl;

  Arguments(this.name, this.imageUrl);
}

class SignupArguments {
  final String? id;

  SignupArguments(this.id);
}


class ImageViewerArguments {
  final String imageId;
  final Uint8List imageData;

  ImageViewerArguments(this.imageId, this.imageData);
}


class DetailArguments {
  final Item itemDetail;
  final dynamic location;

  DetailArguments(this.itemDetail, this.location);
}


class EditProfileArguments {
  final Account account;

  EditProfileArguments(this.account);
}

class ChatDetailItemArguments {
  final Chat chat;
  final String itemId;

  ChatDetailItemArguments(this.chat, this.itemId);
}
