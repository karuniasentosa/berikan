import 'package:berikan/data/model/account.dart';
import 'package:berikan/data/model/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore;

extension ItemService on Item
{
  Future<Account?> get owner async {
    final accountDocRef = accountDocumentReference(
        FirebaseFirestore.instance, ownerId
    );
    final ownerSnapshot = await accountDocRef.get();
    return ownerSnapshot.data();
  }
}