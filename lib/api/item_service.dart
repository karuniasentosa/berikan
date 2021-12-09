import 'package:berikan/api/model/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemService {
  /// No constructor.
  ItemService._() { }

  static Future<List<Item>> getAllItems(FirebaseFirestore instance) async {
    final collectionReference = itemCollectionReference(instance);
    final snapshot = await collectionReference.get();
    final List<Item> items = snapshot.docs.map((qds) => qds.data()).toList();
    return items;
  }

  static Future<List<Item>> searchItems(
      FirebaseFirestore instance,
      String query) async {
    // example:
    // query = "buku"
    // returns = ["bukv", "bukw", "buku ", "buku t", ..."]
    final _query = itemCollectionReference(instance)
        .where('name', isGreaterThanOrEqualTo: query); // only search by name?
    final snapshot = await _query.get();
    final List<Item> items = snapshot.docs.map((qds) => qds.data()).toList();
    return items;
  }
}