import 'package:berikan/common/style.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:berikan/widget/button/custom_textbutton.dart';
import 'package:berikan/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupContinuePage extends StatefulWidget {
  static const routeName = '/signupContinuePage';

  const SignupContinuePage({Key? key}) : super(key: key);

  @override
  State<SignupContinuePage> createState() => _SignupContinuePageState();
}

class _SignupContinuePageState extends State<SignupContinuePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
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
              child: Text('Sedikit Lagi',
                  style: blackTitle.copyWith(fontSize: 45)),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Text(
                  'Foto Profil',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(
                  height: 8,
                ),
                Stack(children: [
                  CircleAvatar(
                    radius: 70.0,
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(65),
                      child: Image.asset('lib/data/assets/profile1.png'),
                    ),
                  ),
                  Positioned(bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo), onPressed: () { },
                        ),
                      ))
                ]),
              ],
            ),
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
            CustomTextField('', type: TextInputType.text, isObscure: false, controller: _firstNameController,),
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
            CustomTextField('', type: TextInputType.text, isObscure: false, controller: _lastNameController,),
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
            CustomTextField('Diawali dengan +62', type: TextInputType.phone, isObscure: false, controller: _phoneNumberController,),
            const SizedBox(
              height: 40,
            ),
            PrimaryButton(
              text: 'SELESAI',
              onPressed: () {},
            ),
            const SizedBox(
              height: 12,
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
    _phoneNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
  }
}
