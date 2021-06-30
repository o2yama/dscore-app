import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/current_user.dart';

class IntroModel extends ChangeNotifier {
  IntroModel({required this.userRepository});
  final UserRepository userRepository;
  bool isIntroWatched = false;
  bool isLoading = false;
  bool isFetchedUserData = false;

  CurrentUser? get currentUser => UserRepository.currentUser;

  Future<void> checkIsIntroWatched() async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    isIntroWatched = prefs.getBool('intro') ?? false;
    print('checkIntroWatched: $isIntroWatched');
  }

  Future<void> finishIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro', true);
    isIntroWatched = prefs.getBool('intro') ?? false;
  }

  Future<void> getCurrentUserData() async {
    isLoading = true;
    notifyListeners();

    try {
      await userRepository.getCurrentUserData();
      print('getCurrentUser: $currentUser');
      isFetchedUserData = true;
    } on Exception catch (e) {
      print(e);
    }
  }

  void changeLoaded() {
    isLoading = false;
    notifyListeners();
  }
}
