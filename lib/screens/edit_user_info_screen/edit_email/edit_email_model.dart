import 'package:dscore_app/repository/user_repository.dart';
import 'package:dscore_app/screens/edit_user_info_screen/edit_email/edit_email_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editEmailModelProvider = ChangeNotifierProvider(
  (ref) => EditEmailModel()..init(),
);

class EditEmailModel extends ChangeNotifier {
  EditEmailModel();
  late final UserRepository userRepository;
  String newEmail = '';
  String confirmationNewEmail = '';
  String password = '';

  init() {
    userRepository = UserRepository();
  }

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
    notifyListeners();

    if (newEmail == confirmationNewEmail) {
      try {
        final isAuthenticated = await userRepository.reAuthenticate(password);
        if (isAuthenticated) {
          await userRepository.updateEmail(newEmail);
          await userRepository.sendEmailVerification();
          notifyListeners();
          return 'done';
        } else {
          notifyListeners();
          return 'fail auth';
        }
      } on Exception catch (e) {
        notifyListeners();
        final Error error = ArgumentError(e);
        throw error;
      }
    } else {
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
