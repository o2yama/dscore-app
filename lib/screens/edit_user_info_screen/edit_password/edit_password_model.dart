import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editPasswordModelProvider = ChangeNotifierProvider(
  (ref) => EditPasswordModel(),
);

class EditPasswordModel extends ChangeNotifier {
  final userRepository = UserRepository();

  CurrentUser? get currentUser => UserRepository.currentUser;

  String email = '';
  String prevPassword = '';
  String conFirmingPassword = '';

  void onEmailFieldChanged(String text) {
    email = text;
    notifyListeners();
  }
}
