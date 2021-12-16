import 'dart:io';

import 'package:berikan/api/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:berikan/api/account_service.dart';
import 'package:berikan/api/model/account.dart';
import 'package:berikan/common/style.dart';
import 'package:berikan/utills/arguments.dart';
import 'package:berikan/widget/button/custom_textbutton.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:berikan/widget/custom_textfield.dart';
import 'package:berikan/widget/icon_with_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupContinuePage extends StatefulWidget {
  static const routeName = '/signupContinuePage';

  const SignupContinuePage({Key? key}) : super(key: key);

  @override
  State<SignupContinuePage> createState() => _SignupContinuePageState();
}

class _SignupContinuePageState extends State<SignupContinuePage> {
  final ImagePicker _picker = ImagePicker();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  File? image;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as SignupArguments;

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
          padding: const EdgeInsets.symmetric(horizontal: 32),
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 35,
            ),
            Center(
              child: Text('Sedikit Lagi',
                  style: blackTitle.copyWith(fontSize: 45)),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Text(
                  'Foto Profil',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                const SizedBox(
                  height: 8,
                ),
                Stack(children: [
                  CircleAvatar(
                    radius: 70.0,
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: image == null
                          ? Image.asset('lib/data/assets/profile1.png')
                          : Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add_a_photo),
                        onPressed: () async {
                          await showCustomDialog();
                        },
                      ),
                    ),
                  )
                ]),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              'NAMA DEPAN',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            CustomTextField(
              '',
              type: TextInputType.text,
              isObscure: false,
              controller: _firstNameController,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'NAMA BELAKANG',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            CustomTextField(
              '',
              type: TextInputType.text,
              isObscure: false,
              controller: _lastNameController,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'NOMOR TELEPON',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            CustomTextField(
              'Diawali dengan +62',
              type: TextInputType.phone,
              isObscure: false,
              controller: _phoneNumberController,
            ),
            const SizedBox(
              height: 40,
            ),
            PrimaryButton(
              text: 'SELESAI',
              onPressed: () async {
                if (_firstNameController.text.isEmpty ||
                    _lastNameController.text.isEmpty ||
                    _phoneNumberController.text.isEmpty) {
                  const snackBar = SnackBar(
                      content: Text(
                          'Firstname/Lastname/Phone Number cannot be empty.'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  try {
                    final account = Account(
                        firstName: _firstNameController.text,
                        avatarUrl: '',
                        lastName: _lastNameController.text,
                        joinedSince: DateTime.now(),
                        phoneNumber: _phoneNumberController.text);
                    await AccountService.addAccount(args.id, account);
                    print('user added');

                    if (image != null) {
                      final imageRef = FirebaseStorage.instance
                          .ref('user_profile/')
                          .child('${args.id}.jpg');

                      StorageService.putData(
                          imageRef, image!.readAsBytesSync());

                      accountDocumentReference(
                              FirebaseFirestore.instance, args.id!)
                          .update({'avatar_url': imageRef.fullPath});

                    }
                    Navigator.pop(context);
                  } catch (e) {
                    final snackBar =
                        SnackBar(content: Text('Error adding user : $e'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
            ),
            const SizedBox(
              height: 12,
            ),
            CustomTextButton(
              text: 'KEMBALI',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Future? showCustomDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(title: Text('Ambil gambar dari...'), children: [
            SimpleDialogOption(
              child:
                  IconWithText(icon: const Icon(Icons.image), text: 'Galeri'),
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
              child:
                  IconWithText(icon: const Icon(Icons.camera), text: 'Kamera'),
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

  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
  }
}
