import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:berikan/common/style.dart';
import 'package:berikan/ui/image_viewer_page.dart';
import 'package:berikan/utills/arguments.dart';
import 'package:berikan/utils/related_to_strings.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final TimeOfDay time;
  final String? text;
  final Uint8List? imageFile;
  final bool isMyChat;

  const MessageBubble._(
      {Key? key,
      required this.time,
      this.text,
      this.imageFile,
      required this.isMyChat})
      : super(key: key);

  /// Constructs a [MessageBubble] widget only a text.
  factory MessageBubble.text(
      {Key? key,
      required TimeOfDay time,
      required String text,
      required bool isMyChat}) {
    return MessageBubble._(
        key: key, time: time, isMyChat: isMyChat, text: text);
  }

  /// Constructs a [MessageBubble] widget only an attachment.
  factory MessageBubble.attachment(
      {Key? key,
      required TimeOfDay time,
      required Uint8List imageFile,
      required bool isMyChat}) {
    return MessageBubble._(
        time: time, isMyChat: isMyChat, imageFile: imageFile);
  }

  final myBorderRadius = const BorderRadius.only(
    topLeft: Radius.circular(20),
    bottomLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  );

  final otherBorderRadius = const BorderRadius.only(
    topRight: Radius.circular(20),
    bottomRight: Radius.circular(20),
    bottomLeft: Radius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment:
            isMyChat ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Material(
            color: isMyChat ? colorPrimaryLight : Colors.white,
            borderRadius: isMyChat ? myBorderRadius : otherBorderRadius,
            elevation: 5.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: imageFile == null
                  ? _buildTextBubble(context)
                  : _buildImageBubble(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextBubble(BuildContext context) {
    return Wrap(
        spacing: 16,
        direction: Axis.horizontal,
        alignment: WrapAlignment.end,
        children: [
          Text(
            text!,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(time.format(context)),
        ]);
  }

  Widget _buildImageBubble(BuildContext context) {
    final id = randomString(Random(DateTime.now().millisecond), length: 10);
    return SizedBox(
      width: 240,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: isMyChat ? myBorderRadius : otherBorderRadius,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context,
                    ImageViewerPage.routeName,
                    arguments: ImageViewerArguments(id, imageFile!)
                );
              },
              child: Hero(
                tag: id,
                child: AspectRatio(aspectRatio: 1,child: Image.memory(imageFile!, fit: BoxFit.cover)),
              ),
            ),
          ),
          Positioned(
            child: Container(
                color: Colors.black.withAlpha(1), width: 40, height: 40),
            bottom: 0,
            right: 0,
          ),
          Positioned(
            child: Text(time.format(context),
                style: TextStyle(color: Colors.white)),
            bottom: 0,
            right: 0,
          ),
        ],
      ),
    );
  }
}
