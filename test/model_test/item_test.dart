import 'package:berikan/data/model/account.dart';
import 'package:berikan/data/model/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:flutter_test/flutter_test.dart';

void main() async
{
  final instance = FakeFirebaseFirestore();
  group('Test item model class with converter fromFirestore', () {
    final accountCreated = DateTime(2021, DateTime.january, 1);
    final addedSinceDate = DateTime(2021, DateTime.february, 3);
    Item? expectedItem;
    final expectedAccount = Account(firstName: 'First', lastName: 'Last', avatarUrl: 'url1', joinedSince: accountCreated, phoneNumber: '0210');
    late DocumentReference docref;
    setUp(() async {
      docref = await instance.collection('account').add({
        'avatar_url'  : 'url1',
        'first_name'  : 'First',
        'last_name'   : 'Last',
        'joined_since': Timestamp.fromDate(accountCreated),
        'phone_number': '0210',
      });

      expectedItem = Item(
          imagesUrl: ['url1', 'url2', 'url3'],
          name: 'Buku tulis',
          addedSince: addedSinceDate,
          location: const GeoPoint(1, 1),
          description: 'Buku yang masih dapat dibaca dan ditulis',
          ownerId: docref.id,
      );

      await instance.collection('item').add({
        'added_since': Timestamp.fromDate(addedSinceDate),
        'description': 'Buku yang masih dapat dibaca dan ditulis',
        'images'     : ['url1', 'url2', 'url3'],
        'location'   : const GeoPoint(1, 1),
        'name'       : 'Buku tulis',
        'owner'      : docref,
      });

    });

    test('item should be as expected', () async {
      final itemRef = itemCollectionReference(instance);
      final itemDocs = await itemRef.get();
      final items = itemDocs.docs;
      final item = items.first.data();

      if (expectedItem != null) {
        expect (await item, expectedItem);
      }
    });

    test('Item#account should not be null when downloading', () async {
      final itemRef = itemCollectionReference(instance);
      final itemDocs = await itemRef.get();
      final items = itemDocs.docs;
      final item = items.first.data();

      expect(await getOwner(instance, item), isNotNull, reason: "Owner item must not be null!");
      expect(await getOwner(instance, item), expectedAccount);
    });
  });

  group('Test item model class with converter toFirestore', () {
    final accountCreated = DateTime(2021, DateTime.january, 1);
    late DocumentReference docref;
    setUp(() async {
      docref = await instance.collection('account').add({
        'avatar_url'  : 'url1',
        'first_name'  : 'First',
        'last_name'   : 'Last',
        'joined_since': Timestamp.fromDate(accountCreated),
        'phone_number': '0210',
      });
    });
    test('should produce the same result when download and upload', () async {
      const itemCollectionName = 'item';

      // create a stub method for toFirestore
      Map<String, Object?> toFirestore(Item model, SetOptions? options) {
        return {
          'added_since'   :   Timestamp.fromDate(model.addedSince),
          'description'   :   model.description,
          'images'        :   model.imagesUrl,
          'location'      :   model.location,
          'name'          :   model.name,
          'owner'         :   instance.collection(itemCollectionName).doc(model.ownerId),
        };
      }

      // get collection reference
      final itemColRef = instance.collection(itemCollectionName).withConverter(
          fromFirestore: Item.fromFirestore, toFirestore: toFirestore
      );

      final item = Item(
          imagesUrl: ['h1'],
          name: 'Item1',
          addedSince: DateTime(2021,1,1),
          location: GeoPoint(1, 1),
          description: 'ini adalah item',
          ownerId: docref.id,
      );

      final account = Account(
          firstName: 'First',
          lastName: 'Last',
          avatarUrl: 'url1',
          joinedSince: accountCreated,
          phoneNumber: '0210'
      );

      // upload to "firestore"
      final docRef = await itemColRef.add(item);

      // get the document reference
      final itemDocRef = instance.collection(itemCollectionName).doc(docRef.id)
          .withConverter(fromFirestore: Item.fromFirestore, toFirestore: toFirestore);
      final itemSnapshot = await  itemDocRef.get();
      final item1 = itemSnapshot.data();

      // get account
      final account1 = getOwner(instance, item);

      expect(item1, isNotNull, reason: "item should not be null");
      expect(item1, item);
      expect(await account1, account);
    });
  });
}

/// Stub method from [ItemService.owner]
Future<Account?> getOwner(FirebaseFirestore instance, Item item) async {
  final accountDocRef = accountDocumentReference(instance, item.ownerId);
  final ownerSnapshot = await accountDocRef.get();
  return ownerSnapshot.data();
}