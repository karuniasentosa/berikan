import 'package:berikan/common/constant.dart';
import 'package:berikan/common/style.dart';
import 'package:berikan/widget/black_button.dart';
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
        body: ListView(
          shrinkWrap: true,
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
            const BlackButton(text: 'MASUK'),
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
                  onPressed: () {},
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
            TextButton(
              onPressed: () {},
              child: Text(
                'TENTANG KAMI',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.apply(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


