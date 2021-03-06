import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  static Future<DocumentSnapshot<Map<String, dynamic>>> getAccountById(String ownerId) async{
    /// Not using accountDocumentReference since it's using converter without location.
    final docRef = FirebaseFirestore.instance.collection(Account.collectionName).doc(ownerId);
    final data = await docRef.get();
    return data;
  }

  static Future<void> addAccount(String? id, Account account) async {
    accountDocumentReference(FirebaseFirestore.instance, id!).set(account);
  }

  static Future<List<dynamic>> getLocation(String ownerId) async {
    final accountDocRef = FirebaseFirestore.instance
        .collection('account').doc(ownerId);
    final snapshot = await accountDocRef.get();

    final location = snapshot.data()!['location'] as List<dynamic>;

    return location;
  }

  static Future<bool> isLocationSet(String uid) async {
    final accountDocRef = FirebaseFirestore.instance
        .collection(Account.collectionName).doc(uid);
    final snapshot = await accountDocRef.get();

    final location = snapshot.data()!['location'];
    
    return location != null;
  }

  static void setLocation(String uid, {required String adm1, required String adm2, required String adm3}) async {
    if (await AccountService.isLocationSet(uid) == true) {
      return;
    }

    final accountDocRef = FirebaseFirestore.instance
        .collection(Account.collectionName).doc(uid);
    accountDocRef.update({
      'location': [adm1, adm2, adm3]
    });
  }

  static Future<dynamic> getProfilePicture(String ownerId) async {
    final accountDocRef = FirebaseFirestore.instance
        .collection(Account.collectionName).doc(ownerId);
    final snapshot = await accountDocRef.get();
    final String profileImage = snapshot.data()!['avatar_url'];

    final imageRef = FirebaseStorage.instance.ref(profileImage);
    return imageRef;

  }

  static Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
