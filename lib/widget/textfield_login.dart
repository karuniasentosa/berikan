import 'package:flutter/material.dart';

class TextFieldLogin extends StatelessWidget {
  final String text;

  const TextFieldLogin(this.text, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: const OutlineInputBorder(),
          hintText: text),
    );
  }
}
