import 'package:berikan/common/style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlackButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const BlackButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        width: 300,
        height: 72,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
              text,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  letterSpacing: 5
              )
          ),
          style: ElevatedButton.styleFrom(
            elevation: 10,
            primary: colorPrimaryDark,
            shape: const StadiumBorder(),
          ),
        ),
      ),
    );
  }
}