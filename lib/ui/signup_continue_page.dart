import 'package:berikan/common/style.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:berikan/widget/button/custom_textbutton.dart';
import 'package:berikan/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupContinuePage extends StatelessWidget {
  static const routeName = '/signupContinuePage';

  const SignupContinuePage({Key? key}) : super(key: key);

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
          padding: const EdgeInsets.symmetric(horizontal: 32),
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 35,
            ),
            Center(
              child: Text(
                'Sedikit Lagi',
                style: blackTitle.copyWith(
                  fontSize: 45
                )
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: 120,
                height: 150,
                child: Image.asset('lib/data/assets/profile.png')),
            const SizedBox(
              height: 25,
            ),
            Text(
              'NAMA DEPAN',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const CustomTextField(''),
            const SizedBox(
              height: 16,
            ),
            Text(
              'NAMA BELAKANG',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const CustomTextField(''),
            const SizedBox(
              height: 16,
            ),
            Text(
              'NOMOR TELEPON',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const CustomTextField('Diawali dengan +62'),
            const SizedBox(
              height: 40,
            ),
            PrimaryButton(text: 'SELESAI', onPressed: (){},),
            const SizedBox(
              height: 12,
            ),
            CustomTextButton(text: 'KEMBALI', onPressed: () {
              Navigator.pop(context);
            },),
          ],
        ),
      ),
    );
  }
}

