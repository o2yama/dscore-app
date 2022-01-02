import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginModelProvider = ChangeNotifierProvider((ref) => LoginModel());

class LoginModel extends ChangeNotifier {
  final userRepository = UserRepository();

  CurrentUser? get currentUser => UserRepository.currentUser;
  String email = '';
  String password = '';

  void onEmailEdited(String text) {
    email = text;
    notifyListeners();
  }

  void onPasswordEdited(String text) {
    password = text;
    notifyListeners();
  }

  Future<void> logIn(String email, String password) async {
    try {
      await userRepository.logInWithEmailAndPassword(email, password);
      await userRepository.getCurrentUserData();
    } on Exception {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await userRepository.signOut();
  }
}
