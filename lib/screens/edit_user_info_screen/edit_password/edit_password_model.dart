import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editPasswordModelProvider = ChangeNotifierProvider(
  (ref) => EditPasswordModel()..init(),
);

class EditPasswordModel extends ChangeNotifier {
  late final UserRepository userRepository;

  String email = '';
  String prevPassword = '';
  String conFirmingPassword = '';

  init() {
    userRepository = UserRepository();
  }

  void onEmailFieldChanged(String text) {
    email = text;
    notifyListeners();
  }
}
