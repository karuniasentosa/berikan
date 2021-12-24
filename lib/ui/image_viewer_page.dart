import 'dart:typed_data';

import 'package:berikan/widget/button/primary_button.dart';
import 'package:flutter/material.dart';

class ImageViewerPage extends StatelessWidget
{
  static const routeName = '/image_viewer_page';

  final String imageId;
  final Uint8List imageData;

  const ImageViewerPage({Key? key, required this.imageId, required this.imageData}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white)
        ),
      ),
      body: Stack(
        children: [
          Hero(
            tag: imageId,
            child: Image.memory(imageData),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: PrimaryButton(text: 'Simpan', onPressed: (){}),
          )
        ],
      ),
    );
  }

}