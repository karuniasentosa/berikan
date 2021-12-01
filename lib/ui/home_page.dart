import 'package:berikan/common/constant.dart';
import 'package:berikan/common/style.dart';
import 'package:berikan/ui/login_page.dart';
import 'package:berikan/ui/signup_page.dart';
import 'package:berikan/widget/button/custom_textbutton.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/launchPage';

  const HomePage({Key? key}) : super(key: key);

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
        body: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Center(
              child: Text(
                'Berikan',
                style: blackTitle,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                lorem,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            PrimaryButton(text: 'MASUK', onPressed: (){
              Navigator.pushNamed(context, LoginPage.routeName);
            },),
            const SizedBox(
              height: 16,
            ),
            Align(
              child: SizedBox(
                width: 300,
                height: 72,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      side:
                          const BorderSide(width: 5, color: colorPrimaryDark)),
                  onPressed: () {
                    Navigator.pushNamed(context, SignupPage.routeName);
                  },
                  child: Text(
                    'DAFTAR',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.apply(color: colorPrimaryDark, letterSpacingDelta: 5),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            CustomTextButton(text: 'TENTANG KAMI', onPressed: (){},),
          ],
        ),
      ),
    );
  }
}


