import 'package:berikan/common/style.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMyChat;

  MessageBubble(
      {Key? key,
      required this.sender,
      required this.text,
      required this.isMyChat})
      : super(key: key);

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
        crossAxisAlignment: isMyChat? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8,),
          Material(
            color: isMyChat? colorPrimaryLight : Colors.white,
            borderRadius: isMyChat? myBorderRadius : otherBorderRadius,
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  const Text('11:00')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
