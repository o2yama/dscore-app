import 'package:dscore_app/data/fx.dart';
import 'package:dscore_app/domain/score.dart';
import 'package:dscore_app/domain/vt_score.dart';
import 'package:dscore_app/repository/score_repository.dart';
import 'package:flutter/material.dart';

class ScoreModel extends ChangeNotifier {
  ScoreModel({required this.scoreRepository});

  final ScoreRepository scoreRepository;
  bool isFavorite = false;
  List<Score>? fxScoreList;
  List<Score>? phScoreList;
  List<Score>? srScoreList;
  List<VTScore>? vtScoreList;
  List<Score>? pbScoreList;
  List<Score>? hbScoreList;

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

  Future<void> getSRScores() async {
    isLoading = true;
    notifyListeners();

    srScoreList = await scoreRepository.getSRScores();

    isLoading = false;
    notifyListeners();
  }

  Future<void> getVTScores() async {
    isLoading = true;
    notifyListeners();

    vtScoreList = await scoreRepository.getVTScores();

    isLoading = false;
    notifyListeners();
  }

  Future<void> getPBScores() async {
    isLoading = true;
    notifyListeners();

    pbScoreList = await scoreRepository.getPBScores();

    isLoading = false;
    notifyListeners();
  }

  Future<void> getHBScores() async {
    isLoading = true;
    notifyListeners();

    hbScoreList = await scoreRepository.getHBScores();

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

  ///ScoreEditScreen関連
  List<String> decidedTechList = [];

  ///SearchScreen関連
  List<String> searchResult = [];

  //床の技検索
  void searchFXTechs(String text) {
    if (text.isEmpty) {
      searchResult.clear();
    }
    notifyListeners();
    //検索
    final List<String> items =
        fxGroup.keys.where((techName) => techName.contains(text)).toList();
    for (int i = 0; i < items.length; i++) {
      searchResult.add(items[i]);
    }
    notifyListeners();
  }

  void search(BuildContext context, String text, String event) {
    if (event == '床') {
      searchFXTechs(text);
    }
    notifyListeners();
  }
}