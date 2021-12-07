import 'package:berikan/data/model/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show CollectionReference, DocumentSnapshot, GeoPoint, SetOptions, SnapshotOptions, Timestamp;

class Item
{
  final List<String> imagesUrl;
  final String name;
  final DateTime addedSince;
  final GeoPoint location;
  final Account owner;
  final String description;
  // final Map<String, String> detail;

  const Item({required this.imagesUrl, required this.name, required this.addedSince, required this.location, required this.owner, required this.description});

  /// Converts from a Firestore data to [Item] class.
  ///
  /// This function should not be called directly — and should be passed to
  /// [CollectionReference.withConverter] function.
  ///
  /// See: [CollectionReference.withConverter](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/CollectionReference/withConverter.html)
  ///
  /// See also: [FromFirestore](https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/FromFirestore.html)
  static Item fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? _) {
    final data = snapshot.data()!;

    final addedSince = (data['added_since'] as Timestamp).toDate();
    final description = data['description'] as String;
    final imagesUrl = data['images'] as List<String>;
    // final detail = data['detail'] as String;
    // final itemType = data['item_type'] as ItemType;
    final location = data['location'] as GeoPoint;
    final name = data['name'] as String;
    final owner = data['owner'] as Account;

    return Item(
        imagesUrl: imagesUrl,
        name: name,
        addedSince: addedSince,
        location: location,
        owner: owner,
        description: description
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
  static Map<String, Object?> toFirestore(Item model, SetOptions? options) {
    return {
      'added_since'   :   Timestamp.fromDate(model.addedSince),
      'description'   :   model.description,
      'images'        :   model.imagesUrl,
      'location'      :   model.location,
      'name'          :   model.name,
      'owner'         :   model.owner,
    };
  }
}