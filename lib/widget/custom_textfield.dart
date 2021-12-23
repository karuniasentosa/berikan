import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final TextInputType type;
  final bool isObscure;
  final bool isBold;
  final TextEditingController controller;
  final String labelText;

  const CustomTextField(this.text, {Key? key, required this.type, required this.isObscure, required this.controller, required this.labelText, this.isBold = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: type,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: labelText,
          fillColor: Colors.white,
          filled: true,
          border: const OutlineInputBorder(),
          hintText: text,
      hintStyle: isBold? Theme.of(context).textTheme.bodyText1?.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ) : Theme.of(context).textTheme.bodyText1),
    );
  }

}




