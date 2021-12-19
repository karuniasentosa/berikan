import 'dart:typed_data';

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