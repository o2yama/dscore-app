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
import 'package:dscore_app/screens/score_edit_screen/search_screen.dart';
import 'package:flutter/material.dart';

class ScoreModel extends ChangeNotifier {
  ScoreModel({required this.scoreRepository});

  final ScoreRepository scoreRepository;
  CurrentUser? get currentUser => UserRepository.currentUser;

  List<ScoreWithCV> fxScoreList = [];
  List<Score> phScoreList = [];
  List<Score> srScoreList = [];
  VTScore? vtScore;
  List<Score> pbScoreList = [];
  List<ScoreWithCV> hbScoreList = [];

  bool isLoading = false;

  ///scoreListScreen関連
  Future<void> getScores(String event) async {
    isLoading = true;
    notifyListeners();

    if (currentUser != null) {
      if (event == '床') {
        fxScoreList = await scoreRepository.getFXScores();
      }
      if (event == 'あん馬') {
        phScoreList = await scoreRepository.getPHScores();
      }
      if (event == '吊り輪') {
        srScoreList = await scoreRepository.getSRScores();
      }
      if (event == '平行棒') {
        pbScoreList = await scoreRepository.getPBScores();
      }
      if (event == '鉄棒') {
        hbScoreList = await scoreRepository.getHBScores();
      }
    }

    isLoading = false;
    notifyListeners();
  }

