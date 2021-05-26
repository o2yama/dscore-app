import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dscore_app/domain/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static CurrentUser? currentUser;

  Future<void> signUpWithEmailAndPassWord(String email, String password) async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        await _db.collection("users").doc(user.uid).set({
          "email": user.email,
          "id": user.uid,
        });
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> logInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('authによるエラー');
      throw e;
    }
  }

  Future<bool> getIsExistUser(User user) async {
    final query =
        await _db.collection("users").where("id", isEqualTo: user.uid).get();
    if (query.docs.length > 0) {
      return true;
    }
    return false;
  }

  Future<void> getCurrentUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final query = await _db
            .collection('users')
            .where('id', isEqualTo: user.uid)
            .get();
        if (query.size == 1) {
          currentUser = query.docs.map((doc) => CurrentUser(doc)).toList()[0];
        }
      } else {
        print('ユーザーデータ取得のエラー');
        return;
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
  }
}
