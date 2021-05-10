import 'package:dscore_app/data/fx.dart';
import 'package:dscore_app/data/hb.dart';
import 'package:dscore_app/data/pb.dart';
import 'package:dscore_app/data/ph.dart';
import 'package:dscore_app/data/sr.dart';
import 'package:dscore_app/data/vt.dart';
import 'package:dscore_app/domain/score.dart';
import 'package:dscore_app/domain/score_with_cv.dart';
import 'package:dscore_app/domain/vt_score.dart';
import 'package:dscore_app/repository/score_repository.dart';
import 'package:flutter/material.dart';

class ScoreModel extends ChangeNotifier {
  ScoreModel({required this.scoreRepository});

  final ScoreRepository scoreRepository;
  List<ScoreWithCV>? fxScoreList;
  List<Score>? phScoreList;
  List<Score>? srScoreList;
  VTScore? vtScore;
  List<Score>? pbScoreList;
  List<ScoreWithCV>? hbScoreList;

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

  Future<void> onRefresh(String event) async {
    if (event == '床') {
      await getFXScores();
    }
    if (event == 'あん馬') {
      await getPHScores();
    }
    if (event == '吊り輪') {
      await getSRScores();
    }
    if (event == '平行棒') {
      await getPBScores();
    }
    if (event == '鉄棒') {
      await getHBScores();
    }
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
  bool isEdited = false;
  List<String> decidedTechList = [];
  num totalScore = 0.0;
  num difficultyPoint = 0.0;
  num egr = 0.0;
  num cv = 0.0;

  void startEdit() {
    isEdited = false;
    notifyListeners();
  }

  void resetScore() {
    decidedTechList = [];
    totalScore = 0.0;
    difficultyPoint = 0.0;
    egr = 0.0;
    cv = 0.0;
    notifyListeners();
  }

  Future<void> getFXScore(String scoreId, String event) async {
    isLoading = true;
    notifyListeners();
    selectEvent(event);
    ScoreWithCV fxScore = await scoreRepository.getFXSCore(scoreId);
    decidedTechList = fxScore.techs;
    cv = fxScore.cv;
    calculateScore(event);
    print(decidedTechList);
    isLoading = false;
    notifyListeners();
  }

  Future<void> setFXScore() async {
    isLoading = true;
    notifyListeners();
    scoreRepository.setFXScore(totalScore, decidedTechList, cv);
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateFXSCore(String scoreId) async {
    isLoading = true;
    notifyListeners();
    scoreRepository.updateFXScore(scoreId, totalScore, decidedTechList, cv);
    isLoading = false;
    notifyListeners();
  }

  void onCVSelected(value) {
    cv = value;
    isEdited = true;
    notifyListeners();
  }

  void calculateScore(String event) {
    if (event == '床') {
      List<String> group1 = [];
      List<String> group2 = [];
      List<String> group3 = [];
      decidedTechList.forEach((tech) {
        if (group[tech] == 1) {
          group1.add(tech);
        }
        if (group[tech] == 2) {
          group2.add(tech);
        }
        if (group[tech] == 3) {
          group3.add(tech);
        }
      });
      if (group1.length > 0 && group2.length > 0 && group3.length > 0) {
        egr = 1.5;
      } else {
        if (group1.length > 0 && group2.length > 0 ||
            group1.length > 0 && group3.length > 0 ||
            group2.length > 0 && group3.length > 0) {
          egr = 1.0;
        } else {
          if (group1.length > 0 || group2.length > 0 || group3.length > 0) {
            egr = 0.5;
          }
        }
      }
      if (group[decidedTechList.last]! != 1) {
        if (difficulty[decidedTechList.last]! >= 4) {
          egr = egr * 10 + 5;
          egr /= 10;
        } else {
          if (difficulty[decidedTechList.last]! >= 3) {
            egr = egr * 10 + 3;
            egr /= 10;
          }
        }
      }
    } else {
      //要求点の計算
      List<String> group1 = [];
      List<String> group2 = [];
      List<String> group3 = [];
      String group4 = '';
      decidedTechList.forEach((tech) {
        if (group[tech] == 1) {
          group1.add(tech);
        }
        if (group[tech] == 2) {
          group2.add(tech);
        }
        if (group[tech] == 3) {
          group3.add(tech);
        }
        if (group[tech] == 4) {
          group4 = tech;
        }
      });
      if (group1.length > 0 && group2.length > 0 && group3.length > 0) {
        egr = 1.5;
      } else {
        if (group1.length > 0 && group2.length > 0 ||
            group1.length > 0 && group3.length > 0 ||
            group2.length > 0 && group3.length > 0) {
          egr = 1.0;
        } else {
          if (group1.length > 0 || group2.length > 0 || group3.length > 0) {
            egr = 0.5;
          }
        }
      }
      if (group4 != '') {
        if (difficulty[group4]! >= 4) {
          egr = egr * 10 + 5;
          egr /= 10;
        } else {
          if (difficulty[group4]! >= 3) {
            egr = egr * 10 + 3;
            egr /= 10;
          }
        }
      }
    }
    //難度点の計算
    difficultyPoint = 0;
    decidedTechList.forEach((tech) {
      difficultyPoint = difficultyPoint * 10 + difficulty[tech]!;
      difficultyPoint /= 10;
    });
    //　トータルの計算
    totalScore = 0;
    totalScore = difficultyPoint * 10 + egr * 10 + cv * 10;
    totalScore /= 10;
    notifyListeners();
  }

  ///SearchScreen関連
  List<String> searchResult = [];
  Map<String, num> difficulty = {};
  Map<String, num> group = {};
  String vtTechName = '';

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
    if (event == '跳馬') {
      difficulty = vtTech;
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
      if (event == '跳馬') {
        final List<String> items = vtTech.keys
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

  void onTechSelected(String techName, int? order) {
    if (order != null) {
      decidedTechList[order - 1] = techName;
    } else {
      decidedTechList.add(techName);
    }
    print(decidedTechList);
    isEdited = true;
    notifyListeners();
  }

  void onVTTechSelected(int index) {
    final List<String> vtTechList =
        vtTech.keys.map((tech) => tech.toString()).toList();
    vtTechName = vtTechList[index];
    totalScore = vtTech[vtTechList[index]]!;
    isEdited = true;
    notifyListeners();
  }

  Future<void> setVTScore() async {
    await scoreRepository.setVTScore(vtTechName, totalScore);
  }
}
