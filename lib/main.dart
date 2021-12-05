import 'package:berikan/common/style.dart';
import 'package:berikan/ui/add_item_page.dart';
import 'package:berikan/ui/home_page.dart';
import 'package:berikan/ui/login_page.dart';
import 'package:berikan/ui/main_page.dart';
import 'package:berikan/ui/signup_continue_page.dart';
import 'package:berikan/ui/signup_page.dart';
import 'common/style.dart';

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
      theme: lightTheme,
      initialRoute: HomePage.routeName,
      routes: {
        MainPage.routeName: (context) => const MainPage(),
        SignupContinuePage.routeName: (context) => const SignupContinuePage(),
        SignupPage.routeName: (context) => const SignupPage(),
        HomePage.routeName: (context) => const HomePage(),
        LoginPage.routeName: (context) => const LoginPage(),
        AddItemPage.routeName: (context) => const AddItemPage(),
      },
    );
  }
}