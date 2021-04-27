import 'package:dscore_app/data/score.dart';
import 'package:dscore_app/repository/score_repository.dart';
import 'package:flutter/material.dart';

class EventScreenModel extends ChangeNotifier {
  EventScreenModel({required this.scoreRepository});
  final ScoreRepository scoreRepository;
  bool isFavorite = false;
  String dropDownValue = 'one';
  List<Score> fxScoreList = [];

  Future<void> getFXScores() async {
    fxScoreList = await scoreRepository.getFxScores();
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
