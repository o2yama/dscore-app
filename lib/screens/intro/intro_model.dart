import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/current_user.dart';

class IntroModel extends ChangeNotifier {
  IntroModel({required this.userRepository});
  final UserRepository userRepository;
  bool isIntroWatched = false;
  int currentIndex = 0;
  bool isLoading = false;

  CurrentUser? get currentUser => UserRepository.currentUser;

  Future<void> signIn() async {
    isLoading = true;
    notifyListeners();

    try {
      await userRepository.signIn();
      await userRepository.signInFireStore();
      await userRepository.getUserData();
    } catch (e) {
      throw e;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getUserData() async {
    await userRepository.getUserData();
  }

  Future<void> finishIntro() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('intro', true);
  }

  Future<void> checkIsIntroWatched() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.isIntroWatched = prefs.getBool('intro') ?? false;
    notifyListeners();
  }

  void toNext() {
    currentIndex++;
    notifyListeners();
  }
}
