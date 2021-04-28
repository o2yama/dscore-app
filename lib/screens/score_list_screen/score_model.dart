import 'package:dscore_app/domain/score.dart';
import 'package:dscore_app/repository/score_repository.dart';
import 'package:flutter/material.dart';

class ScoreModel extends ChangeNotifier {
  ScoreModel({required this.scoreRepository});
  final ScoreRepository scoreRepository;
  bool isFavorite = false;
  String dropDownValue = 'one';
  List<Score>? fxScoreList;
  List<Score>? phScoreList;

  bool isLoading = false;

  Future<void> getFXScores() async {
    isLoading = true;
    notifyListeners();

    fxScoreList = await scoreRepository.getFXScores();

    isLoading = false;
    notifyListeners();
  }

  Future<void> getPHScores() async {
    isLoading = true;
    notifyListeners();

    phScoreList = await scoreRepository.getPHScores();

    isLoading = false;
    notifyListeners();
  }

  Future<bool> getIsFavorite() async {
    return false;
  }

  void onFavoriteButtonTapped() {
    if (isFavorite) {
      isFavorite = false;
    } else {
      isFavorite = true;
    }
    notifyListeners();
  }
}
