import 'package:dscore_app/data/fx.dart';
import 'package:dscore_app/data/hb.dart';
import 'package:dscore_app/data/pb.dart';
import 'package:dscore_app/data/ph.dart';
import 'package:dscore_app/data/sr.dart';
import 'package:dscore_app/data/vt.dart';
import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/domain/score.dart';
import 'package:dscore_app/domain/score_with_cv.dart';
import 'package:dscore_app/domain/vt_score.dart';
import 'package:dscore_app/repository/score_repository.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:dscore_app/screens/score_edit_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scoreModelProvider = ChangeNotifierProvider((ref) => ScoreModel());

class ScoreModel extends ChangeNotifier {
  final scoreRepository = ScoreRepository();
  CurrentUser? get currentUser => UserRepository.currentUser;

  List<ScoreWithCV> fxScoreList = [];
  List<Score> phScoreList = [];
  List<Score> srScoreList = [];
  VTScore? vtScore;
  List<Score> pbScoreList = [];
  List<ScoreWithCV> hbScoreList = [];

  bool isLoading = false;

  ///scoreListScreen関連
  Future<void> getScores(Event event) async {
    isLoading = true;
    notifyListeners();

    if (currentUser != null) {
      if (event == Event.fx) {
        fxScoreList = await scoreRepository.getFXScores();
      }
      if (event == Event.ph) {
        phScoreList = await scoreRepository.getPHScores();
      }
      if (event == Event.sr) {
        srScoreList = await scoreRepository.getSRScores();
      }
      if (event == Event.pb) {
        pbScoreList = await scoreRepository.getPBScores();
      }
      if (event == Event.hb) {
        hbScoreList = await scoreRepository.getHBScores();
      }
    }

    isLoading = false;
    notifyListeners();
  }

  //お気に入り変更するため
  Future<List<String>> getScoreIds(Event event) async {
    if (event == Event.fx) {
      final scoreIds = <String>[];
      for (final fxScore in fxScoreList) {
        scoreIds.add(fxScore.scoreId);
      }
      return scoreIds;
    }
    if (event == Event.pb) {
      final scoreIds = <String>[];
      for (final phScore in phScoreList) {
        scoreIds.add(phScore.scoreId);
      }
      return scoreIds;
    }
    if (event == Event.sr) {
      final scoreIds = <String>[];
      for (final srScore in srScoreList) {
        scoreIds.add(srScore.scoreId);
      }
      return scoreIds;
    }
    if (event == Event.pb) {
      final scoreIds = <String>[];
      for (final pbScore in pbScoreList) {
        scoreIds.add(pbScore.scoreId);
      }
      return scoreIds;
    }
    if (event == Event.hb) {
      final scoreIds = <String>[];
      for (final hbScore in hbScoreList) {
        scoreIds.add(hbScore.scoreId);
      }
      return scoreIds;
    } else {
      return [];
    }
  }

  Future<void> onFavoriteButtonTapped(
      Event event, bool isFavorite, String scoreId) async {
    isLoading = true;
    notifyListeners();

    if (isFavorite) {
      await changeFavoriteState(scoreId, event, false);
    } else {
      final scoreIdList = await getScoreIds(event);
      //全てのスコアをのisFavoriteをfalseにしてから、選択されたものをtrueにする。
      for (final scoreId in scoreIdList) {
        await changeFavoriteState(scoreId, event, false);
      }
      await changeFavoriteState(scoreId, event, true);
    }

    await getScores(event);

    isLoading = false;
    notifyListeners();
  }

  Future<void> changeFavoriteState(
      String scoreId, Event event, bool isFavorite) async {
    if (event == Event.fx) {
      await scoreRepository.favoriteFXUpdate(scoreId, isFavorite);
    }
    if (event == Event.ph) {
      await scoreRepository.favoritePHUpdate(scoreId, isFavorite);
    }
    if (event == Event.sr) {
      await scoreRepository.favoriteSRUpdate(scoreId, isFavorite);
    }
    if (event == Event.pb) {
      await scoreRepository.favoritePBUpdate(scoreId, isFavorite);
    }
    if (event == Event.hb) {
      await scoreRepository.favoriteHBUpdate(scoreId, isFavorite);
    }
  }

  Future<void> deletePerformance(Event event, String scoreId) async {
    if (event == Event.fx) {
      await scoreRepository.deleteFXScore(scoreId);
    }
    if (event == Event.ph) {
      await scoreRepository.deletePHScore(scoreId);
    }
    if (event == Event.sr) {
      await scoreRepository.deleteSRScore(scoreId);
    }
    if (event == Event.pb) {
      await scoreRepository.deletePBScore(scoreId);
    }
    if (event == Event.hb) {
      await scoreRepository.deleteHBScore(scoreId);
    }
    await getScores(event);
    notifyListeners();
  }

