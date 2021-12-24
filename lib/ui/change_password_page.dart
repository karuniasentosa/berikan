import 'package:berikan/widget/button/primary_button.dart';
import 'package:berikan/widget/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);
  static const routeName = '/changePasswordPage';

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change your Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: CustomTextField('',
                  type: TextInputType.visiblePassword,
                  isObscure: true,
                  controller: _currentPasswordController,
                  labelText: 'Current Password'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: CustomTextField('',
                  type: TextInputType.visiblePassword,
                  isObscure: true,
                  controller: _newPasswordController,
                  labelText: 'New Password'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: CustomTextField('',
                  type: TextInputType.visiblePassword,
                  isObscure: true,
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Your New Password'),
            ),
            PrimaryButton(
              text: 'Change Your Password',
              onPressed: () async {
                try {
                  final currentUser = FirebaseAuth.instance.currentUser;

                  if (_confirmPasswordController.text !=
                      _newPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Confirm Password do not match.')));
                    return;
                  }

                  ///The idea here is that for the user to change the password, they need to put their correct current password first.
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: currentUser!.email!,
                      password: _currentPasswordController.text);

                  await currentUser.updatePassword(_newPasswordController.text);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password Updated')));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Your new password is too weak')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.toString()),
                    ));
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
