import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpModelProvider = ChangeNotifierProvider(
  (ref) => SignUpModel()..init(),
);

class SignUpModel extends ChangeNotifier {
  late final UserRepository userRepository;

  String email = '';
  String password = '';

  init() {
    userRepository = UserRepository();
  }

  void onEmailEdited(String text) {
    email = text;
    notifyListeners();
  }

  void onPasswordEdited(String text) {
    password = text;
    notifyListeners();
  }

  Future<void> signUpWithEmailAndPassword() async {
    try {
      await userRepository.signUpWithEmailAndPassWord(email, password);
      await userRepository.getCurrentUserData();
    } on Exception {
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    await userRepository.sendEmailVerification();
  }
}