  //ログアウト時
  void resetScores() {
    fxScoreList = [];
    phScoreList = [];
    srScoreList = [];
    vtScore = null;
    pbScoreList = [];
    hbScoreList = [];
    notifyListeners();
  }

  ///ScoreEditScreen関連
  bool isEdited = false;
  List<String> decidedTechList = [];
  num totalScore = 0.0;
  num difficultyPoint = 0.0;
  num egr = 0.0;
  num cv = 0.0;
  int numberOfGroup1 = 0;
  int numberOfGroup2 = 0;
  int numberOfGroup3 = 0;
  num difficultyOfGroup4 = 0;

  bool isUnder16 = false; //高校生ルールかどうか
  Color ruleTextColor = Colors.grey;

  List<String> searchChipWords = [];
  Map<String, num> difficulty = {};
  Map<String, int> group = {};

  //どの種目かの判断を各ページで行う
  void selectEvent(Event event) {
    if (event == Event.fx) {
      difficulty = fxDifficulty;
      group = fxGroup;
      searchChipWords = fxChipWords;
    }
    if (event == Event.ph) {
      difficulty = phDifficulty;
      group = phGroup;
      searchChipWords = phChipWords;
    }
    if (event == Event.sr) {
      difficulty = srDifficulty;
      group = srGroup;
      searchChipWords = srChipWords;
    }
    if (event == Event.vt) {
      difficulty = vtTech;
    }
    if (event == Event.pb) {
      difficulty = pbDifficulty;
      group = pbGroup;
      searchChipWords = pbChipWords;
    }
    if (event == Event.hb) {
      difficulty = hbDifficulty;
      group = hbGroup;
      searchChipWords = hbChipWords;
    }
    notifyListeners();
  }

  void noEdited() {
    isEdited = false;
    notifyListeners();
  }

  void resetScore() {
    decidedTechList = [];
    totalScore = 0.0;
    difficultyPoint = 0.0;
    egr = 0.0;
    cv = 0.0;
    numberOfGroup1 = 0;
    numberOfGroup2 = 0;
    numberOfGroup3 = 0;
    difficultyOfGroup4 = 0;
    notifyListeners();
  }

  void deleteTech(int index, Event event) {
    decidedTechList.remove(decidedTechList[index]);
    isEdited = true;
    calculateNumberOfGroup(event);
    calculateScore(event);
    notifyListeners();
  }

  void setRule(Event event, bool isUnder16) {
    this.isUnder16 = isUnder16;
    calculateScore(event);
    isEdited = true;
    notifyListeners();
  }

  Future<void> getScore(String scoreId, Event event) async {
    isLoading = true;
    notifyListeners();

    selectEvent(event);
    if (event == Event.fx) {
      final fxScore = await scoreRepository.getFXSCore(scoreId);
      decidedTechList = fxScore.techs;
      cv = fxScore.cv;
      isUnder16 = fxScore.isUnder16;
    }
    if (event == Event.ph) {
      final phScore = await scoreRepository.getPHScore(scoreId);
      decidedTechList = phScore.techs;
      isUnder16 = phScore.isUnder16;
    }
    if (event == Event.sr) {
      final srScore = await scoreRepository.getSRScore(scoreId);
      decidedTechList = srScore.techs;
      isUnder16 = srScore.isUnder16;
    }
    if (event == Event.pb) {
      final pbScore = await scoreRepository.getPBScore(scoreId);
      decidedTechList = pbScore.techs;
      isUnder16 = pbScore.isUnder16;
    }
    if (event == Event.hb) {
      final hbScore = await scoreRepository.getHBSCore(scoreId);
      decidedTechList = hbScore.techs;
      cv = hbScore.cv;
      isUnder16 = hbScore.isUnder16;
    }
    calculateNumberOfGroup(event);
    calculateScore(event);

    isLoading = false;
    notifyListeners();
  }

