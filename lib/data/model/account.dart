import 'package:berikan/data/model/item.dart';

import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, Timestamp, SnapshotOptions, SetOptions, CollectionReference;

/// Account class from FireStore model.
class Account {
  /// The first name of the account
  final String firstName;

  /// The last name of the account
  final String lastName;

  /// The Avatar URL of the account,
  ///
  /// this contains link to Firebase Storage url
  ///
  /// e.g.: gs://berikan-capstone.appspot.com/items_image/10ol970JjB43kPBmr6Zl/1265845835.jpg
  ///
  /// Must be retrieved using Firebase Storage library.
  final String avatarUrl;

  /// The time when this account joined
  final DateTime joinedSince;

  /// The phone number of this account
  final String phoneNumber;

  // The item which this account likes;
  final List<Item> likedItem;

  const Account({required this.firstName, required this.lastName, required this.avatarUrl, required this.joinedSince, required this.phoneNumber, required this.likedItem});

  /// Converts from a Firestore data to this class.
  ///
  /// This function should not be called directly — and should be passed to
  /// [CollectionReference.withConverter] function.
  ///
  /// See: [CollectionReference.withConverter](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/CollectionReference/withConverter.html)
  ///
  /// See also: [FromFirestore](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/FromFirestore.html)
  static Account fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? _) {
    final data = snapshot.data()!;

    final avatarUrl = data['avatar_url'] as String;
    final firstName = data['first_name'] as String;
    final lastName = data['last_name'] as String;
    final joinedSince = (data['joined_since'] as Timestamp).toDate();
    final phoneNumber = data['phone_number'] as String;
    final likedItem = data['likedItem'] as List<Item>; // TODO: Test this item

    return Account(
        firstName: firstName,
        lastName: lastName,
        avatarUrl: avatarUrl,
        joinedSince: joinedSince,
        phoneNumber: phoneNumber,
        likedItem: likedItem
    );
  }

  /// Converts from this data class to Firestore data.
  ///
  /// This function should not be called directly — and should be passed to
  /// [CollectionReference.withConverter] function.
  ///
  /// See: [CollectionReference.withConverter](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/CollectionReference/withConverter.html)
  ///
  /// See also: [ToFirestore](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/ToFirestore.html)
  static Map<String, Object?> toFirestore(Account model, SetOptions? options) {
    return {
      'avatar_url': model.avatarUrl,
      'first_name': model.firstName,
      'last_name' : model.lastName,
      'joined_since': Timestamp.fromDate(model.joinedSince),
      'phone_number': model.phoneNumber,
      'liked_item': model.likedItem,
    };
  }
}

