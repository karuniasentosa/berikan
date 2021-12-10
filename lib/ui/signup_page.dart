import 'package:berikan/common/style.dart';
import 'package:berikan/ui/signup_continue_page.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:berikan/widget/button/custom_textbutton.dart';
import 'package:berikan/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatefulWidget {
  static const routeName = '/signupPage';

  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();
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
            CustomTextField('Seperti: john.doe@mail.com', isObscure: false, type: TextInputType.emailAddress, controller: _emailController,),
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
            CustomTextField('', type: TextInputType.visiblePassword, isObscure: true, controller: _passwordController,),
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
            CustomTextField('', type: TextInputType.visiblePassword, isObscure: true, controller: _retypePasswordController,),
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

  @override
  void dispose() {
    super.dispose();
    _retypePasswordController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }
}
