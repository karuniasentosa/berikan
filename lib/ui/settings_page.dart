import 'dart:typed_data';

import 'package:berikan/api/account_service.dart';
import 'package:berikan/api/model/account.dart';
import 'package:berikan/api/storage_service.dart';
import 'package:berikan/common/style.dart';
import 'package:berikan/ui/change_password_page.dart';
import 'package:berikan/ui/home_page.dart';
import 'package:berikan/ui/my_item_page.dart';
import 'package:berikan/utills/arguments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

import 'edit_profile_page.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settingsPage';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Stream<DocumentSnapshot<Account>> _accountStream =
      accountDocumentReference(FirebaseFirestore.instance, FirebaseAuth.instance.currentUser!.uid).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: StreamBuilder<DocumentSnapshot<Account>>(
        stream: _accountStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var imageRef =
                FirebaseStorage.instance.ref(snapshot.data!.data()?.avatarUrl);
            return Column(
              children: [
                Container(
                  color: colorPrimaryLight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: FutureBuilder<Uint8List?>(
                            future: StorageService.getData(imageRef),
                            builder: (context, imageSnapshot) {
                              if (imageSnapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if(!imageSnapshot.hasData){
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.asset(
                                    'lib/data/assets/profile1.png', fit: BoxFit.fitHeight,
                                  width: 100,
                                  height: 100,),
                                );
                              } else{
                                return ClipOval(
                                  child: Image.memory(
                                    imageSnapshot.data!,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Text(
                        '${snapshot.data?.data()?.firstName} ${snapshot.data?.data()?.lastName}',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SettingsList(
                    sections: [
                      SettingsSection(
                        title: 'Account',
                        tiles: [
                          SettingsTile(
                            leading: const Icon(Icons.person),
                            title: 'Edit Profil',
                            onPressed: (context) {
                              Navigator.pushNamed(
                                      context, EditProfilePage.routeName,
                                      arguments: EditProfileArguments(
                                          snapshot.data!.data()!))
                                  .then((value) {
                                setState(() {});
                              });
                            },
                          ),
                          SettingsTile(
                            leading: const Icon(Icons.security),
                            title: 'Change your password',
                            onPressed: (context){
                              Navigator.pushNamed(context, ChangePasswordPage.routeName);
                            },
                          ),
                          SettingsTile(
                            leading: const Icon(Icons.shopping_cart),
                            title: 'Barang saya',
                            onPressed: (context) {
                              Navigator.pushNamed(context, MyItemPage.routeName);
                            },
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: 'Others',
                        tiles: [
                          SettingsTile(
                            title: 'Privacy & Policy',
                            leading: const Icon(Icons.privacy_tip),
                          ),
                          SettingsTile(
                            title: 'Log Out',
                            leading: const Icon(Icons.logout),
                            onPressed: (context) async {
                              //using await so there's no null value error
                              await Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (Route<dynamic> route) => false);
                              await AccountService.signOut();
                            },
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
