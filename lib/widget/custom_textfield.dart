import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final TextInputType type;
  final bool isObscure;

  const CustomTextField(this.text, {Key? key, required this.type, required this.isObscure}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isObscure,
      keyboardType: type,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: const OutlineInputBorder(),
          hintText: text),
    );
  }
}
