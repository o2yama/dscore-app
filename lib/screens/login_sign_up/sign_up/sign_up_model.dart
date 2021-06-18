import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';

class SignUpModel extends ChangeNotifier {
  SignUpModel({required this.userRepository});
  final UserRepository userRepository;

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

  Future<void> signUpWithEmailAndPassword() async {
    isLoading = true;
    notifyListeners();

    try {
      await userRepository.signUpWithEmailAndPassWord(email, password);
      await userRepository.getCurrentUserData();
    } on Exception catch (e) {
      final Error error = ArgumentError(e);
      isLoading = false;
      notifyListeners();
      throw error;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> sendEmailVerification() async {
    await userRepository.sendEmailVerification();
  }
}
