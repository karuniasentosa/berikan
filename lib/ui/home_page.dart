import 'package:berikan/common/constant.dart';
import 'package:berikan/common/style.dart';
import 'package:berikan/ui/login_page.dart';
import 'package:berikan/widget/button/custom_outlinedbutton.dart';
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
              height: 50,
            ),
            Flexible(
              child: Center(
                child: Text(
                  'Berikan',
                  style: blackTitle,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  lorem,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Flexible(
              child: PrimaryButton(text: 'MASUK', onPressed: (){
                Navigator.pushNamed(context, LoginPage.routeName);
              },),
            ),
            const SizedBox(
              height: 16,
            ),
            const Flexible(child: CustomOutlinedButton(text: 'DAFTAR',)),
            const SizedBox(
              height: 24,
            ),
            Flexible(child: CustomTextButton(text: 'TENTANG KAMI', onPressed: (){},)),
          ],
        ),
      ),
    );
  }
}




