import 'package:berikan/common/style.dart';
import 'package:berikan/widget/black_button.dart';
import 'package:berikan/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatelessWidget {
  static const routeName = '/signupPage';
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            gradientSecondaryPrimaryStart,
            gradientSecondaryPrimaryEnd,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 100,
            ),
            Center(
              child: Text(
                'Daftar',
                style: blackTitle,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ALAMAT SUREL',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const CustomTextField('Seperti: john.doe@mail.com'),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'PASSWORD',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const CustomTextField(''),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'KETIK ULANG PASSWORD',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const CustomTextField(''),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const BlackButton(text: 'LANJUT'),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'KEMBALI',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.apply(decoration: TextDecoration.underline, fontSizeDelta: 4, letterSpacingDelta: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
