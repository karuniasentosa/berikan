import 'package:berikan/common/style.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const PrimaryButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 37, vertical: 15),
        child: Text(
            text,
          style: Theme.of(context).textTheme.button,
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 10,
        primary: colorPrimaryDark,
        shape: const StadiumBorder(),
      ),
    );
  }
}