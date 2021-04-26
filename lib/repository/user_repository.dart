import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dscore_app/data/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static CurrentUser? currentUser;

  Future<void> signIn() async {
    final user = (await _auth.signInAnonymously()).user;
    if (user != null) {
      _db.collection('users').doc(user.uid).set({
        'id': user.uid,
      });
      final query =
          await _db.collection('users').where('id', isEqualTo: user.uid).get();
      currentUser = query.docs.map((doc) => CurrentUser(doc)).toList()[0];
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
