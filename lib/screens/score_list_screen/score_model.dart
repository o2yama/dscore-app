import 'package:dscore_app/data/fx.dart';
import 'package:dscore_app/data/hb.dart';
import 'package:dscore_app/data/pb.dart';
import 'package:dscore_app/data/ph.dart';
import 'package:dscore_app/data/sr.dart';
import 'package:dscore_app/domain/score.dart';
import 'package:dscore_app/domain/vt_score.dart';
import 'package:dscore_app/repository/score_repository.dart';
import 'package:flutter/material.dart';

class ScoreModel extends ChangeNotifier {
  ScoreModel({required this.scoreRepository});

  final ScoreRepository scoreRepository;
  // bool isFavorite = false;
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

  void onFavoriteButtonTapped(bool isFavorite) {
    if (isFavorite) {
      isFavorite = false;
    }
    notifyListeners();
  }

  ///ScoreEditScreen関連
  List<String> decidedTechList = [
    "前方屈伸ダブルハーフ",
    "前方伸身三回ひねり",
    "後方ダブルハーフ",
    "アルバリーニョ"
  ];
  num totalScore = 0.0;
  num difficultyPoint = 0.0;
  num egr = 0.0;
  num cv = 0.0;

  ///SearchScreen関連
  List<String> searchResult = [];
  Map difficulty = {};
  Map group = {};

  //どの種目かの判断を各ページで行う
  void selectEvent(String event) {
    if (event == '床') {
      difficulty = fxDifficulty;
      group = fxGroup;
    }
    if (event == 'あん馬') {
      difficulty = phDifficulty;
      group = phGroup;
    }
    if (event == '吊り輪') {
      difficulty = srDifficulty;
      group = srGroup;
    }
    if (event == '平行棒') {
      difficulty = pbDifficulty;
      group = pbGroup;
    }
    if (event == '鉄棒') {
      difficulty = hbDifficulty;
      group = hbGroup;
    }
    notifyListeners();
  }

  //床の技検索
  void search(String text, String event) {
    if (text.isEmpty) {
      searchResult = [];
    } else {
      searchResult.clear(); //addしているため毎回クリアする必要がある
      //検索
      if (event == '床') {
        final List<String> items = fxGroup.keys
            .where((techName) => techName.toLowerCase().contains(text))
            .toList();
        items.forEach((element) {
          searchResult.add(element);
        });
      }
      if (event == 'あん馬') {
        final List<String> items = phGroup.keys
            .where((techName) => techName.toLowerCase().contains(text))
            .toList();
        items.forEach((element) {
          searchResult.add(element);
        });
      }
      if (event == '吊り輪') {
        final List<String> items = srGroup.keys
            .where((techName) => techName.toLowerCase().contains(text))
            .toList();
        items.forEach((element) {
          searchResult.add(element);
        });
      }
      if (event == '平行棒') {
        final List<String> items = pbGroup.keys
            .where((techName) => techName.toLowerCase().contains(text))
            .toList();
        items.forEach((element) {
          searchResult.add(element);
        });
      }
      if (event == '鉄棒') {
        final List<String> items = hbGroup.keys
            .where((techName) => techName.toLowerCase().contains(text))
            .toList();
        items.forEach((element) {
          searchResult.add(element);
        });
      }
    }
    notifyListeners();
  }

  Future<void> onTechSelected() async {}
}
