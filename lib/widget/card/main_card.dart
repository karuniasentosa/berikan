import 'dart:typed_data';

import 'package:berikan/api/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
    required this.imageRef, required this.snapshot,
  }) : super(key: key);

  final Reference imageRef;
  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          FutureBuilder<Uint8List?>(
            future: StorageService.getData(imageRef),
            builder: (context, storageSnap) {
              if (!storageSnap.hasData) {
                return const Expanded(
                    flex: 6,
                    child: CircularProgressIndicator());
              } else {
                return Expanded(
                  flex: 6,
                  child: Image.memory(
                    storageSnap.data!,
                    fit: BoxFit.fill,
                  ),
                );
              }
            },
          ),
          Expanded(
            flex: 1,
            child: Align(
              child: Text(snapshot.data![0].name),
              alignment: Alignment.centerLeft,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [Text('JAKARTA BARAT'), Text('3 HARI LALU')],
            ),
          ),
        ],
      ),
    );
  }
}