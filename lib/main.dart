import 'package:berikan/common/style.dart';
import 'package:berikan/provider/chat_detail_page_provider.dart';
import 'package:berikan/provider/chat_page_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:berikan/ui/add_item_page.dart';
import 'package:berikan/ui/change_password_page.dart';
import 'package:berikan/ui/chat_detail_page.dart';
import 'package:berikan/ui/chat_page.dart';
import 'package:berikan/ui/edit_profile_page.dart';
import 'package:berikan/ui/home_page.dart';
import 'package:berikan/ui/image_viewer_page.dart';
import 'package:berikan/ui/item_detail.dart';
import 'package:berikan/ui/login_page.dart';
import 'package:berikan/ui/main_page.dart';
import 'package:berikan/ui/my_item_page.dart';
import 'package:berikan/ui/settings_page.dart';
import 'package:berikan/ui/signup_continue_page.dart';
import 'package:berikan/ui/signup_page.dart';
import 'package:berikan/utills/arguments.dart';
import 'package:firebase_core/firebase_core.dart';
import 'api/model/chat.dart';
import 'common/style.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

// Firebase Login with Flutter using onAuthStateChanged
// https://stackoverflow.com/a/50632612
class _MyAppState extends State<MyApp> {
  final app = Firebase.initializeApp();
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berikan',
      theme: lightTheme,
      navigatorKey: _navigatorKey,
      home: Builder(
        builder: (context) {
          FirebaseAuth.instance.idTokenChanges().listen((user) {
            if (user != null) {
              _navigatorKey.currentState!.pushReplacementNamed(MainPage.routeName);
            } else {
              _navigatorKey.currentState!.pushReplacementNamed(HomePage.routeName);
            }
          });

          // TODO: Add some splash screen maybe?
          return Scaffold(
            body: Container(color: Colors.white),
          );
        },
      ),
      routes: {
        MainPage.routeName: (context) => MainPage(),
        SignupContinuePage.routeName: (context) => const SignupContinuePage(),
        SignupPage.routeName: (context) => const SignupPage(),
        HomePage.routeName: (context) => const HomePage(),
        LoginPage.routeName: (context) => const LoginPage(),
        AddItemPage.routeName: (context) => AddItemPage(),
        ItemDetailPage.routeName: (context) => ItemDetailPage(),
        SettingsPage.routeName: (context) => const SettingsPage(),
        EditProfilePage.routeName: (context) => EditProfilePage(),
        ChangePasswordPage.routeName: (context) => ChangePasswordPage(),
        MyItemPage.routeName: (context) => MyItemPage(),
        ChatPage.routeName: (context) => ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(),
          child: ChatPage(),
        ),
        ChatDetailPage.routeName: (context) {
          final chat = ModalRoute.of(context)?.settings.arguments as Chat;
          return ChangeNotifierProvider<ChatDetailPageProvider>(
            create: (_) => ChatDetailPageProvider(),
            child: ChatDetailPage(chat: chat),
          );
        },
        ImageViewerPage.routeName: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as ImageViewerArguments;
          return ImageViewerPage(imageId: args.imageId, imageData: args.imageData);
        },
        ChatDetailPage.routeNameWithItem: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as ChatDetailItemArguments;
          return ChangeNotifierProvider<ChatDetailPageProvider>(
            create: (_) => ChatDetailPageProvider(),
            child: ChatDetailPage.putItem(chat: args.chat, itemId: args.itemId),
          );
        },
      },
    );
  }
}