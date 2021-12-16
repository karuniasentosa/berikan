import 'dart:typed_data';

import 'package:berikan/api/model/account.dart';
import 'package:berikan/api/model/extensions/item_extensions.dart';
import 'package:berikan/api/model/item.dart';
import 'package:berikan/api/storage_service.dart';
import 'package:berikan/utils/datediff_describer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:berikan/api/model/extensions/account_extensions.dart';

class MainGridView extends StatelessWidget {
  final AsyncSnapshot<List<Item>> snapshot;
  final _fireStorage = FirebaseStorage.instance;

  MainGridView({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final imageRef = _fireStorage.ref(snapshot.data![index].imagesUrl[0]);
        return Card(
          elevation: 5,
          child: Column(
            children: [
              FutureBuilder<Uint8List?>(
                future: StorageService.getData(imageRef),
                builder: (context, storageSnap) {
                  if (!storageSnap.hasData) {
                    return const Expanded(
                        flex: 6, child: CircularProgressIndicator());
                  } else {
                    return Expanded(
                      flex: 6,
                      child: Image.memory(
                        storageSnap.data!,
                        fit: BoxFit.cover,
                        width: 240,
                      ),
                    );
                  }
                },
              ),
              Expanded(
                flex: 1,
                child: Align(
                  child: Text(snapshot.data![index].name),
                  alignment: Alignment.centerLeft,
                ),
              ),
              FutureBuilder<Account?>(future: snapshot.data?[index].owner,
                  builder: (context, accountSnap) {
                if(!accountSnap.hasData){
                  return const CircularProgressIndicator();
                } else {
                  return FutureBuilder<dynamic>(
                    future: accountSnap.data!.getKecamatan(snapshot.data![index].ownerId),
                    builder: (context, locationSnap) {
                      if(!locationSnap.hasData){
                        print(locationSnap);
                        return const CircularProgressIndicator();
                      } else {
                        return Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(locationSnap.data!),
                              Text(DateDiffDescriber.dayDiff(
                                  snapshot.data![index].addedSince, DateTime.now()))
                            ],
                          ),
                        );
                      }

                    },
                  );
                }

              }),
            ],
          ),
        );
      },
      itemCount: snapshot.data?.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    );
  }
}
