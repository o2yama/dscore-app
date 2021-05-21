import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';

class LoginModel extends ChangeNotifier {
  final UserRepository userRepository;
  LoginModel({required this.userRepository});

  CurrentUser? get authenticatedUser => UserRepository.currentUser;
}
