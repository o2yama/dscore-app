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

  Future<void> getFavoriteScores(String event) async {
    if (event == '床') {
      await getFavoriteFXScores();
    }
    if (event == 'あん馬') {
      await getFavoritePHScores();
    }
    if (event == '吊り輪') {
      await getFavoriteSRScores();
    }
    if (event == '平行棒') {
      await getFavoritePBScores();
    }
    if (event == '鉄棒') {
      await getFavoriteHBScores();
    }
  }

  Future<void> getFavoriteFXScores() async {
    isLoading = true;
    notifyListeners();

    favoriteFx = await scoreRepository.getFavoriteFXScore();
    if (favoriteFx != null) favoriteFxScore = favoriteFx!.total;
    vt = await scoreRepository.getVTScore();
    if (vt != null) vtScore = vt!.score;

    isLoading = false;
    notifyListeners();
  }

  Future<void> getFavoritePHScores() async {
    isLoading = true;
    notifyListeners();

    favoritePh = await scoreRepository.getFavoritePHScore();
    if (favoritePh != null) favoritePhScore = favoritePh!.total;
    vt = await scoreRepository.getVTScore();
    if (vt != null) vtScore = vt!.score;

    isLoading = false;
    notifyListeners();
  }

  Future<void> getFavoriteSRScores() async {
    isLoading = true;
    notifyListeners();

    favoriteSr = await scoreRepository.getFavoriteSRScore();
    if (favoriteSr != null) favoriteSrScore = favoriteSr!.total;
    vt = await scoreRepository.getVTScore();
    if (vt != null) vtScore = vt!.score;

    isLoading = false;
    notifyListeners();
  }

  Future<void> getFavoritePBScores() async {
    isLoading = true;
    notifyListeners();

    favoritePb = await scoreRepository.getFavoritePBScore();
    if (favoritePb != null) favoritePbScore = favoritePb!.total;
    vt = await scoreRepository.getVTScore();
    if (vt != null) vtScore = vt!.score;

    isLoading = false;
    notifyListeners();
  }

  Future<void> getFavoriteHBScores() async {
    isLoading = true;
    notifyListeners();

    favoriteHb = await scoreRepository.getFavoriteHBScore();
    if (favoriteHb != null) favoriteHbScore = favoriteHb!.total;
    vt = await scoreRepository.getVTScore();
    if (vt != null) vtScore = vt!.score;

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
