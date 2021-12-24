import 'dart:io';
import 'dart:math';

import 'package:berikan/ui/image_viewer_page.dart';
import 'package:berikan/utills/arguments.dart';
import 'package:berikan/utils/related_to_strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'icon_with_text.dart';

typedef ReceiveImageCallback = void Function(File file);

class ImagePick extends StatefulWidget {
  final double width;
  final double height;
  final ReceiveImageCallback? onImageSelect;
  final Function()? onImageDrop;

  ImagePick(
      {required this.width,
      required this.height,
      this.onImageSelect,
      this.onImageDrop});

  @override
  State<StatefulWidget> createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    final imageId = randomString(Random(DateTime.now().millisecond), length: 5);
    return GestureDetector(
      child: imageFile == null
          ? noImage()
          : Hero(
              tag: imageId,
              child: Image.file(
                imageFile!,
                width: widget.width,
                height: widget.height,
                fit: BoxFit.none,
                cacheWidth: widget.width.round(),
                cacheHeight: widget.height.round(),
              ),
            ),
      onTap: () {
        if (imageFile != null) {
          final args = ImageViewerArguments(imageId, imageFile!.readAsBytesSync());
          Navigator.pushNamed(context, ImageViewerPage.routeName, arguments: args);
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
