import 'package:berikan/common/style.dart';
import 'package:berikan/widget/button/black_button.dart';
import 'package:berikan/widget/button/kembali_button.dart';
import 'package:berikan/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routeName = '/loginPage';

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
                'Masuk',
                style: blackTitle,
              ),
            ),
            const SizedBox(
              height: 75,
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
                  const SizedBox(
                    height: 4,
                  ),
                  const CustomTextField('')
                ],
              ),
            ),
            const SizedBox(
              height: 75,
            ),
            BlackButton(text: 'MASUK', onPressed: (){},),
            const SizedBox(
              height: 32,
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'LUPA PASSWORD?',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.apply(decoration: TextDecoration.underline),
              ),
            ),
            const KembaliTextButton(),
          ],
        ),
      ),
    );
  }
}
