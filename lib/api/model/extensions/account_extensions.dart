import 'package:cloud_firestore/cloud_firestore.dart';

import '../../account_service.dart';
import '../account.dart';
import '../item.dart';

extension AccountExtension on Account
{
  /// Adds [item] from this account.
  Future<DocumentReference<Item>> addItem(Item item) async {
    // create a copy of item
    // a bit sus
    final _item = Item.create(
        AccountService.getCurrentUser()!.uid,
        imagesUrl: item.imagesUrl,
        name: item.name,
        addedSince: item.addedSince,
        description: item.description
    );

    final itemColRef = itemCollectionReference(FirebaseFirestore.instance);
    return await itemColRef.add(_item);
  }
}