import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';

class LoginModel extends ChangeNotifier {
  final UserRepository userRepository;
  LoginModel({required this.userRepository});

  CurrentUser? get currentUser => UserRepository.currentUser;
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

  Future<void> logIn(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      await userRepository.logInWithEmailAndPassword(email, password);
      await userRepository.getCurrentUserData();
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
      throw e;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    userRepository.signOut();
  }
}