  Future<void> setScore(Event event) async {
    isLoading = true;
    notifyListeners();

    var isFavorite = false;
    if (event == Event.fx) {
      if (fxScoreList.isEmpty) {
        isFavorite = true;
      }
      await scoreRepository.setFXScore(
          totalScore, decidedTechList, cv, isFavorite, isUnder16);
    }
    if (event == Event.ph) {
      if (phScoreList.isEmpty) {
        isFavorite = true;
      }
      await scoreRepository.setPHScore(
          totalScore, decidedTechList, isFavorite, isUnder16);
    }
    if (event == Event.sr) {
      if (srScoreList.isEmpty) {
        isFavorite = true;
      }
      await scoreRepository.setSRScore(
          totalScore, decidedTechList, isFavorite, isUnder16);
    }
    if (event == Event.pb) {
      if (pbScoreList.isEmpty) {
        isFavorite = true;
      }
      await scoreRepository.setPBScore(
          totalScore, decidedTechList, isFavorite, isUnder16);
    }
    if (event == Event.hb) {
      if (hbScoreList.isEmpty) {
        isFavorite = true;
      }
      await scoreRepository.setHBScore(
          totalScore, decidedTechList, cv, isFavorite, isUnder16);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateScore(Event event, String scoreId) async {
    isLoading = true;
    notifyListeners();

    if (event == Event.fx) {
      await scoreRepository.updateFXScore(
          scoreId, totalScore, decidedTechList, cv, isUnder16);
    }
    if (event == Event.ph) {
      await scoreRepository.updatePHScore(
          scoreId, totalScore, decidedTechList, isUnder16);
      difficulty = phDifficulty;
      group = phGroup;
    }
    if (event == Event.sr) {
      await scoreRepository.updateSRScore(
          scoreId, totalScore, decidedTechList, isUnder16);
      difficulty = srDifficulty;
      group = srGroup;
    }
    if (event == Event.pb) {
      await scoreRepository.updatePBScore(
          scoreId, totalScore, decidedTechList, isUnder16);
      difficulty = pbDifficulty;
      group = pbGroup;
    }
    if (event == Event.hb) {
      await scoreRepository.updateHBScore(
          scoreId, totalScore, decidedTechList, cv, isUnder16);
      difficulty = hbDifficulty;
      group = hbGroup;
    }

    isLoading = false;
    notifyListeners();
  }

  void onCVSelected(num value) {
    cv = value;
    isEdited = true;
    notifyListeners();
  }

  void calculateNumberOfGroup(Event event) {
    numberOfGroup1 = 0;
    numberOfGroup2 = 0;
    numberOfGroup3 = 0;
    difficultyOfGroup4 = 0;
    for (final tech in decidedTechList) {
      if (group[tech] == 1) {
        numberOfGroup1++;
      } else if (group[tech] == 2) {
        numberOfGroup2++;
      } else if (group[tech] == 3) {
        numberOfGroup3++;
      }
      //床以外の種目かつ、技がグループ4だった時
      if (event != Event.fx && group[tech] == 4) {
        difficultyOfGroup4 = difficulty[tech]!;
      }
    }
    notifyListeners();
  }

  void calculateScore(Event event) {
    if (decidedTechList.isNotEmpty) {
      if (event == Event.fx) {
        //床の要求点の計算
        final group1 = <String>[];
        final group2 = <String>[];
        final group3 = <String>[];
        for (final tech in decidedTechList) {
          if (group[tech] == 1) {
            group1.add(tech);
          }
          if (group[tech] == 2) {
            group2.add(tech);
          }
          if (group[tech] == 3) {
            group3.add(tech);
          }
        }
        if (group1.isNotEmpty && group2.isNotEmpty && group3.isNotEmpty) {
          egr = 1.5;
        } else {
          if (group1.isNotEmpty && group2.isNotEmpty ||
              group1.isNotEmpty && group3.isNotEmpty ||
              group2.isNotEmpty && group3.isNotEmpty) {
            egr = 1.0;
          } else {
            if (group1.isNotEmpty || group2.isNotEmpty || group3.isNotEmpty) {
              egr = 0.5;
            }
          }
        }
        //終末技
        if (group[decidedTechList.last]! != 1) {
          if (difficulty[decidedTechList.last]! >= 4) {
            egr = egr * 10 + 5;
            egr /= 10;
          } else {
            if (difficulty[decidedTechList.last]! == 3) {
              egr = egr * 10 + 3;
              egr /= 10;
            }
          }
          if (isUnder16) {
            if (difficulty[decidedTechList.last]! == 2) {
              egr = egr * 10 + 2;
              egr /= 10;
            } else if (difficulty[decidedTechList.last]! == 1) {
              egr = egr * 10 + 1;
              egr /= 10;
            }
          }
        }
      } else {
        //床以外の要求点の計算
        final group1 = <String>[];
        final group2 = <String>[];
        final group3 = <String>[];
        var group4 = '';
        for (final tech in decidedTechList) {
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
        }

        if (group1.isNotEmpty && group2.isNotEmpty && group3.isNotEmpty) {
          egr = 1.5;
        } else {
          if (group1.isNotEmpty && group2.isNotEmpty ||
              group1.isNotEmpty && group3.isNotEmpty ||
              group2.isNotEmpty && group3.isNotEmpty) {
            egr = 1.0;
          } else {
            if (group1.isNotEmpty || group2.isNotEmpty || group3.isNotEmpty) {
              egr = 0.5;
            }
          }
        }
        //終末技
        if (group4 != '') {
          if (difficulty[group4]! >= 4) {
            egr = egr * 10 + 5;
            egr /= 10;
          } else {
            if (difficulty[group4]! == 3) {
              egr = egr * 10 + 3;
              egr /= 10;
            }
          }
        }
        if (group4 != '' && isUnder16) {
          if (difficulty[group4]! == 2) {
            egr = egr * 10 + 2;
            egr /= 10;
          } else {
            if (difficulty[group4]! == 1) {
              egr = egr * 10 + 1;
              egr /= 10;
            }
          }
        }
      }

      //難度点の計算
      difficultyPoint = 0;
      for (final tech in decidedTechList) {
        difficultyPoint = difficultyPoint * 10 + difficulty[tech]!;
        difficultyPoint /= 10;
      }
      //　トータルの計算
      totalScore = 0;
      totalScore = difficultyPoint * 10 + egr * 10 + cv * 10;
      totalScore /= 10;
    } else {
      difficultyPoint = 0;
      egr = 0;
      cv = 0;
      totalScore = 0;
    }
    notifyListeners();
  }

  void onReOrder(int oldIndex, int newIndex, Event event) {
    final numberChangedTech = decidedTechList.removeAt(oldIndex);
    if (oldIndex < newIndex) {
      decidedTechList.insert(newIndex - 1, numberChangedTech);
    } else {
      decidedTechList.insert(newIndex, numberChangedTech);
    }
    calculateScore(event);
    isEdited = true;
    notifyListeners();
  }

  ///SearchScreen関連
  List<String> searchResult = [];
  String vtTechName = '';

  //技検索
  void search(String inputText, Event event) {
    if (inputText.isEmpty) {
      searchResult.clear();
    } else {
      searchResult.clear(); //addしているため毎回クリアする必要がある
      final inputCharacters = <String>[];
      inputText.characters.forEach(inputCharacters.add);
      if (event == Event.fx) {
        searchResult = searchLogic(fxSearchWords, inputCharacters);
      }
      if (event == Event.ph) {
        searchResult = searchLogic(phSearchWords, inputCharacters);
      }
      if (event == Event.sr) {
        searchResult = searchLogic(srSearchWords, inputCharacters);
      }
      if (event == Event.pb) {
        searchResult = searchLogic(pbSearchWords, inputCharacters);
      }
      if (event == Event.hb) {
        searchResult = searchLogic(hbSearchWords, inputCharacters);
      }
    }
    notifyListeners();
  }

  List<String> searchLogic(
      Map<String, String> searchWords, List<String> characters) {
    final techsContainingFirstChar = <String>[];
    final techsToRemove = <String>[];

    for (var i = 0; i < characters.length; i++) {
      //0番目の文字を含むものをitemsに追加
      if (i == 0) {
        for (final word in searchWords.keys) {
          if (searchWords[word]!.contains(characters[0])) {
            techsContainingFirstChar.add(word);
          }
        }
      } else {
        //2番目以降の文字を含んでいないものをremoveListに追加
        for (final techs in techsContainingFirstChar) {
          if (!searchWords[techs]!.contains(characters[i])) {
            techsToRemove.add(techs);
          }
        }
      }
    }
    //removeListの要素をitemsから削除
    techsToRemove.forEach(techsContainingFirstChar.remove);
    return techsContainingFirstChar;
  }

  void onTechChipSelected(Event event, String searchText) {
    searchController.text = searchController.text + searchText;
    search(searchController.text, event);
    notifyListeners();
  }

  void deleteSearchBarText(TextEditingController controller) {
    controller.clear();
    searchResult.clear();
    notifyListeners();
  }

  bool isSameTechSelected(String techName) {
    var isExist = false;
    for (final tech in decidedTechList) {
      if (techName == tech) {
        isExist = true;
      }
    }
    return isExist;
  }

  void setTech(String techName, int? order) {
    if (order != null) {
      decidedTechList[order - 1] = techName;
    } else {
      decidedTechList.add(techName);
    }
    isEdited = true;
    notifyListeners();
  }

  ///VTScoreList関連
  void onVTTechSelected(int index) {
    final vtTechList = vtTech.keys.map((tech) => tech.toString()).toList();
    vtTechName = vtTechList[index];
    totalScore = vtTech[vtTechList[index]]!;
    isEdited = true;
    notifyListeners();
  }

  Future<void> setVTScore() async {
    await scoreRepository.setVTScore(vtTechName, totalScore);
  }

  Future<void> getVTScore() async {
    if (currentUser != null) {
      final vtScore = await scoreRepository.getVTScore();
      if (vtScore != null) {
        vtTechName = vtScore.techName;
        totalScore = vtTech[vtScore.techName]!;
      }
    }
  }
}
