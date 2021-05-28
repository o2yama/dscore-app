import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';

class EditPasswordModel extends ChangeNotifier {
  final UserRepository userRepository;
  EditPasswordModel({required this.userRepository});

  CurrentUser? get currentUser => UserRepository.currentUser;
  bool isLoading = false;

  String email = '';
  String prevPassword = '';
  String conFirmingPassword = '';

  void onEmailFieldChanged(String text) {
    this.email = text;
    notifyListeners();
  }
}
