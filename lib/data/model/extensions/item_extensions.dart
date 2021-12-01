import 'package:berikan/data/model/account.dart';
import 'package:berikan/data/model/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore;

extension ItemService on Item
{
  /// Gets the owner of this item
  ///
  /// I cannot simply put this inside [Item.fromFirestore]
  /// or [Item.toFirestore] because this function should use
  /// async-await method while [FirebaseFirestore.withConverter]
  /// does not support it.
  Future<Account?> get owner async {
    final accountDocRef = accountDocumentReference(
        FirebaseFirestore.instance, ownerId
    );
    final ownerSnapshot = await accountDocRef.get();
    return ownerSnapshot.data();
  }
}