import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final TextInputType type;
  final bool isObscure;
  final TextEditingController controller;

  const CustomTextField(this.text, {Key? key, required this.type, required this.isObscure, required this.controller}) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isObscure,
      keyboardType: widget.type,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: const OutlineInputBorder(),
          hintText: widget.text),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }
}
