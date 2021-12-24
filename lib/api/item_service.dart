import 'package:berikan/api/model/account.dart';
import 'package:berikan/api/model/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemService {
  /// No constructor.
  ItemService._() { }

  static Stream<List<QueryDocumentSnapshot<Item>>> getEveryItems(FirebaseFirestore instance) {
    final collectionReference = itemCollectionReference(instance);
    final snapshot = collectionReference.snapshots();
    final items = snapshot.map((event) => event.docs.toList());
    return items;
  }

  static Stream<List<QueryDocumentSnapshot<Item>>> getUserItems(FirebaseFirestore instance, String uid)  {
    final collectionReference = itemCollectionReference(instance);
    final snapshot = collectionReference.where('owner', isEqualTo: accountDocumentReference(instance, uid)).snapshots();
    final items = snapshot.map((event) => event.docs.toList());
    return items;
  }

  static Future<List<Item>> searchItems(FirebaseFirestore instance, String query) async {
    final _query = itemCollectionReference(instance).where('name', isGreaterThanOrEqualTo: query);
    final snapshot = await _query.get();
    final List<Item> items = snapshot.docs.map((qds) => qds.data()).toList();
    return items;
  }

  static Future<Item?> getItem(FirebaseFirestore instance, String itemId) async {
    final query = itemDocumentReference(instance, itemId);
    final snapshot = await query.get();
    return snapshot.data();
  }
}