import 'package:app_review/app_review.dart';
import 'package:dscore_app/data/vt.dart';
import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/domain/score.dart';
import 'package:dscore_app/domain/score_with_cv.dart';
import 'package:dscore_app/domain/vt_score.dart';
import 'package:dscore_app/repository/score_repository.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final homeModelProvider = ChangeNotifierProvider((ref) => HomeModel());

class HomeModel extends ChangeNotifier {
  final userRepository = UserRepository();
  final scoreRepository = ScoreRepository();

  CurrentUser? get currentUser => UserRepository.currentUser;
  bool isFetchedScore = false;
  bool isAppReviewDialogShowed = false;
  bool isFetchedToken = false;
  NotificationSettings? settings;

  ScoreWithCV? favoriteFx;
  Score? favoritePh;
  Score? favoriteSr;
  VTScore? vt;
  Score? favoritePb;
  ScoreWithCV? favoriteHb;

  num favoriteFxScore = 0.0;
  num favoritePhScore = 0.0;
  num favoriteSrScore = 0.0;
  num favoritePbScore = 0.0;
  num favoriteHbScore = 0.0;
  num totalScore = 0.0;

  Future<void> getFavoriteScores() async {
    if (currentUser != null) {
      favoriteFx = await scoreRepository.getFavoriteFXScore();
      favoriteFx != null
          ? favoriteFxScore = favoriteFx!.total
          : favoriteFxScore = 0.0;

      favoritePh = await scoreRepository.getFavoritePHScore();
      favoritePh != null
          ? favoritePhScore = favoritePh!.total
          : favoritePhScore = 0.0;

      favoriteSr = await scoreRepository.getFavoriteSRScore();
      favoriteSr != null
          ? favoriteSrScore = favoriteSr!.total
          : favoriteSrScore = 0.0;

      vt = await scoreRepository.getVTScore();

      favoritePb = await scoreRepository.getFavoritePBScore();
      favoritePb != null
          ? favoritePbScore = favoritePb!.total
          : favoritePbScore = 0.0;

      favoriteHb = await scoreRepository.getFavoriteHBScore();
      favoriteHb != null
          ? favoriteHbScore = favoriteHb!.total
          : favoriteHbScore = 0.0;
    }
    setTotalScore();
    isFetchedScore = true;
    notifyListeners();
  }

  void setTotalScore() {
    final totalScoreTimes10 = favoriteFxScore * 10 +
        favoritePhScore * 10 +
        favoriteSrScore * 10 +
        (vt == null ? 0 : vtTech[vt!.techName]!) * 10 +
        favoritePbScore * 10 +
        favoriteHbScore * 10;
    totalScore = totalScoreTimes10 / 10;
    notifyListeners();
  }

  Future<void> getIsAppReviewDialogShowed() async {
    final prefs = await SharedPreferences.getInstance();
    isAppReviewDialogShowed = prefs.getBool('isAppReviewDialogShowed') ?? false;
    notifyListeners();
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
