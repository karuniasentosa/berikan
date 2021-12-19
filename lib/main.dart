import 'package:berikan/common/style.dart';
import 'package:berikan/ui/add_item_page.dart';
import 'package:berikan/ui/chat_detail_page.dart';
import 'package:berikan/ui/chat_page.dart';
import 'package:berikan/ui/home_page.dart';
import 'package:berikan/ui/image_viewer_page.dart';
import 'package:berikan/ui/login_page.dart';
import 'package:berikan/ui/main_page.dart';
import 'package:berikan/ui/signup_continue_page.dart';
import 'package:berikan/ui/signup_page.dart';
import 'package:berikan/utills/arguments.dart';
import 'package:firebase_core/firebase_core.dart';
import 'common/style.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        MainPage.routeName: (context) => MainPage(),
        SignupContinuePage.routeName: (context) => const SignupContinuePage(),
        SignupPage.routeName: (context) => const SignupPage(),
        HomePage.routeName: (context) => const HomePage(),
        LoginPage.routeName: (context) => const LoginPage(),
        AddItemPage.routeName: (context) => AddItemPage(),
        ChatPage.routeName: (context) => const ChatPage(),
        ChatDetailPage.routeName: (context) => ChatDetailPage(),
        ImageViewerPage.routeName: (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments as ImageViewerArguments;
          return ImageViewerPage(imageId: arguments.imageId, imageData: arguments.imageData);
        }
      },
    );
  }
}