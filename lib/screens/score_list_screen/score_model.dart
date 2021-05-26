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
  CurrentUser? get authenticatedUser => UserRepository.currentUser;

  List<ScoreWithCV>? fxScoreList;
  List<Score>? phScoreList;
  List<Score>? srScoreList;
  VTScore? vtScore;
  List<Score>? pbScoreList;
  List<ScoreWithCV>? hbScoreList;

  bool isLoading = false;

  ///scoreListScreen関連
  Future<void> getFXScores() async {
    isLoading = true;
    notifyListeners();

    if (authenticatedUser != null) {
      fxScoreList = await scoreRepository.getFXScores();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getPHScores() async {
    isLoading = true;
    notifyListeners();

    if (authenticatedUser != null) {
      phScoreList = await scoreRepository.getPHScores();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getSRScores() async {
    isLoading = true;
    notifyListeners();

    if (authenticatedUser != null) {
      srScoreList = await scoreRepository.getSRScores();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getPBScores() async {
    isLoading = true;
    notifyListeners();

    if (authenticatedUser != null) {
      pbScoreList = await scoreRepository.getPBScores();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getHBScores() async {
    isLoading = true;
    notifyListeners();

    if (authenticatedUser != null) {
      hbScoreList = await scoreRepository.getHBScores();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getScores(String event) async {
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

  //お気に入り変更するため
  Future<List<String>> getScoreIds(String event) async {
    if (event == '床') {
      await getFXScores();
      List<String> scoreIds = [];
      fxScoreList!.forEach((fxScore) {
        scoreIds.add(fxScore.scoreId);
      });
      return scoreIds;
    }
    if (event == 'あん馬') {
      await getPHScores();
      List<String> scoreIds = [];
      phScoreList!.forEach((phScore) {
        scoreIds.add(phScore.scoreId);
      });
      return scoreIds;
    }
    if (event == '吊り輪') {
      await getSRScores();
      List<String> scoreIds = [];
      srScoreList!.forEach((srScore) {
        scoreIds.add(srScore.scoreId);
      });
      return scoreIds;
    }
    if (event == '平行棒') {
      await getPBScores();
      List<String> scoreIds = [];
      pbScoreList!.forEach((pbScore) {
        scoreIds.add(pbScore.scoreId);
      });
      return scoreIds;
    }
    if (event == '鉄棒') {
      await getHBScores();
      List<String> scoreIds = [];
      hbScoreList!.forEach((hbScore) {
        scoreIds.add(hbScore.scoreId);
      });
      return scoreIds;
    } else {
      return [];
    }
  }

  Future<void> changeFavoriteFalse(
      String event, String scoreId, bool isFavorite) async {
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

  Future<void> onFavoriteButtonTapped(
      String event, bool isFavorite, String scoreId) async {
    isLoading = true;
    notifyListeners();

    if (isFavorite) {
      isFavorite = false;
    } else {
      List<String> scoreIdList = await getScoreIds(event);
      scoreIdList.forEach((scoreId) {
        changeFavoriteFalse(event, scoreId, false);
      });
      isFavorite = true;
    }
    await changeFavoriteFalse(event, scoreId, isFavorite);

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
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTechs(String event, String scoreId) async {
    if (event == '床') {
      await scoreRepository.deleteFXScore(scoreId);
      await getFXScores();
    }
    if (event == 'あん馬') {
      await scoreRepository.deletePHScore(scoreId);
      await getPHScores();
    }
    if (event == '吊り輪') {
      await scoreRepository.deleteSRScore(scoreId);
      await getSRScores();
    }
    if (event == '平行棒') {
      await scoreRepository.deletePBScore(scoreId);
      await getPBScores();
    }
    if (event == '鉄棒') {
      await scoreRepository.deleteHBScore(scoreId);
      await getHBScores();
    }
    notifyListeners();
  }

  //ログアウト時
  void resetScores() {
    fxScoreList = null;
    phScoreList = null;
    srScoreList = null;
    vtScore = null;
    pbScoreList = null;
    hbScoreList = null;
    notifyListeners();
  }

  ///ScoreEditScreen関連
  bool isEdited = false;
  List<String> decidedTechList = [];
  num totalScore = 0.0;
  num difficultyPoint = 0.0;
  num egr = 0.0;
  num cv = 0.0;

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

  void deleteTech(int index, String event) {
    decidedTechList.remove(decidedTechList[index]);
    isEdited = true;
    calculateScore(event);
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

  Future<void> setScore(String event) async {
    isLoading = true;
    notifyListeners();

    if (event == '床') {
      await scoreRepository.setFXScore(totalScore, decidedTechList, cv);
    }
    if (event == 'あん馬') {
      await scoreRepository.setPHScore(totalScore, decidedTechList);
      difficulty = phDifficulty;
      group = phGroup;
    }
    if (event == '吊り輪') {
      await scoreRepository.setSRScore(totalScore, decidedTechList);
      difficulty = srDifficulty;
      group = srGroup;
    }
    if (event == '平行棒') {
      await scoreRepository.setPBScore(totalScore, decidedTechList);
      difficulty = pbDifficulty;
      group = pbGroup;
    }
    if (event == '鉄棒') {
      await scoreRepository.setHBScore(totalScore, decidedTechList, cv);
      difficulty = hbDifficulty;
      group = hbGroup;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateScore(String event, String scoreId) async {
    isLoading = true;
    notifyListeners();

    if (event == '床') {
      await scoreRepository.updateFXScore(
          scoreId, totalScore, decidedTechList, cv);
    }
    if (event == 'あん馬') {
      await scoreRepository.updatePHScore(scoreId, totalScore, decidedTechList);
      difficulty = phDifficulty;
      group = phGroup;
    }
    if (event == '吊り輪') {
      await scoreRepository.updateSRScore(scoreId, totalScore, decidedTechList);
      difficulty = srDifficulty;
      group = srGroup;
    }
    if (event == '平行棒') {
      await scoreRepository.updatePBScore(scoreId, totalScore, decidedTechList);
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

  Future<void> getPHScore(String scoreId, String event) async {
    isLoading = true;
    notifyListeners();
    selectEvent(event);
    Score phScore = await scoreRepository.getPHScore(scoreId);
    decidedTechList = phScore.techs;
    calculateScore(event);
    print(decidedTechList);
    isLoading = false;
    notifyListeners();
  }

  Future<void> setPHScore() async {
    isLoading = true;
    notifyListeners();
    scoreRepository.setPHScore(totalScore, decidedTechList);
    isLoading = false;
    notifyListeners();
  }

  Future<void> updatePHScore(String scoreId) async {
    isLoading = true;
    notifyListeners();
    scoreRepository.updatePHScore(scoreId, totalScore, decidedTechList);
    isLoading = false;
    notifyListeners();
  }

  Future<void> getSRScore(String scoreId, String event) async {
    isLoading = true;
    notifyListeners();
    selectEvent(event);
    Score srScore = await scoreRepository.getSRScore(scoreId);
    decidedTechList = srScore.techs;
    calculateScore(event);
    print(decidedTechList);
    isLoading = false;
    notifyListeners();
  }

  Future<void> setSRScore() async {
    isLoading = true;
    notifyListeners();
    scoreRepository.setSRScore(totalScore, decidedTechList);
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateSRScore(String scoreId) async {
    isLoading = true;
    notifyListeners();
    scoreRepository.updateSRScore(scoreId, totalScore, decidedTechList);
    isLoading = false;
    notifyListeners();
  }

  Future<void> getPBScore(String scoreId, String event) async {
    isLoading = true;
    notifyListeners();
    selectEvent(event);
    Score pbScore = await scoreRepository.getPBScore(scoreId);
    decidedTechList = pbScore.techs;
    calculateScore(event);
    print(decidedTechList);
    isLoading = false;
    notifyListeners();
  }

  Future<void> setPBScore() async {
    isLoading = true;
    notifyListeners();
    scoreRepository.setPBScore(totalScore, decidedTechList);
    isLoading = false;
    notifyListeners();
  }

  Future<void> updatePBScore(String scoreId) async {
    isLoading = true;
    notifyListeners();
    scoreRepository.updatePBScore(scoreId, totalScore, decidedTechList);
    isLoading = false;
    notifyListeners();
  }

  Future<void> getHBScore(String scoreId, String event) async {
    isLoading = true;
    notifyListeners();
    selectEvent(event);
    ScoreWithCV hbScore = await scoreRepository.getHBSCore(scoreId);
    decidedTechList = hbScore.techs;
    cv = hbScore.cv;
    calculateScore(event);
    print(decidedTechList);
    isLoading = false;
    notifyListeners();
  }

  Future<void> setHBScore() async {
    isLoading = true;
    notifyListeners();
    scoreRepository.setHBScore(totalScore, decidedTechList, cv);
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateHBScore(String scoreId) async {
    isLoading = true;
    notifyListeners();
    scoreRepository.updateHBScore(scoreId, totalScore, decidedTechList, cv);
    isLoading = false;
    notifyListeners();
  }

  void onCVSelected(value) {
    cv = value;
    isEdited = true;
    notifyListeners();
  }

  void calculateScore(String event) {
    if (decidedTechList.length != 0) {
      if (event == '床') {
        //床の要求点の計算
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
        //床以外の要求点の計算
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
    } else {
      difficultyPoint = 0;
      egr = 0;
      cv = 0;
      totalScore = 0;
    }
    notifyListeners();
  }

  ///SearchScreen関連
  List<String> searchResult = [];
  Map<String, num> difficulty = {};
  Map<String, num> group = {};
  String vtTechName = '';

  //技検索
  void search(String text, String event) {
    if (text.isEmpty) {
      searchResult.clear();
    } else {
      searchResult.clear(); //addしているため毎回クリアする必要がある
      List<String> inputCharacters = [];
      text.characters.forEach((char) {
        inputCharacters.add(char);
      });
      if (event == '床') {
        searchResult = searchLogic(fxGroup, inputCharacters.toList());
      }
      if (event == 'あん馬') {
        searchResult = searchLogic(phGroup, inputCharacters.toList());
      }
      if (event == '吊り輪') {
        searchResult = searchLogic(srGroup, inputCharacters.toList());
      }
      if (event == '平行棒') {
        searchResult = searchLogic(pbGroup, inputCharacters.toList());
      }
      if (event == '鉄棒') {
        searchResult = searchLogic(hbGroup, inputCharacters.toList());
      }
    }
    notifyListeners();
  }

  List<String> searchLogic(Map<String, int> group, List<String> characters) {
    List<String> items = [];
    List<String> removeItems = [];
    for (int i = 0; i < characters.length; i++) {
      //0番目の文字を含むものをitemsに追加
      //1番目以降の文字を含んでいないものをremoveListに追加
      if (i == 0) {
        final List<String> resultContainingFirstChar = group.keys
            .where((techName) => techName.toLowerCase().contains(characters[0]))
            .toList();
        items = resultContainingFirstChar;
      } else {
        items.forEach((techName) {
          if (!techName.toLowerCase().contains(characters[i])) {
            removeItems.add(techName);
          }
        });
      }
    }
    //removeListの要素をitemsから削除
    removeItems.forEach((removeTechName) {
      items.remove(removeTechName);
    });
    return items;
  }

  bool selected = false;
  List<String> techFXItem = [
    '前方',
    '後方',
    'ダブル',
    "抱え込み",
    "屈伸",
    "伸身",
    "1回",
    "2回",
    "3回"
  ];
  List<String> techPHItem = [
    'セアー',
    '旋回',
    '前移動',
    '後ろ移動',
    '開脚',
    "フロップ",
    'コンバイン',
    'ロス',
    '降り'
  ];
  List<String> techSRItem = [
    '車輪',
    '十字',
    '上水平',
    '中水平',
    'ヤマワキ',
    'ジョナサン',
    'サルト',
    'ルドルフ'
  ];
  List<String> techPBItem = [
    'ツイスト',
    'ディアミノフ',
    'ホンマ',
    'ヒーリー',
    '車輪',
    'モイ',
    'ティッペルト',
    '屈伸ダブル'
  ];
  List<String> techHBItem = [
    '車輪',
    'シート',
    'エンドー',
    'コスミック',
    'コバチ',
    'コールマン',
    'トカチェフ',
    'サルト'
  ];

  void techFXChoice(String event, String techFXItem) {
    searchController.text = searchController.text + techFXItem;
    notifyListeners();
  }

  void techPHChoice(String event, String techPHItem) {
    searchController.text = searchController.text + techPHItem;
    notifyListeners();
  }

  void techSRChoice(String event, String techSRItem) {
    searchController.text = searchController.text + techSRItem;
    notifyListeners();
  }

  void techPBChoice(String event, String techPBItem) {
    searchController.text = searchController.text + techPBItem;
    notifyListeners();
  }

  void techHBChoice(String event, String techHBItem) {
    searchController.text = searchController.text + techHBItem;
    notifyListeners();
  }

  void deleteSearchBarText(TextEditingController controller) {
    controller.clear();
    searchResult.clear();
    notifyListeners();
  }

  void onTechSelected(String techName, int? order) {
    bool isExist = false;
    if (order != null) {
      decidedTechList[order - 1] = techName;
    } else {
      decidedTechList.forEach((tech) {
        if (techName == tech) {
          isExist = true;
          throw '同じ技が登録されています。';
        }
      });
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

  Future<void> getVTScore() async {
    if (authenticatedUser != null) {
      final vtScore = await scoreRepository.getVTScore();
      if (vtScore != null) {
        vtTechName = vtScore.techName;
        totalScore = vtTech[vtScore.techName]!;
      }
    }
  }
}
