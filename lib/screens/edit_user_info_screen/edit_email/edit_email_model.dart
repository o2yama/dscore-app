import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:dscore_app/screens/edit_user_info_screen/edit_email/edit_email_screen.dart';
import 'package:flutter/cupertino.dart';

class EditEmailModel extends ChangeNotifier {
  EditEmailModel({required this.userRepository});
  final UserRepository userRepository;

  CurrentUser? get currentUser => UserRepository.currentUser;
  bool isLoading = false;

  String newEmail = '';
  String confirmationNewEmail = '';
  String password = '';

  void onNewEmailFieldChanged(String text) {
    newEmail = text;
    notifyListeners();
  }

  void onConfirmationNewEmailFieldChanged(String text) {
    confirmationNewEmail = text;
    notifyListeners();
  }

  void onPasswordFieldChanged(String text) {
    password = text;
    notifyListeners();
  }

  Future<String> updateEmail() async {
    isLoading = true;
    notifyListeners();

    if (newEmail == confirmationNewEmail) {
      try {
        final isAuthenticated = await userRepository.reAuthenticate(password);
        if (isAuthenticated) {
          await userRepository.updateEmail(newEmail);
          await userRepository.sendEmailVerification();
          isLoading = false;
          notifyListeners();
          return 'done';
        } else {
          isLoading = false;
          notifyListeners();
          return 'fail auth';
        }
      } on Exception catch (e) {
        isLoading = false;
        notifyListeners();
        final Error error = ArgumentError(e);
        throw error;
      }
    } else {
      isLoading = false;
      notifyListeners();
      return 'different confirmationEmail';
    }
  }

  Future<void> updateEmailInDB() async {
    await userRepository.getCurrentUserData();
    await userRepository.updateEmailInDB();
    notifyListeners();
  }

  void resetController() {
    newEmailController.text = '';
    confirmationNewEmailController.text = '';
    passwordController.text = '';
    notifyListeners();
  }
}