  //お気に入り変更するため
  Future<List<String>> getScoreIds(String event) async {
    if (event == '床') {
      final scoreIds = <String>[];
      for (final fxScore in fxScoreList) {
        scoreIds.add(fxScore.scoreId);
      }
      return scoreIds;
    }
    if (event == 'あん馬') {
      final scoreIds = <String>[];
      for (final phScore in phScoreList) {
        scoreIds.add(phScore.scoreId);
      }
      return scoreIds;
    }
    if (event == '吊り輪') {
      final scoreIds = <String>[];
      for (final srScore in srScoreList) {
        scoreIds.add(srScore.scoreId);
      }
      return scoreIds;
    }
    if (event == '平行棒') {
      final scoreIds = <String>[];
      for (final pbScore in pbScoreList) {
        scoreIds.add(pbScore.scoreId);
      }
      return scoreIds;
    }
    if (event == '鉄棒') {
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
      String event, bool isFavorite, String scoreId) async {
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
      String scoreId, String event, bool isFavorite) async {
    if (event == '床') {
      await scoreRepository.favoriteFXUpdate(scoreId, isFavorite);
    }
    if (event == 'あん馬') {
      await scoreRepository.favoritePHUpdate(scoreId, isFavorite);
    }
    if (event == '吊り輪') {
      await scoreRepository.favoriteSRUpdate(scoreId, isFavorite);
    }
    if (event == '平行棒') {
      await scoreRepository.favoritePBUpdate(scoreId, isFavorite);
    }
    if (event == '鉄棒') {
      await scoreRepository.favoriteHBUpdate(scoreId, isFavorite);
    }
  }

  Future<void> deletePerformance(String event, String scoreId) async {
    if (event == '床') {
      await scoreRepository.deleteFXScore(scoreId);
    }
    if (event == 'あん馬') {
      await scoreRepository.deletePHScore(scoreId);
    }
    if (event == '吊り輪') {
      await scoreRepository.deleteSRScore(scoreId);
    }
    if (event == '平行棒') {
      await scoreRepository.deletePBScore(scoreId);
    }
    if (event == '鉄棒') {
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
  void selectEvent(String event) {
    if (event == '床') {
      difficulty = fxDifficulty;
      group = fxGroup;
      searchChipWords = fxChipWords;
    }
    if (event == 'あん馬') {
      difficulty = phDifficulty;
      group = phGroup;
      searchChipWords = phChipWords;
    }
    if (event == '吊り輪') {
      difficulty = srDifficulty;
      group = srGroup;
      searchChipWords = srChipWords;
    }
    if (event == '跳馬') {
      difficulty = vtTech;
    }
    if (event == '平行棒') {
      difficulty = pbDifficulty;
      group = pbGroup;
      searchChipWords = pbChipWords;
    }
    if (event == '鉄棒') {
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

  void deleteTech(int index, String event) {
    decidedTechList.remove(decidedTechList[index]);
    isEdited = true;
    calculateNumberOfGroup(event);
    calculateScore(event);
    notifyListeners();
  }

  void setRule(String event, bool isUnder16) {
    this.isUnder16 = isUnder16;
    calculateScore(event);
    notifyListeners();
  }

  Future<void> getScore(String scoreId, String event) async {
    isLoading = true;
    notifyListeners();

    selectEvent(event);
    if (event == '床') {
      final fxScore = await scoreRepository.getFXSCore(scoreId);
      decidedTechList = fxScore.techs;
      cv = fxScore.cv;
      isUnder16 = fxScore.isUnder16;
    }
    if (event == 'あん馬') {
      final phScore = await scoreRepository.getPHScore(scoreId);
      decidedTechList = phScore.techs;
      isUnder16 = phScore.isUnder16;
    }
    if (event == '吊り輪') {
      final srScore = await scoreRepository.getSRScore(scoreId);
      decidedTechList = srScore.techs;
      isUnder16 = srScore.isUnder16;
    }
    if (event == '平行棒') {
      final pbScore = await scoreRepository.getPBScore(scoreId);
      decidedTechList = pbScore.techs;
      isUnder16 = pbScore.isUnder16;
    }
    if (event == '鉄棒') {
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

  Future<void> setScore(String event) async {
    isLoading = true;
    notifyListeners();

    var isFavorite = false;
    if (event == '床') {
      if (fxScoreList.isEmpty) {
        isFavorite = true;
      }
      await scoreRepository.setFXScore(
        totalScore,
        decidedTechList,
        cv,
        isFavorite,
        isUnder16,
      );
    }
    if (event == 'あん馬') {
      if (phScoreList.isEmpty) {
        isFavorite = true;
      }
      await scoreRepository.setPHScore(
        totalScore,
        decidedTechList,
        isFavorite,
        isUnder16,
      );
    }
    if (event == '吊り輪') {
      if (srScoreList.isEmpty) {
        isFavorite = true;
      }
      await scoreRepository.setSRScore(
        totalScore,
        decidedTechList,
        isFavorite,
        isUnder16,
      );
    }
    if (event == '平行棒') {
      if (pbScoreList.isEmpty) {
        isFavorite = true;
      }
      await scoreRepository.setPBScore(
        totalScore,
        decidedTechList,
        isFavorite,
        isUnder16,
      );
    }
    if (event == '鉄棒') {
      if (hbScoreList.isEmpty) {
        isFavorite = true;
      }
      await scoreRepository.setHBScore(
        totalScore,
        decidedTechList,
        cv,
        isFavorite,
        isUnder16,
      );
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateScore(String event, String scoreId) async {
    isLoading = true;
    notifyListeners();

    if (event == '床') {
      await scoreRepository.updateFXScore(
        scoreId,
        totalScore,
        decidedTechList,
        cv,
        isUnder16,
      );
    }
    if (event == 'あん馬') {
      await scoreRepository.updatePHScore(
        scoreId,
        totalScore,
        decidedTechList,
        isUnder16,
      );
      difficulty = phDifficulty;
      group = phGroup;
    }
    if (event == '吊り輪') {
      await scoreRepository.updateSRScore(
        scoreId,
        totalScore,
        decidedTechList,
        isUnder16,
      );
      difficulty = srDifficulty;
      group = srGroup;
    }
    if (event == '平行棒') {
      await scoreRepository.updatePBScore(
        scoreId,
        totalScore,
        decidedTechList,
        isUnder16,
      );
      difficulty = pbDifficulty;
      group = pbGroup;
    }
    if (event == '鉄棒') {
      await scoreRepository.updateHBScore(
          scoreId, totalScore, decidedTechList, cv);
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

  void calculateNumberOfGroup(String event) {
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
      if (event != '床' && group[tech] == 4) {
        difficultyOfGroup4 = difficulty[tech]!;
      }
    }
    notifyListeners();
  }

  void calculateScore(String event) {
    if (decidedTechList.isNotEmpty) {
      if (event == '床') {
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
      print('計算したよ');
    } else {
      difficultyPoint = 0;
      egr = 0;
      cv = 0;
      totalScore = 0;
    }
    notifyListeners();
  }

  void onReOrder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      // ignore: parameter_assignments
      newIndex -= 1;
    }
    final numberChangedTech = decidedTechList.removeAt(oldIndex);
    decidedTechList.insert(newIndex, numberChangedTech);
    isEdited = true;
    notifyListeners();
  }

  ///SearchScreen関連
  List<String> searchResult = [];
  String vtTechName = '';

  //技検索
  void search(String inputText, String event) {
    if (inputText.isEmpty) {
      searchResult.clear();
    } else {
      searchResult.clear(); //addしているため毎回クリアする必要がある
      final inputCharacters = <String>[];
      inputText.characters.forEach(inputCharacters.add);
      if (event == '床') {
        searchResult = searchLogic(fxSearchWords, inputCharacters);
      }
      if (event == 'あん馬') {
        searchResult = searchLogic(phSearchWords, inputCharacters);
      }
      if (event == '吊り輪') {
        searchResult = searchLogic(srSearchWords, inputCharacters);
      }
      if (event == '平行棒') {
        searchResult = searchLogic(pbSearchWords, inputCharacters);
      }
      if (event == '鉄棒') {
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

  void onTechChipSelected(String event, String searchText) {
    searchController.text = searchController.text + searchText;
    search(searchController.text, event);
    notifyListeners();
  }

  void deleteSearchBarText(TextEditingController controller) {
    controller.clear();
    searchResult.clear();
    notifyListeners();
  }

  void onTechTileSelected(String techName, int? order) {
    var isExist = false;
    if (order != null) {
      decidedTechList[order - 1] = techName;
    } else {
      for (final tech in decidedTechList) {
        if (techName == tech) {
          isExist = true;
          final Error error = ArgumentError('同じ技が登録されています。');
          throw error;
        }
      }
      if (!isExist) {
        decidedTechList.add(techName);
      }
    }
    print(decidedTechList);
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
