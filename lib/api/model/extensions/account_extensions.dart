import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../account_service.dart';
import '../account.dart';
import '../item.dart';

extension AccountExtension on Account
{
  /// The list of user's liked items
  Future<List<Item>> get likedItems async {
    final accountDocRef = FirebaseFirestore.instance
        .collection('account').doc(AccountService.getCurrentUser()!.uid);
    final snapshot = await accountDocRef.get();

    final likedItemsDocumentReference = snapshot.data()!['liked_item'] as List<DocumentReference>;

    List<Item> _likedItems = [];

    for (DocumentReference ref in likedItemsDocumentReference) {
      final likedItemDocRef = itemDocumentReference(FirebaseFirestore.instance, ref.id);
      final snapshot = await likedItemDocRef.get();
      if (snapshot.data() != null) {
        _likedItems.add(snapshot.data() as Item);
      }
    }

    return _likedItems;
  }

  /// Gets the location until second-order administrative division
  /// (Kabupaten/Kota).
  ///
  /// e.g. Cilincing, Kota Jakarta Utara
  Future<String> get location2 async {
    final accountDocRef = FirebaseFirestore.instance
        .collection('account').doc(AccountService.getCurrentUser()!.uid);
    final snapshot = await accountDocRef.get();

    final location = snapshot.data()!['location'] as List<String>;

    return '${location[3]}, ${location[2]}';
  }


  Future<dynamic> getKecamatan(String ownerId) async {
    final accountDocRef = FirebaseFirestore.instance
        .collection('account').doc(ownerId);
    final snapshot = await accountDocRef.get();

    final location = snapshot.data()!['location'] as List<String>;

    return location[3];
  }

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

  /// Adds [item] that is liked to this account.
  ///
  /// Simply put, this function works by getting all liked items,
  /// get the id of the item (which is the id of the document),
  /// and put that as a [DocumentReference] from [Item] collection.
  Future<void> likeItem(Item item) async {
    // get a document reference for an account
    // I cannot use [accountDocumentReference] since it relies on [Acocunt] class.
    final accountDocRef = FirebaseFirestore.instance
        .collection('account').doc(AccountService.getCurrentUser()!.uid);

    // get liked items for this account
    final _likedItems = await likedItems;

    // create new DocumentReference of Item
    List<DocumentReference<Item>> likedItemsDocumentReference = <DocumentReference<Item>> [];

    for (Item item in _likedItems) {
      // Again, i am a bit skeptical.
      // Making sure there is no duplicate api.
      if (await isItemLiked(item)) continue;
      // If the item id is empty, create a new documentId
      // should I???
      if (item.id.isEmpty) {
        final docRef = await itemCollectionReference(FirebaseFirestore.instance).add(item);
        likedItemsDocumentReference.add(docRef);
      } else {
        final docRef = itemDocumentReference(FirebaseFirestore.instance, item.id);
        likedItemsDocumentReference.add(docRef);
      }
    }
    accountDocRef.set({'liked_item': likedItemsDocumentReference});
  }

  /// Checks if this account likes [item].
  Future<bool> isItemLiked(Item item) async {
    // get liked items for this account
    final _likedItems = await likedItems;

    return _likedItems.any((Item _item) => _item.id == item.id);
  }
}