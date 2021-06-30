import 'package:app_review/app_review.dart';
import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/domain/score.dart';
import 'package:dscore_app/domain/score_with_cv.dart';
import 'package:dscore_app/domain/vt_score.dart';
import 'package:dscore_app/repository/score_repository.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TotalScoreListModel extends ChangeNotifier {
  TotalScoreListModel({
    required this.userRepository,
    required this.scoreRepository,
  });
  UserRepository userRepository;
  ScoreRepository scoreRepository;

  CurrentUser? get currentUser => UserRepository.currentUser;
  bool isLoading = true;
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
  num vtScore = 0.0;
  num favoritePbScore = 0.0;
  num favoriteHbScore = 0.0;
  num totalScore = 0.0;

  Future<void> getFavoriteScores() async {
    isLoading = true;
    notifyListeners();

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
      vt != null ? vtScore = vt!.score : vtScore = 0.0;

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
    print('getFavoriteScores');
    notifyListeners();
  }

  void changeLoaded() {
    isLoading = false;
    notifyListeners();
  }

  void setTotalScore() {
    totalScore = favoriteFxScore * 10 +
        favoritePhScore * 10 +
        favoriteSrScore * 10 +
        vtScore * 10 +
        favoritePbScore * 10 +
        favoriteHbScore * 10;
    totalScore /= 10;
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
    final status = await AppReview.requestReview;
    print('showAppReviewDialog: $status');
    notifyListeners();
  }

  //プッシュ通知の許可
  Future<void> requestNotificationPermission() async {
    final settings = await userRepository.requestNotificationPermission();
    this.settings = settings;
    print(settings.authorizationStatus);
    notifyListeners();
  }

  Future<void> getFCMToken() async {
    var isTokenExist = false;
    if (!isFetchedToken &&
        settings!.authorizationStatus == AuthorizationStatus.authorized) {
      final inComingToken = await userRepository.getFCMToken();
      print(inComingToken);
      if (inComingToken != null) {
        final tokens = await userRepository.getTokens(); //すでに登録済みのトークン取得
        if (tokens.isNotEmpty) {
          for (final token in tokens) {
            if (token == inComingToken) {
              isTokenExist = true;
            }
          }
        }
        if (!isTokenExist) {
          await userRepository.setToken(inComingToken);
        }
      }
    }
    isFetchedToken = true;
    notifyListeners();
  }
}
