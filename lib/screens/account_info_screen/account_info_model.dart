import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountInfoModelProvider = ChangeNotifierProvider(
  (ref) => AccountInfoModel()..init(),
);

class AccountInfoModel extends ChangeNotifier {
  late final UserRepository userRepository;

  get authUser => userRepository.authUser;

  void init() {
    userRepository = UserRepository();
  }

  Future<void> reAuthAndDeleteAccount(String password) async {
    try {
      final isAuthorized = await userRepository.reAuthenticate(password);

      if (isAuthorized) {
        await userRepository.deleteAccount();
      }
    } on Exception {
      rethrow;
    }
  }
}
