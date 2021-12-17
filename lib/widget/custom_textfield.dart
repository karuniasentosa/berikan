import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final TextInputType type;
  final bool isObscure;
  final TextEditingController controller;

  const CustomTextField(this.text, {Key? key, required this.type, required this.isObscure, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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




