import 'dart:io';
import 'dart:math';
import 'package:berikan/api/account_service.dart';
import 'package:berikan/api/model/account.dart';
import 'package:berikan/api/model/item.dart';
import 'package:berikan/api/storage_service.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:berikan/widget/custom_textfield.dart';
import 'package:berikan/widget/icon_with_text.dart';

import 'package:berikan/api/model/extensions/account_extensions.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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
                      _ImagePick(
                          width: _imagePickWidth,
                          height: _imagePickWidth,
                          onImageSelect: (file) {
                            imageFile[0] = file;
                          },
                          onImageDrop: () { imageFile[0] = null; },
                      ),
                      _ImagePick(
                        width: _imagePickWidth,
                        height: _imagePickWidth,
                        onImageSelect: (file) {
                          imageFile[1] = file;
                        },
                        onImageDrop: () { imageFile[1] = null; },
                      ),
                      _ImagePick(
                        width: _imagePickWidth,
                        height: _imagePickWidth,
                        onImageSelect: (file) {
                          imageFile[2] = file;
                        },
                        onImageDrop: () { imageFile[2] = null; },
                      ),
                      _ImagePick(
                        width: _imagePickWidth,
                        height: _imagePickWidth,
                        onImageSelect: (file) {
                          imageFile[3] = file;
                        },
                        onImageDrop: () { imageFile[3] = null; },
                      ),
                      _ImagePick(
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
                String? uid = account?.user?.uid;

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

typedef ReceiveImageCallback = void Function(File file);

class _ImagePick extends StatefulWidget {
  final double width;
  final double height;
  final ReceiveImageCallback? onImageSelect;
  final Function()? onImageDrop;

  _ImagePick({required this.width, required this.height, this.onImageSelect, this.onImageDrop});

  @override
  State<StatefulWidget> createState() => _ImagePickState();
}

class _ImagePickState extends State<_ImagePick> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: imageFile == null
          ? noImage()
          : Image.file(
              imageFile!,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.none,
              cacheWidth: widget.width.round(),
              cacheHeight: widget.height.round(),
            ),
      onTap: () {
        if (imageFile != null) {
          // TODO: preview image

        } else {
          showImageSourceChooser(context);
        }
      },
      onLongPress: () async {
        if (imageFile == null) return;
        await showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(children: [
                SimpleDialogOption(
                  child: IconWithText(
                      icon: Icon(Icons.change_circle), text: 'Ganti gambar'),
                  onPressed: () async {
                    Navigator.pop(context);
                    showImageSourceChooser(context);
                  },
                ),
                SimpleDialogOption(
                    child: IconWithText(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        text: 'Hapus gambar',
                        textStyle: const TextStyle(color: Colors.red)),
                    onPressed: () {
                      dropImage();
                      if (widget.onImageDrop != null) {
                        widget.onImageDrop!();
                      }
                      Navigator.pop(context);
                    })
              ]);
            });
      },
    );
  }

  void chooseImageCamera() async {
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (file != null) {
      if (widget.onImageSelect != null) {
        widget.onImageSelect!(File(file.path));
      }
      setState(() {
        imageFile = File(file.path);
      });
    }
  }

  void chooseImageGallery() async {
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      if (widget.onImageSelect != null) {
        widget.onImageSelect!(File(file.path));
      }
      setState(() {
        imageFile = File(file.path);
      });
    }
  }

  void showImageSourceChooser(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(title: Text('Ambil gambar dari...'), children: [
            SimpleDialogOption(
              child:
                  IconWithText(icon: const Icon(Icons.image), text: 'Galeri'),
              onPressed: () async {
                chooseImageGallery();
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
                child: IconWithText(
                    icon: const Icon(Icons.camera), text: 'Kamera'),
                onPressed: () {
                  chooseImageCamera();
                  Navigator.pop(context);
                })
          ]);
        });
  }

  void dropImage() {
    setState(() {
      imageFile = null;
    });
  }

  Widget noImage() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: const BoxDecoration(color: Colors.grey),
      child: Icon(Icons.add_a_photo),
    );
  }
}

const String _choice = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
String randomString(Random random, {required int length})
{
  String result = "";
  while (length-- != 0) {
    int c = random.nextInt(_choice.length);
    result += _choice[c];
  }

  return result;
}