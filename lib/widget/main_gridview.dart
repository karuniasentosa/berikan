import 'dart:typed_data';

import 'package:berikan/api/account_service.dart';
import 'package:berikan/api/model/item.dart';
import 'package:berikan/api/storage_service.dart';
import 'package:berikan/ui/item_detail.dart';
import 'package:berikan/utills/arguments.dart';
import 'package:berikan/utils/datediff_describer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MainGridView extends StatelessWidget {
  final AsyncSnapshot<List<QueryDocumentSnapshot<Item>>> snapshot;
  final _fireStorage = FirebaseStorage.instance;

  MainGridView({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final imageRef = _fireStorage.ref(snapshot.data![index].data().imagesUrl[0]);
        return FutureBuilder(
          future: AccountService.getLocation(snapshot.data![index].data().ownerId),
          builder: (BuildContext context,
              AsyncSnapshot<List<dynamic>> locationSnap) {
            return Card(
              elevation: 5,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, ItemDetailPage.routeName,
                      arguments: DetailArguments(
                          snapshot.data![index].data(), locationSnap.data![2]));
                },
                child: Column(
                  children: [
                    FutureBuilder<Uint8List?>(
                      future: StorageService.getData(imageRef),
                      builder: (context, storageSnap) {
                        if (!storageSnap.hasData) {
                          return Expanded(
                              flex: 6,
                              child:
                                  Center(child: CircularProgressIndicator()));
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
                        child: Text(snapshot.data![index].data().name),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    !locationSnap.hasData
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(locationSnap.data![2]),
                                Text(DateDiffDescriber.dayDiff(
                                    snapshot.data![index].data().addedSince,
                                    DateTime.now()))
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        );
      },
      itemCount: snapshot.data?.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    );
  }
}
