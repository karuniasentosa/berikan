import 'dart:typed_data';
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