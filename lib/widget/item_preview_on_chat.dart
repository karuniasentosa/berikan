import 'dart:typed_data';

import 'package:berikan/api/model/item.dart';
import 'package:berikan/api/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ItemPreviewOnChat extends StatelessWidget
{
  final Item item;

  const ItemPreviewOnChat({Key? key, required this.item}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListTile(
        tileColor: Colors.white,
        shape: Border.all(),
        leading: AspectRatio(
          aspectRatio: 1,
          child: FutureBuilder<Uint8List?>(
            future: StorageService.getData(FirebaseStorage.instance.ref(item.imagesUrl[0])),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.memory(snapshot.requireData!, fit: BoxFit.cover);
              } else {
                return CircularProgressIndicator();
              }
            }
          )
        ),
        title: Text(item.name),
      ),
    );
  }
}