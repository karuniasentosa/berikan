import 'dart:typed_data';

import 'package:berikan/api/account_service.dart';
import 'package:berikan/api/item_service.dart';
import 'package:berikan/api/model/item.dart';
import 'package:berikan/api/storage_service.dart';
import 'package:berikan/ui/item_detail.dart';
import 'package:berikan/utills/arguments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MyItemPage extends StatelessWidget {
  MyItemPage({Key? key}) : super(key: key);
  static const routeName = '/myItemPage';
  final _currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barang saya'),
      ),
      body: StreamBuilder<List<QueryDocumentSnapshot<Item>>>(
        stream: ItemService.getUserItems(
            FirebaseFirestore.instance, _currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else if(snapshot.data!.isEmpty){
            return const Center(
              child: Text('You don\'t have any items yet'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final imageRefList = [];
                for (int i = 0; i < snapshot.data!.length; i ++) {
                  final imageRef = FirebaseStorage.instance.ref(
                      snapshot.data![index]
                          .data()
                          .imagesUrl[0]);
                  imageRefList.add(imageRef);
                }
                return FutureBuilder<dynamic>(
                  future: AccountService.getLocation(_currentUser.uid),
                  builder: (BuildContext context, locationSnap) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, ItemDetailPage.routeName,
                              arguments: DetailArguments(
                                  snapshot.data![index].data(),
                                  locationSnap.data![2]));
                        },
                        onLongPress: () async {
                          await showDialog(
                            context: context, builder: (context) {
                            return SimpleDialog(
                              children: [
                                SimpleDialogOption(
                                  child: Text('Hapus Barang ini'),
                                  onPressed: () async {
                                    final _fireStorage = FirebaseStorage.instance;

                                    // delete the Firebase Storage images inside the folder
                                    // since Firebase Storage doesn't support deleting 'directory',
                                    // we need to delete all the image inside the dir with a for loop.
                                    final imageList =  await _fireStorage.ref('items_image/').child(snapshot.data![index].id).listAll();
                                    for(var i in imageList.items){
                                      await i.delete();
                                    }
                                    // delete the Firebase Firestore document that contains the item details.
                                    await itemDocumentReference(
                                        FirebaseFirestore.instance,
                                        snapshot.data![index].id).delete();

                                    Navigator.pop(context);

                                    // tell the user that the operation is successful
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text(
                                            'Item Deleted Successfully')));
                                  },
                                )
                              ],
                            );
                          },);
                        },
                        child: ListTile(
                          leading: FutureBuilder<Uint8List?>(
                            future: StorageService.getData(imageRefList[index]),
                            builder: (BuildContext context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              } else {
                                return Image.memory(snapshot.data!);
                              }
                            },

                          ),
                          title: Text(snapshot.data![index]
                              .data()
                              .name),
                        ),
                      );
                    }
                  },
                );
              },);
          }
        },
      ),
    );
  }
}
