import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService
{
  /// No constructor.
  StorageService._() { }

  static Future<Uint8List?> getData(Reference ref) async => await ref.getData();
  
  static UploadTask putData(
      Reference ref,
      Uint8List data,
      [SettableMetadata? meta]) => ref.putData(data, meta);
}