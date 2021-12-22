import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'model/account.dart';

class AccountService {

  /// No constructor
  AccountService._();

  /// The associated [User] for current signed in account.
  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  /// Gets the current account
  ///
  /// Returns [null] if there is no user logged in
  /// through [FirebaseAuth].
  ///
  /// It is recommended to use this function before accessing
  /// the member inside.
  ///
  static Future<Account?> getCurrentAccount() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final docRef = accountDocumentReference(FirebaseFirestore.instance, uid);
    return (await docRef.get()).data();
  }

  static Future<void> addAccount(String? id,Account account) async {
    accountDocumentReference(FirebaseFirestore.instance, id!).set(account);
  }

  static Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    // Should we put credentials inside secure shared preferences?
    // I think we should use native function (Android Kotlin)
    // For now, the credential is persisted until the app is closed.
  }

  static Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }
}
