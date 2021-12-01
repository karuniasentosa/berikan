import 'package:berikan/common/style.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:berikan/widget/button/custom_textbutton.dart';
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SizedBox(
              height: 75,
            ),
            Center(
              child: Text(
                'Masuk',
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
                  const SizedBox(
                    height: 4,
                  ),
                  const CustomTextField('')
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            PrimaryButton(text: 'MASUK', onPressed: (){},),
            const SizedBox(
              height: 32,
            ),
            CustomTextButton(text: 'LUPA PASSWORD?', onPressed: (){},),
            CustomTextButton(text: 'KEMBALI', onPressed: (){
              Navigator.pop(context);
            },),
          ],
        ),
      ),
    );
  }
}

