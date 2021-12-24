import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const CustomTextButton({
    Key? key, required this.text, required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1?.copyWith(
          decoration: TextDecoration.underline,
          letterSpacing: 2,
          fontSize: 16
        )
      ),
    );
  }
}