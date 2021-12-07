import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:berikan/data/model/account.dart';
import 'package:flutter_test/flutter_test.dart';

void main()
{
  final firestoreInstance = FakeFirebaseFirestore();
  final auth = MockFirebaseAuth();
  test('should return same account', (){
    final mockUser1 = MockUser(
        isEmailVerified: true,
        uid: 'loool',
        email: 'lol@lol.com'
    );
  });


}