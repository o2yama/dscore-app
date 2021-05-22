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

  Future<void> signInWithEmailAndPassword() async {
    isLoading = true;
    notifyListeners();

    try {
      await userRepository.signInWithEmailAndPassWord(email, password);
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  void onEmailEdited(String text) {
    email = text;
    notifyListeners();
  }

  void onPasswordEdited(String text) {
    password = text;
    notifyListeners();
  }
}
