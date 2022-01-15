import 'package:app_review/app_review.dart';
import 'package:dscore_app/data/vt/vt.dart';
import 'package:dscore_app/domain/performance.dart';
import 'package:dscore_app/domain/performance_with_cv.dart';
import 'package:dscore_app/domain/vt_tech.dart';
import 'package:dscore_app/repository/performance_repository.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final homeModelProvider = ChangeNotifierProvider((ref) => HomeModel()..init());

class HomeModel extends ChangeNotifier {
  late final UserRepository userRepository;
  late final PerformanceRepository performanceRepository;

  bool isFetched = false;
  NotificationSettings? settings;

  PerformanceWithCV? favoriteFx;
  Performance? favoritePh;
  Performance? favoriteSr;
  VTTech? vt;
  Performance? favoritePb;
  PerformanceWithCV? favoriteHb;

  num favoriteFxScore = 0.0;
  num favoritePhScore = 0.0;
  num favoriteSrScore = 0.0;
  num favoritePbScore = 0.0;
  num favoriteHbScore = 0.0;
  num totalScore = 0.0;

  init() {
    userRepository = UserRepository();
    performanceRepository = PerformanceRepository();
  }

  Future<void> getUserData() async {
    await userRepository.getCurrentUserData();
  }

  Future<void> getFavoritePerformances() async {
    favoriteFx = await performanceRepository.getStarFxPerformance();
    favoriteFx != null
        ? favoriteFxScore = favoriteFx!.total
        : favoriteFxScore = 0.0;

    favoritePh = await performanceRepository.getStarPhPerformance();
    favoritePh != null
        ? favoritePhScore = favoritePh!.total
        : favoritePhScore = 0.0;

    favoriteSr = await performanceRepository.getStarSrPerformance();
    favoriteSr != null
        ? favoriteSrScore = favoriteSr!.total
        : favoriteSrScore = 0.0;

    vt = await performanceRepository.getVTPerformance();

    favoritePb = await performanceRepository.getStarPbPerformance();
    favoritePb != null
        ? favoritePbScore = favoritePb!.total
        : favoritePbScore = 0.0;

    favoriteHb = await performanceRepository.getStarHbPerformance();
    favoriteHb != null
        ? favoriteHbScore = favoriteHb!.total
        : favoriteHbScore = 0.0;

    setTotalScore();
    isFetched = true;
    notifyListeners();
  }

  void setTotalScore() {
    final totalScoreTimes10 = favoriteFxScore * 10 +
        favoritePhScore * 10 +
        favoriteSrScore * 10 +
        (vt == null ? 0 : vtTechs[vt!.techName]!) * 10 +
        favoritePbScore * 10 +
        favoriteHbScore * 10;
    totalScore = totalScoreTimes10 / 10;

    notifyListeners();
  }

  Future<bool> getIsAppReviewDialogShowed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAppReviewDialogShowed') ?? false;
  }

  Future<void> setAppReviewDialogShowed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAppReviewDialogShowed', true);
  }

  //ユーザーにアプリを評価してもらうためのダイアログ
  Future<void> showAppReviewDialog() async {
    await AppReview.requestReview;
    notifyListeners();
  }

  //プッシュ通知の許可
  Future<void> requestNotificationPermission() async {
    final settings = await userRepository.requestNotificationPermission();
    this.settings = settings;
    notifyListeners();
  }
}
