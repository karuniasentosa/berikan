import 'package:flutter/material.dart';

class IconWithText extends StatelessWidget {
  final Icon icon;
  final String text;
  final TextStyle? textStyle;

  IconWithText({required this.icon, required this.text, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          icon,
          const SizedBox(width: 4),
          Flexible(
            child: Text(
            text,
            style: textStyle,
            maxLines: 2,
          ),
        )
      ]
    );
  }
}
