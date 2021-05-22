import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';

class SignUpModel extends ChangeNotifier {
  final UserRepository userRepository;
  SignUpModel({required this.userRepository});

  CurrentUser? get authenticatedUser => UserRepository.currentUser;
  bool isLoading = false;
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

  Future<void> signInWithEmailAndPassword() async {
    isLoading = true;
    notifyListeners();

    try {
      await userRepository.signUpWithEmailAndPassWord(email, password);
      await userRepository.getCurrentUserData();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw e;
    }

    isLoading = false;
    notifyListeners();
  }
}
