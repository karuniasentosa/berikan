import 'package:berikan/common/style.dart';
import 'package:berikan/ui/home_page.dart';
import 'package:berikan/ui/login_page.dart';
import 'package:berikan/ui/signup_page.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: textTheme,
      ),
      initialRoute: SignupPage.routeName,
      routes: {
        SignupPage.routeName: (context) => const SignupPage(),
        HomePage.routeName: (context) => const HomePage(),
        LoginPage.routeName: (context) => const LoginPage(),
      },
    );
  }
}