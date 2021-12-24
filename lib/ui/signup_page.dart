import 'package:berikan/common/style.dart';
import 'package:berikan/ui/signup_continue_page.dart';
import 'package:berikan/utills/arguments.dart';
import 'package:berikan/widget/button/custom_textbutton.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:berikan/widget/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            CustomTextField(
              'Seperti: john.doe@mail.com',
              isObscure: false,
              type: TextInputType.emailAddress,
              controller: _emailController, labelText: '',
            ),
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
            CustomTextField(
              '',
              type: TextInputType.visiblePassword,
              isObscure: true,
              controller: _passwordController, labelText: '',
            ),
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
            CustomTextField(
              '',
              type: TextInputType.visiblePassword,
              isObscure: true,
              controller: _retypePasswordController, labelText: '',
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0),
              child: PrimaryButton(
                text: 'LANJUT',
                onPressed: () async {
                  if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty ||
                      _retypePasswordController.text.isEmpty) {
                    const snackBar =
                        SnackBar(content: Text('Fields cannot be empty'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (_passwordController.text !=
                      _retypePasswordController.text) {
                    const snackBar = SnackBar(
                        content:
                            Text('Password and Retype Password do not match'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    try {
                      UserCredential userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text);
                      Navigator.pushReplacementNamed(
                          context, SignupContinuePage.routeName,
                          arguments: SignupArguments(userCredential.user?.uid));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-email') {
                        const snackBar =
                            SnackBar(content: Text('Invalid email address'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (e.code == 'email-already-in-use') {
                        const snackBar =
                            SnackBar(content: Text('This email has been used'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (e.code == 'weak-password') {
                        const snackBar = SnackBar(
                          content: Text('The password provided is too weak.'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  }
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextButton(
              text: 'KEMBALI',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
