import 'package:dscore_app/consts/event.dart';
import 'package:dscore_app/data/fx/fx.dart';
import 'package:dscore_app/data/hb/hb.dart';
import 'package:dscore_app/data/pb/pb.dart';
import 'package:dscore_app/data/ph/ph.dart';
import 'package:dscore_app/data/sr/sr.dart';
import 'package:dscore_app/repository/performance_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editPerformanceModelProvider = ChangeNotifierProvider(
  (ref) => EditPerformanceModel()..init(),
);

class EditPerformanceModel extends ChangeNotifier {
  late final PerformanceRepository performanceRepository;
  init() => performanceRepository = PerformanceRepository();

  bool isEdited = false;
  List<String> decidedTechList = [];
  num cv = 0.0;
  bool isUnder16 = false; // 高校生ルールかどうか

  Map<String, int> allDifficultyDataOf(Event event) {
    switch (event) {
      case Event.fx:
        return fxDifficulty;
      case Event.ph:
        return phDifficulty;
      case Event.sr:
        return srDifficulty;
      case Event.vt:
        // 跳馬はなし
        return <String, int>{};
      case Event.pb:
        return pbDifficulty;
      case Event.hb:
        return hbDifficulty;
    }
  }

  Map<String, int> allGroupDataOf(Event event) {
    switch (event) {
      case Event.fx:
        return fxGroup;
      case Event.ph:
        return phGroup;
      case Event.sr:
        return srGroup;
      case Event.vt:
        return {};
      case Event.pb:
        return pbGroup;
      case Event.hb:
        return hbGroup;
    }
  }

  List<String> suggestionWordsOf(Event event) {
    switch (event) {
      case Event.fx:
        return fxChipWords;
      case Event.ph:
        return phChipWords;
      case Event.sr:
        return srChipWords;
      case Event.vt:
        return [];
      case Event.pb:
        return pbChipWords;
      case Event.hb:
        return hbChipWords;
    }
  }

  void noEdited() {
    isEdited = false;
    notifyListeners();
  }

  void resetScore() {
    decidedTechList = [];
    cv = 0.0;
    notifyListeners();
  }

  void deleteTech(int index, Event event) {
    decidedTechList.remove(decidedTechList[index]);
    isEdited = true;
    notifyListeners();
  }

  void setRule(Event event, bool isUnder16) {
    this.isUnder16 = isUnder16;
    isEdited = true;
    notifyListeners();
  }

  Future<void> getPerformanceData(String scoreId, Event event) async {
    if (event == Event.fx) {
      final fxScore = await performanceRepository.getFxPerformance(scoreId);
      decidedTechList = fxScore.techs;
      cv = fxScore.cv;
      isUnder16 = fxScore.isUnder16;
    }
    if (event == Event.ph) {
      final phScore = await performanceRepository.getPHPerformance(scoreId);
      decidedTechList = phScore.techs;
      isUnder16 = phScore.isUnder16;
    }
    if (event == Event.sr) {
      final srScore = await performanceRepository.getSRPerformance(scoreId);
      decidedTechList = srScore.techs;
      isUnder16 = srScore.isUnder16;
    }
    if (event == Event.pb) {
      final pbScore = await performanceRepository.getPBPerformance(scoreId);
      decidedTechList = pbScore.techs;
      isUnder16 = pbScore.isUnder16;
    }
    if (event == Event.hb) {
      final hbScore = await performanceRepository.getHBPerformance(scoreId);
      decidedTechList = hbScore.techs;
      cv = hbScore.cv;
      isUnder16 = hbScore.isUnder16;
    }
  }

  Future<void> setPerformance(Event event, bool isFirst) async {
    if (event == Event.fx) {
      await performanceRepository.setFxPerformance(
        calcTotalScore(event),
        decidedTechList,
        cv,
        isFirst,
        isUnder16,
      );
    }
    if (event == Event.ph) {
      await performanceRepository.setPhPerformance(
        calcTotalScore(event),
        decidedTechList,
        isFirst,
        isUnder16,
      );
    }
    if (event == Event.sr) {
      await performanceRepository.setSrPerformance(
        calcTotalScore(event),
        decidedTechList,
        isFirst,
        isUnder16,
      );
    }
    if (event == Event.pb) {
      await performanceRepository.setPbPerformance(
        calcTotalScore(event),
        decidedTechList,
        isFirst,
        isUnder16,
      );
    }
    if (event == Event.hb) {
      await performanceRepository.setHbPerformance(
        calcTotalScore(event),
        decidedTechList,
        cv,
        isFirst,
        isUnder16,
      );
    }
  }

  Future<void> updatePerformance(Event event, String scoreId) async {
    if (event == Event.fx) {
      await performanceRepository.updateFxPerformance(
        scoreId,
        calcTotalScore(event),
        decidedTechList,
        cv,
        isUnder16,
      );
    }
    if (event == Event.ph) {
      await performanceRepository.updatePhPerformance(
        scoreId,
        calcTotalScore(event),
        decidedTechList,
        isUnder16,
      );
    }
    if (event == Event.sr) {
      await performanceRepository.updateSrPerformance(
        scoreId,
        calcTotalScore(event),
        decidedTechList,
        isUnder16,
      );
    }
    if (event == Event.pb) {
      await performanceRepository.updatePbPerformance(
        scoreId,
        calcTotalScore(event),
        decidedTechList,
        isUnder16,
      );
    }
    if (event == Event.hb) {
      await performanceRepository.updateHbPerformance(
        scoreId,
        calcTotalScore(event),
        decidedTechList,
        cv,
        isUnder16,
      );
    }
  }

