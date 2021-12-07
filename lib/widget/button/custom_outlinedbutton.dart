import 'package:berikan/common/style.dart';
import 'package:berikan/ui/signup_page.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;

  const CustomOutlinedButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: const BorderSide(width: 5, color: colorPrimaryDark)),
      onPressed: () {
        Navigator.pushNamed(context, SignupPage.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 37, vertical: 15),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .button!
              .copyWith(color: colorPrimaryDark),
        ),
      ),
    );
  }
}
