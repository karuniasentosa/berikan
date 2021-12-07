import 'package:cloud_firestore/cloud_firestore.dart'
    show CollectionReference, DocumentReference, DocumentSnapshot, FirebaseFirestore, SetOptions, SnapshotOptions, Timestamp;

/// Account class from FireStore model.
class Account {
  static const String collectionName = 'account';
  
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

  const Account({
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    required this.joinedSince,
    required this.phoneNumber,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          avatarUrl == other.avatarUrl &&
          joinedSince == other.joinedSince &&
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode =>
      firstName.hashCode ^
      lastName.hashCode ^
      avatarUrl.hashCode ^
      joinedSince.hashCode ^
      phoneNumber.hashCode;

  @override
  String toString() {
    return 'Account{firstName: $firstName, lastName: $lastName, avatarUrl: $avatarUrl, joinedSince: $joinedSince, phoneNumber: $phoneNumber}';
  }

  /// Converts from a Firestore data to [Account] class.
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

    return Account(
        firstName: firstName,
        lastName: lastName,
        avatarUrl: avatarUrl,
        joinedSince: joinedSince,
        phoneNumber: phoneNumber,
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
    };
  }
}

/// Returns a type-safe [CollectionReference] of [Account] class.
///
/// [instance] is required to... because uh... it is required!
CollectionReference<Account> accountCollectionReference(FirebaseFirestore instance) =>
    instance.collection(Account.collectionName).withConverter<Account>
    (
      fromFirestore: Account.fromFirestore,
      toFirestore: Account.toFirestore,
    );

/// Returns a type-safe [DocumentReference] of [Account] class within the document [id].
///
/// [instance] is required to... because uh... it is required!
DocumentReference<Account> accountDocumentReference(FirebaseFirestore instance, String id) =>
    accountCollectionReference(instance).doc(id);