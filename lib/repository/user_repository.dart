import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dscore_app/domain/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserRepository {
  factory UserRepository() => _cache;
  UserRepository._internal();
  static final UserRepository _cache = UserRepository._internal();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _firebaseMessaging = FirebaseMessaging.instance;

  User? get authUser => _auth.currentUser;
  AppUser? appUser;

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        await _db.collection('users').doc(user.uid).set(<String, dynamic>{
          'email': user.email,
          'id': user.uid,
        });
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_convertErrorMessage(e.code));
    } on Exception {
      throw AuthException('不明なエラーです');
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
      }
    } on UnimplementedError {
      rethrow;
    }
  }

  Future<void> logInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_convertErrorMessage(e.code));
    } on Exception {
      throw AuthException('不明なエラーです');
    }
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
          appUser = query.docs.map((doc) => AppUser(doc)).toList()[0];
        }
      } else {
        return;
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_convertErrorMessage(e.code));
    } on Exception {
      throw AuthException('不明なエラーです');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    appUser = null;
  }

  Future<bool> reAuthenticate(String password) async {
    try {
      final user = _auth.currentUser;
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_convertErrorMessage(e.code));
    } on Exception {
      throw AuthException('不明なエラーです');
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      await authUser!.updateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_convertErrorMessage(e.code));
    } on Exception {
      throw AuthException('不明なエラーです');
    }
  }

  Future<void> updateEmailInDB() async {
    try {
      await _db.collection('user').doc(authUser!.uid).update(<String, dynamic>{
        'email': authUser!.email,
      });
    } on FirebaseAuthException catch (e) {
      throw AuthException(_convertErrorMessage(e.code));
    } on Exception {
      throw AuthException('不明なエラーです');
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _db.collection('users').doc(authUser!.uid).delete();
      await authUser!.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_convertErrorMessage(e.code));
    } on Exception {
      throw AuthException('不明なエラーです');
    }
  }

  Future<NotificationSettings> requestNotificationPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
    );
    return settings;
  }
}

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

String _convertErrorMessage(String errorMassage) {
  switch (errorMassage) {
    case 'weak-password':
      return '安全なパスワードではありません';
    case 'email-already-in-use':
      return 'メールアドレスがすでに使われています';
    case 'invalid-email':
      return 'メールアドレスを正しい形式で入力してください';
    case 'operation-not-allowed':
      return '登録が許可されていません';
    case 'wrong-password':
      return 'パスワードが間違っています';
    case 'user-not-found':
      return 'ユーザーが見つかりません';
    case 'user-disabled':
      return 'ユーザーが無効です';
    default:
      return '不明なエラーです';
  }
}
