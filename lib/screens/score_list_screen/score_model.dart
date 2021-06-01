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
  bool isFinishedGettingScores = false;

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

    isFinishedGettingScores = true;
    isLoading = false;
    notifyListeners();
  }

  //お気に入り変更するため
  Future<List<String>> getScoreIds(String event) async {
    if (event == '床') {
      List<String> scoreIds = [];
      fxScoreList.forEach((fxScore) {
        scoreIds.add(fxScore.scoreId);
      });
      return scoreIds;
    }
    if (event == 'あん馬') {
      List<String> scoreIds = [];
      phScoreList.forEach((phScore) {
        scoreIds.add(phScore.scoreId);
      });
      return scoreIds;
    }
    if (event == '吊り輪') {
      List<String> scoreIds = [];
      srScoreList.forEach((srScore) {
        scoreIds.add(srScore.scoreId);
      });
      return scoreIds;
    }
    if (event == '平行棒') {
      List<String> scoreIds = [];
      pbScoreList.forEach((pbScore) {
        scoreIds.add(pbScore.scoreId);
      });
      return scoreIds;
    }
    if (event == '鉄棒') {
      List<String> scoreIds = [];
      hbScoreList.forEach((hbScore) {
        scoreIds.add(hbScore.scoreId);
      });
      return scoreIds;
    } else {
      return [];
    }
  }

  Future<void> changeFavoriteState(
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
      final scoreIdList = await getScoreIds(event);
      //全てのスコアをのisFavoriteをfalseにしてから、選択されたものをtrueにする。
      scoreIdList.forEach((scoreId) {
        changeFavoriteState(event, scoreId, false);
      });
      isFavorite = true;
    }
    await changeFavoriteState(event, scoreId, isFavorite);

    getScores(event);

    isLoading = false;
    notifyListeners();
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
    getScores(event);
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

  List<String> searchChipTexts = [];
  Map<String, num> difficulty = {};
  Map<String, num> group = {};

  //どの種目かの判断を各ページで行う
  void selectEvent(String event) {
    if (event == '床') {
      difficulty = fxDifficulty;
      group = fxGroup;
      searchChipTexts = fxChipTexts;
    }
    if (event == 'あん馬') {
      difficulty = phDifficulty;
      group = phGroup;
      searchChipTexts = phSearchText;
    }
    if (event == '吊り輪') {
      difficulty = srDifficulty;
      group = srGroup;
      searchChipTexts = srSearchText;
    }
    if (event == '跳馬') {
      difficulty = vtTech;
    }
    if (event == '平行棒') {
      difficulty = pbDifficulty;
      group = pbGroup;
      searchChipTexts = pbSearchText;
    }
    if (event == '鉄棒') {
      difficulty = hbDifficulty;
      group = hbGroup;
      searchChipTexts = hbSearchText;
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

  Future<void> getScore(String scoreId, String event) async {
    isLoading = true;
    notifyListeners();

    selectEvent(event);
    if (event == '床') {
      ScoreWithCV fxScore = await scoreRepository.getFXSCore(scoreId);
      decidedTechList = fxScore.techs;
      cv = fxScore.cv;
    }
    if (event == 'あん馬') {
      Score phScore = await scoreRepository.getPHScore(scoreId);
      decidedTechList = phScore.techs;
    }
    if (event == '吊り輪') {
      Score srScore = await scoreRepository.getSRScore(scoreId);
      decidedTechList = srScore.techs;
    }
    if (event == '平行棒') {
      Score pbScore = await scoreRepository.getPBScore(scoreId);
      decidedTechList = pbScore.techs;
    }
    if (event == '鉄棒') {
      ScoreWithCV hbScore = await scoreRepository.getHBSCore(scoreId);
      decidedTechList = hbScore.techs;
      cv = hbScore.cv;
    }
    calculateScore(event);

    isLoading = false;
    notifyListeners();
  }

  Future<void> setScore(String event) async {
    isLoading = true;
    notifyListeners();

    bool isFavorite = false;
    if (event == '床') {
      if (fxScoreList.isEmpty) isFavorite = true;
      await scoreRepository.setFXScore(
          totalScore, decidedTechList, cv, isFavorite);
    }
    if (event == 'あん馬') {
      if (phScoreList.isEmpty) isFavorite = true;
      await scoreRepository.setPHScore(totalScore, decidedTechList, isFavorite);
    }
    if (event == '吊り輪') {
      if (srScoreList.isEmpty) isFavorite = true;
      await scoreRepository.setSRScore(totalScore, decidedTechList, isFavorite);
    }
    if (event == '平行棒') {
      if (pbScoreList.isEmpty) isFavorite = true;
      await scoreRepository.setPBScore(totalScore, decidedTechList, isFavorite);
    }
    if (event == '鉄棒') {
      if (hbScoreList.isEmpty) isFavorite = true;
      await scoreRepository.setHBScore(
          totalScore, decidedTechList, cv, isFavorite);
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
    if (currentUser != null) {
      final vtScore = await scoreRepository.getVTScore();
      if (vtScore != null) {
        vtTechName = vtScore.techName;
        totalScore = vtTech[vtScore.techName]!;
      }
    }
  }
}
