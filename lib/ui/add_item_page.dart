import 'dart:io';
import 'dart:math';
import 'package:berikan/api/account_service.dart';
import 'package:berikan/api/model/account.dart';
import 'package:berikan/api/model/item.dart';
import 'package:berikan/api/storage_service.dart';
import 'package:berikan/utils/related_to_strings.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:berikan/widget/custom_textfield.dart';

import 'package:berikan/api/model/extensions/account_extensions.dart';
import 'package:berikan/widget/image_pick.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddItemPage extends StatefulWidget {
  static const routeName = '/addItemPage';

  AddItemPage({Key? key}) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  static const _imagePickWidth = 120.0;

  final List<File?> imageFile = List<File?>.filled(5, null, growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Nama Barang'),
                  CustomTextField(
                    'Seperti: Sepatu Adidas KW',
                    type: TextInputType.text,
                    isObscure: false,
                    controller: _nameController,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Deskripsi Barang'),
                  TextField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: const OutlineInputBorder(),
                      hintText: 'Deskripsikan barangmu',
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Tambahkan Foto (Max 5)'),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      ImagePick(
                          width: _imagePickWidth,
                          height: _imagePickWidth,
                          onImageSelect: (file) {
                            imageFile[0] = file;
                          },
                          onImageDrop: () { imageFile[0] = null; },
                      ),
                      ImagePick(
                        width: _imagePickWidth,
                        height: _imagePickWidth,
                        onImageSelect: (file) {
                          imageFile[1] = file;
                        },
                        onImageDrop: () { imageFile[1] = null; },
                      ),
                      ImagePick(
                        width: _imagePickWidth,
                        height: _imagePickWidth,
                        onImageSelect: (file) {
                          imageFile[2] = file;
                        },
                        onImageDrop: () { imageFile[2] = null; },
                      ),
                      ImagePick(
                        width: _imagePickWidth,
                        height: _imagePickWidth,
                        onImageSelect: (file) {
                          imageFile[3] = file;
                        },
                        onImageDrop: () { imageFile[3] = null; },
                      ),
                      ImagePick(
                        width: _imagePickWidth,
                        height: _imagePickWidth,
                        onImageSelect: (file) {
                          imageFile[4] = file;
                        },
                        onImageDrop: () { imageFile[4] = null; },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: PrimaryButton(
              text: 'Tambahkan',
              onPressed: () async {
                // do check
                if (_nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                        const SnackBar(
                            content: Text('Isi nama barang terlebih dahulu!')
                        )
                  );
                  return;
                }
                if (_descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                      const SnackBar(
                          content: Text('Isi deskripsi terlebih dahulu!')
                      )
                  );
                  return;
                }
                if (imageFile.every((element) => element == null)) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                      const SnackBar(
                          content: Text('Tambahkan foto sebelum mengunggah!')
                      )
                  );
                  return;
                }

                // get account and uid
                Account? account = await AccountService.getCurrentAccount();
                String? uid = AccountService.getCurrentUser()?.uid;

                // create a new item
                final item = Item.create(
                  uid!,
                  // this imagesUrl was a mistake.
                  imagesUrl: [],
                  name: _nameController.text,
                  addedSince: DateTime.now(),
                  description: _descriptionController.text,
                );

                // get the document reference,
                // to modify imagesUrl later.
                final docRef = await account?.addItem(item);

                // filter File that is null to non-null file
                List<File> nonNullFile = [];
                for (final f in imageFile) {
                  if (f != null) {
                    nonNullFile.add(f);
                  }
                }

                final random = Random(DateTime.now().millisecond);
                final storageReferenceList = List<Reference>.generate(nonNullFile.length,
                        (index) => FirebaseStorage.instance
                            .ref('items_image/')
                            .child(docRef!.id)
                            .child('${randomString(random, length: 5)}.jpg')
                );

                // uploads data
                for (int i = 0; i < nonNullFile.length; i++) {
                  StorageService.putData(storageReferenceList[i], nonNullFile[i].readAsBytesSync());
                }

                // update the image url
                final imageUrls = storageReferenceList.map((e) => e.fullPath).toList();
                
                docRef!.update({'images' : imageUrls});

                Navigator.pop(context);
              },
            )
          )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
  }
}
