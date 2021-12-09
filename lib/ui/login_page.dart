import 'package:berikan/common/style.dart';
import 'package:berikan/ui/main_page.dart';
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
                  const CustomTextField('Seperti: john.doe@mail.com', type: TextInputType.emailAddress, isObscure: false,),
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
                  const CustomTextField('', type: TextInputType.visiblePassword, isObscure: true,)
                ],
              ),
            ),
            PrimaryButton(text: 'MASUK', onPressed: (){
              Navigator.pushNamed(context, MainPage.routeName);
            },),
            const SizedBox(
              height: 32,
            ),
            Flexible(child: CustomTextButton(text: 'LUPA PASSWORD?', onPressed: (){},)),
            Flexible(
              child: CustomTextButton(text: 'KEMBALI', onPressed: (){
                Navigator.pop(context);
              },),
            ),
          ],
        ),
      ),
    );
  }
}

