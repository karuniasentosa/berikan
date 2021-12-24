import 'package:berikan/common/style.dart';
import 'package:berikan/ui/main_page.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:berikan/widget/button/custom_textbutton.dart';
import 'package:berikan/widget/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:berikan/api/account_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routeName = '/loginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
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
                  CustomTextField(
                    'Seperti: john.doe@mail.com',
                    key: const Key('emailTextField'),
                    type: TextInputType.emailAddress,
                    isObscure: false,
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
                    key: const Key('passwordTextField'),
                    type: TextInputType.visiblePassword,
                    isObscure: true,
                    controller: _passwordController, labelText: '',
                  )
                ],
              ),
            ),
            PrimaryButton(
              key: const Key('loginPageLoginButton'),
              text: 'MASUK',
              onPressed: () async {
                //Hides the keyboard
                FocusScope.of(context).unfocus();
                try {
                  await AccountService.signIn(
                      _emailController.text, _passwordController.text);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    const snackBar = SnackBar(
                        content: Text('No user found with that email'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  } else if (e.code == 'wrong-password') {
                    const snackBar = SnackBar(content: Text('Wrong Password'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  } else if (e.code == 'invalid-email') {
                    const snackBar = SnackBar(
                        content: Text('Please input a proper email address.'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  } else if (e.code == 'unknown') {
                    const snackBar = SnackBar(content: Text('Email address/Password field can\'t be empty'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  } else {
                    final snackBar = SnackBar(content: Text('Error: $e'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                }
              },
            ),
            const SizedBox(
              height: 32,
            ),
            Flexible(
                child: CustomTextButton(
              text: 'LUPA PASSWORD?',
              onPressed: () {},
            )),
            Flexible(
              child: CustomTextButton(
                text: 'KEMBALI',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
