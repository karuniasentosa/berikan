import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, CollectionReference, DocumentReference, DocumentSnapshot, GeoPoint, SetOptions, SnapshotOptions, Timestamp;
import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;

const String _collectionName = 'item';

class Item
{
  final List<String> imagesUrl;
  final String name;
  final DateTime addedSince;
  final GeoPoint location;
  final String description;
  final String ownerId;
  // final Map<String, String> detail;

  const Item({
    required this.imagesUrl,
    required this.name,
    required this.addedSince,
    required this.location,
    required this.description,
    required this.ownerId,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          const ListEquality().equals(imagesUrl, other.imagesUrl) &&
          name == other.name &&
          addedSince == other.addedSince &&
          location == other.location &&
          description == other.description &&
          ownerId == other.ownerId;

  @override
  int get hashCode =>
      imagesUrl.hashCode ^
      name.hashCode ^
      addedSince.hashCode ^
      location.hashCode ^
      description.hashCode ^
      ownerId.hashCode;

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
    final imagesUrl = data['images'] as List<dynamic>;
    // final detail = data['detail'] as String;
    // final itemType = data['item_type'] as ItemType;
    final location = data['location'] as GeoPoint;
    final name = data['name'] as String;
    final ownerId = (data['owner'] as DocumentReference<Map<String, dynamic>>).id;

    return Item(
        imagesUrl: imagesUrl.takeWhile((value) => value is String).map<String>((e) => e).toList(),
        name: name,
        addedSince: addedSince,
        location: location,
        description: description,
        ownerId: ownerId,
    );
  }

  /// Converts from this data class to Firestore data.
  ///
  /// This function should not be called directly — and should be passed to
  /// [CollectionReference.withConverter] function.
  ///
  /// [Firebase.initializeApp] must be called before using this function,
  /// otherwise, it will throw an exception.
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
      'owner'         :   FirebaseFirestore.instance.collection(_collectionName).doc(model.ownerId),
    };
  }
}

/// Returns a type-safe [CollectionReference] of [Item] class.
///
/// [instance] is required to... because uh... it is required!
CollectionReference<Item> itemCollectionReference(FirebaseFirestore instance) =>
    instance.collection(_collectionName).withConverter<Item>
    (
      fromFirestore: Item.fromFirestore,
      toFirestore: Item.toFirestore,
    );

/// Returns a type-safe [DocumentReference] of [Item] class within the document [id].
///
/// [instance] is required to... because uh... it is required!
DocumentReference<Item> itemDocumentReference(FirebaseFirestore instance, String id) =>
    instance.collection(_collectionName).doc(id).withConverter<Item>
    (
      fromFirestore: Item.fromFirestore,
      toFirestore: Item.toFirestore
    );