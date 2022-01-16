import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginModelProvider = ChangeNotifierProvider(
  (ref) => LoginModel()..init(),
);

class LoginModel extends ChangeNotifier {
  late final UserRepository userRepository;

  init() {
    userRepository = UserRepository();
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
