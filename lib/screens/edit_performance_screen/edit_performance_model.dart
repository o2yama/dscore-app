import 'package:dscore_app/data/fx.dart';
import 'package:dscore_app/data/hb.dart';
import 'package:dscore_app/data/pb.dart';
import 'package:dscore_app/data/ph.dart';
import 'package:dscore_app/data/sr.dart';
import 'package:dscore_app/data/vt.dart';
import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/repository/score_repository.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editPerformanceModelProvider = ChangeNotifierProvider(
  (ref) => EditPerformanceModel(),
);

class EditPerformanceModel extends ChangeNotifier {
  final scoreRepository = ScoreRepository();
  CurrentUser? get currentUser => UserRepository.currentUser;

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
  }

  Future<void> setScore(Event event, bool isFirst) async {
    if (event == Event.fx) {
      await scoreRepository.setFXScore(
          totalScore, decidedTechList, cv, isFirst, isUnder16);
    }
    if (event == Event.ph) {
      await scoreRepository.setPHScore(
          totalScore, decidedTechList, isFirst, isUnder16);
    }
    if (event == Event.sr) {
      await scoreRepository.setSRScore(
          totalScore, decidedTechList, isFirst, isUnder16);
    }
    if (event == Event.pb) {
      await scoreRepository.setPBScore(
          totalScore, decidedTechList, isFirst, isUnder16);
    }
    if (event == Event.hb) {
      await scoreRepository.setHBScore(
          totalScore, decidedTechList, cv, isFirst, isUnder16);
    }
  }

  Future<void> updateScore(Event event, String scoreId) async {
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

  //要求点の計算
  num calculateEGR(List<String> techList, Event event) {
    var egr = 0.0;

    if (techList.isNotEmpty) {
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
    } else {
      difficultyPoint = 0;
      egr = 0;
      cv = 0;
      totalScore = 0;
    }

    return egr;
  }

  //難度点の計算
  num calculateDifficulty(List<String> techList, Event event) {
    var difficultyPoint = 0.0;

    if (techList.isNotEmpty) {
      for (final tech in decidedTechList) {
        difficultyPoint = difficultyPoint * 10 + difficulty[tech]!;
        difficultyPoint /= 10;
      }
    }

    return difficultyPoint;
  }

  void calculateScore(Event event) {
    egr = calculateEGR(decidedTechList, event);
    difficultyPoint = calculateDifficulty(decidedTechList, event);

    totalScore = difficultyPoint * 10 + egr * 10 + cv * 10;
    totalScore /= 10;
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
}
