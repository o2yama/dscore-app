import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dscore_app/data/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static CurrentUser? currentUser;

  Future<bool> signIn() async {
    try {
      await _auth.signInAnonymously();
      return true;
    } catch (e) {
      throw '通信環境の良いところでお試しください。';
    }
  }

  Future<void> signInFireStore() async {
    final user = _auth.currentUser;
    if (user != null) {
      _db.collection('users').doc().set({
        'id': user.uid,
      });
    } else {
      throw 'サインイン失敗';
    }
  }

  Future<void> getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final query =
          await _db.collection('users').where('id', isEqualTo: user.uid).get();
      currentUser = query.docs.map((doc) => CurrentUser(doc)).toList()[0];
    } else {
      throw 'データの取得に失敗しました。';
    }
  }
}
