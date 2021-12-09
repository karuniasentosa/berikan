import 'package:berikan/common/style.dart';
import 'package:berikan/ui/signup_continue_page.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:berikan/widget/button/custom_textbutton.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 32),
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 75,
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
            const CustomTextField('Seperti: john.doe@mail.com', isObscure: false, type: TextInputType.emailAddress,),
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
            const CustomTextField('', type: TextInputType.visiblePassword, isObscure: true),
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
            const SizedBox(
              height: 4,
            ),
            const CustomTextField('', type: TextInputType.visiblePassword, isObscure: true),
            const SizedBox(
              height: 40,
            ),
            PrimaryButton(
              text: 'LANJUT',
              onPressed: () {
                Navigator.pushNamed(context, SignupContinuePage.routeName);
              },
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextButton(text: 'KEMBALI', onPressed: (){
              Navigator.pop(context);
            },),
          ],
        ),
      ),
    );
  }
}
