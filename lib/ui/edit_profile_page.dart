import 'dart:io';
import 'dart:typed_data';

import 'package:berikan/api/model/account.dart';
import 'package:berikan/api/storage_service.dart';
import 'package:berikan/common/style.dart';
import 'package:berikan/utills/arguments.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:berikan/widget/custom_textfield.dart';
import 'package:berikan/widget/icon_with_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  static const routeName = '/editProfilePage';
  final email = FirebaseAuth.instance.currentUser?.email;

  EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  File? image;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _currentAccount = ModalRoute.of(context)?.settings.arguments as EditProfileArguments;
    final _profileRef = FirebaseStorage.instance.ref(_currentAccount.account.avatarUrl);
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: colorPrimaryLight,
            child: Center(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipOval(
                        child: FutureBuilder<Uint8List?>(
                          future: StorageService.getData(_profileRef),
                          builder: (context, snapshot) {
                            if (image != null) {
                              return Image.file(
                                image!,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              );
                            }
                            else if(snapshot.connectionState == ConnectionState.waiting){
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (!snapshot.hasData) {
                              return ClipRRect(
                                child: Image.asset('lib/data/assets/profile1.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,)
                              );
                            } else {
                              return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              );
                            }
                          },
                        ),
                      ),
                      Positioned(
                        right: -25,
                        bottom: -25,
                        child: MaterialButton(
                          color: Colors.white,
                          onPressed: () {
                            showCustomDialog(context, ImagePicker());
                          },
                          child: const Icon(Icons.add_a_photo),
                          shape: const CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Text(
                      widget.email!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomTextField(
              _currentAccount.account.firstName,
              isBold: true,
              type: TextInputType.text,
              isObscure: false,
              controller: _firstNameController,
              labelText: 'First Name',
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomTextField(
              _currentAccount.account.lastName,
              isBold: true,
              type: TextInputType.text,
              isObscure: false,
              controller: _lastNameController,
              labelText: 'Last Name',
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomTextField(
              _currentAccount.account.phoneNumber,
              isBold: true,
              type: TextInputType.phone,
              isObscure: false,
              controller: _phoneNumberController,
              labelText: 'Phone Number',
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomTextField(
              '',
              isBold: true,
              type: TextInputType.visiblePassword,
              isObscure: true,
              controller: _passwordController,
              labelText: 'Current Password',
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          const SizedBox(
            height: 24,
          ),
          PrimaryButton(
              text: 'Simpan',
              onPressed: () async {
                //credential for checking user password later.
                AuthCredential credential =
                EmailAuthProvider.credential(email: widget.email!, password: _passwordController.text);

                try {
                  //check if password input from the user is correct
                  final user = await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
                  var account = accountDocumentReference(FirebaseFirestore.instance, user.user!.uid);

                  if (_firstNameController.text.isEmpty) {
                    _firstNameController.text = _currentAccount.account.firstName;
                  }
                  if (_lastNameController.text.isEmpty) {
                    _lastNameController.text = _currentAccount.account.lastName;
                  }
                  if (_phoneNumberController.text.isEmpty) {
                    _phoneNumberController.text = _currentAccount.account.phoneNumber;
                  }
                  //update account
                  account.update({
                    'first_name': _firstNameController.text,
                    'last_name': _lastNameController.text,
                    'phone_number': _phoneNumberController.text,
                  });

                  // if user updated their profile picture
                  if (image != null) {
                    final imageRef = FirebaseStorage.instance
                        .ref('user_profile/')
                        .child('${user.user?.uid}.jpg');

                   await StorageService.putData(imageRef, image!.readAsBytesSync());
                  }

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Account updated')));

                } catch (e) {
                  const snackBar = SnackBar(content: Text('Password Incorrect.'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              })
        ],
      ),
    );
  }

  Future? showCustomDialog(BuildContext context, ImagePicker _picker) {
    showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(title: const Text('Ambil gambar dari...'), children: [
            SimpleDialogOption(
              child: IconWithText(icon: const Icon(Icons.image), text: 'Galeri'),
              onPressed: () async {
                final XFile? file =
                    await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  image = File(file!.path);
                });
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: IconWithText(icon: const Icon(Icons.camera), text: 'Kamera'),
              onPressed: () async {
                final XFile? file =
                    await _picker.pickImage(source: ImageSource.camera);
                setState(() {
                  image = File(file!.path);
                });
                Navigator.pop(context);
              },
            )
          ]);
        });
  }
}