  void onCVSelected(num value) {
    cv = value;
    isEdited = true;
    notifyListeners();
  }

  int countGroup1(Event event) {
    final techs = decidedTechList
        .where((tech) => allGroupDataOf(event)[tech] == 1)
        .toList();
    return techs.length;
  }

  int countGroup2(Event event) {
    final techs = decidedTechList
        .where((tech) => allGroupDataOf(event)[tech] == 2)
        .toList();
    return techs.length;
  }

  int countGroup3(Event event) {
    final techs = decidedTechList
        .where((tech) => allGroupDataOf(event)[tech] == 3)
        .toList();
    return techs.length;
  }

  int difficultyGroup4(List<String> techList, Event event) {
    int difficulty = 0;
    for (final tech in techList) {
      if (event != Event.fx && allGroupDataOf(event)[tech] == 4) {
        difficulty = allDifficultyDataOf(event)[tech]!;
      }
    }
    return difficulty;
  }

  //要求点の計算
  num calculateEGR(Event event) {
    var egr = 0.0;

    if (decidedTechList.isEmpty) {
      egr = 0;
    } else {
      ///床の要求点の計算
      if (event == Event.fx) {
        final group1 = <String>[];
        final group2 = <String>[];
        final group3 = <String>[];
        for (final tech in decidedTechList) {
          switch (allGroupDataOf(event)[tech]) {
            case 1:
              group1.add(tech);
              break;
            case 2:
              group2.add(tech);
              break;
            case 3:
              group3.add(tech);
              break;
          }
        }

        if (group1.isNotEmpty && group2.isNotEmpty && group3.isNotEmpty) {
          egr = 1.5;
        } else if (group1.isNotEmpty && group2.isNotEmpty ||
            group1.isNotEmpty && group3.isNotEmpty ||
            group2.isNotEmpty && group3.isNotEmpty) {
          egr = 1.0;
        } else if (group1.isNotEmpty ||
            group2.isNotEmpty ||
            group3.isNotEmpty) {
          egr = 0.5;
        }
        //終末技
        if (allGroupDataOf(event)[decidedTechList.last]! != 1) {
          if (allDifficultyDataOf(event)[decidedTechList.last]! >= 4) {
            egr = egr * 10 + 5;
            egr /= 10;
          } else if (allDifficultyDataOf(event)[decidedTechList.last]! == 3) {
            egr = egr * 10 + 3;
            egr /= 10;
          } else if (isUnder16) {
            switch (allDifficultyDataOf(event)[decidedTechList.last]!) {
              case 2:
                egr = egr * 10 + 2;
                egr /= 10;
                break;
              case 1:
                egr = egr * 10 + 1;
                egr /= 10;
                break;
            }
          }
        }
      } else {
        ///床以外の要求点の計算
        final group1 = <String>[];
        final group2 = <String>[];
        final group3 = <String>[];
        var group4 = '';

        for (final tech in decidedTechList) {
          if (allGroupDataOf(event)[tech] == 1) {
            group1.add(tech);
          }
          if (allGroupDataOf(event)[tech] == 2) {
            group2.add(tech);
          }
          if (allGroupDataOf(event)[tech] == 3) {
            group3.add(tech);
          }
          if (allGroupDataOf(event)[tech] == 4) {
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
          if (allDifficultyDataOf(event)[group4]! >= 4) {
            egr = egr * 10 + 5;
            egr /= 10;
          } else if (allDifficultyDataOf(event)[group4] == 3) {
            egr = egr * 10 + 3;
            egr /= 10;
          } else if (isUnder16) {
            switch (allDifficultyDataOf(event)[group4]!) {
              case 2:
                egr = egr * 10 + 2;
                egr /= 10;
                break;
              case 1:
                egr = egr * 10 + 1;
                egr /= 10;
                break;
            }
          }
        }
      }
    }

    return egr;
  }

  //難度点の計算
  num calculateDifficulty(Event event) {
    var difficultyPoint = 0.0;

    if (decidedTechList.isNotEmpty) {
      for (final tech in decidedTechList) {
        difficultyPoint =
            difficultyPoint * 10 + allDifficultyDataOf(event)[tech]!;
        difficultyPoint /= 10;
      }
    }

    return difficultyPoint;
  }

  num calcTotalScore(Event event) {
    var egr = calculateEGR(event);
    var difficulty = calculateDifficulty(event);

    var tenTimesTotalScore = difficulty * 10 + egr * 10 + cv * 10;
    return tenTimesTotalScore / 10;
  }

  void onReOrder(int oldIndex, int newIndex, Event event) {
    final numberChangedTech = decidedTechList.removeAt(oldIndex);
    if (oldIndex < newIndex) {
      decidedTechList.insert(newIndex - 1, numberChangedTech);
    } else {
      decidedTechList.insert(newIndex, numberChangedTech);
    }
    isEdited = true;

    notifyListeners();
  }
}
