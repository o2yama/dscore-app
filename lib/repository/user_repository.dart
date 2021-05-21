import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dscore_app/domain/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static AuthenticatedUser? authenticatedUser;
  static User? anonymousUser;

  Future<void> signInAnonymously() async {
    anonymousUser = (await _auth.signInAnonymously()).user;
    print(_auth.currentUser);
    if (anonymousUser == null) {
      // _db.collection('users').doc(user.uid).set({
      //   'id': user.uid,
      // });
      // final query =
      //     await _db.collection('users').where('id', isEqualTo: user.uid).get();
      // currentUser = query.docs.map((doc) => CurrentUser(doc)).toList()[0];
      throw 'サインイン失敗';
    }
  }

  Future<void> signInWithEmailAndPassWord(String email, String password) async {
    if (anonymousUser != null) {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    }
  }

  Future<void> getAuthenticatedUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final query =
          await _db.collection('users').where('id', isEqualTo: user.uid).get();
      authenticatedUser =
          query.docs.map((doc) => AuthenticatedUser(doc)).toList()[0];
    } else {
      return null;
    }
  }
}
