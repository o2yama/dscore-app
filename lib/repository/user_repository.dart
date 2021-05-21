import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dscore_app/domain/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static CurrentUser? currentUser;

  Future<void> signInWithEmailAndPassWord(String email, String password) async {
    final User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      final bool isUserExistInDB = await getIsExistUser(user);
      if (!isUserExistInDB) {
        await _db.collection("users").doc(user.uid).set({
          "email": user.email,
          "id": user.uid,
        });
        final firebaseUser = await _db
            .collection('users')
            .where('id', isEqualTo: user.uid)
            .get();
        currentUser =
            firebaseUser.docs.map((doc) => CurrentUser(doc)).toList()[0];
      } else {
        //同じidの人がすでにいた時
        throw '同じユーザーがすでに登録されています。';
      }
    } else {
      //userがnullだった時
      throw '通信環境の良いところで再度お試しください。';
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

  Future<bool> getIsExistSameEmailUser(User user) async {
    final query = await _db
        .collection("users")
        .where("email", isEqualTo: currentUser!.email)
        .get();
    if (query.size == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final query =
          await _db.collection('users').where('id', isEqualTo: user.uid).get();
      if (query.size == 1) {
        currentUser = query.docs.map((doc) => CurrentUser(doc)).toList()[0];
      }
    } else {
      return;
    }
  }
}
