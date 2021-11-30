import 'package:flutter/material.dart';

class KembaliTextButton extends StatelessWidget {
  const KembaliTextButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        'KEMBALI',
        style: Theme.of(context).textTheme.subtitle1?.apply(
            decoration: TextDecoration.underline,
            fontSizeDelta: 4,
            letterSpacingDelta: 2),
      ),
    );
  }
}