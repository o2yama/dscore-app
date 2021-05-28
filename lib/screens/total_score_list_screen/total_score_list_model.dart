import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/domain/score.dart';
import 'package:dscore_app/domain/score_with_cv.dart';
import 'package:dscore_app/domain/vt_score.dart';
import 'package:dscore_app/repository/score_repository.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';

class TotalScoreListModel extends ChangeNotifier {
  TotalScoreListModel({required this.scoreRepository});
  ScoreRepository scoreRepository;

  CurrentUser? get currentUser => UserRepository.currentUser;
  bool isLoading = false;
  bool isDoneGetScore = false;

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
    isDoneGetScore = true;
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
}
