import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/current_user.dart';

final introModelProvider = ChangeNotifierProvider((ref) => IntroModel());

class IntroModel extends ChangeNotifier {
  final userRepository = UserRepository();

  bool isIntroWatched = false;
  CurrentUser? get currentUser => UserRepository.currentUser;

  Future<void> checkIsIntroWatched() async {
    final prefs = await SharedPreferences.getInstance();
    isIntroWatched = prefs.getBool('intro') ?? false;
  }

  Future<void> finishIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro', true);
    isIntroWatched = prefs.getBool('intro') ?? false;
  }

  Future<void> getCurrentUserData() async {
    try {
      await userRepository.getCurrentUserData();
    } on Exception {
      rethrow;
    }
  }
}
