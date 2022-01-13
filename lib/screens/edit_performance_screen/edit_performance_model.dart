import 'package:dscore_app/data/fx.dart';
import 'package:dscore_app/data/hb.dart';
import 'package:dscore_app/data/pb.dart';
import 'package:dscore_app/data/ph.dart';
import 'package:dscore_app/data/sr.dart';
import 'package:dscore_app/data/vt.dart';
import 'package:dscore_app/repository/performance_repository.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editPerformanceModelProvider = ChangeNotifierProvider(
  (ref) => EditPerformanceModel()..init(),
);

class EditPerformanceModel extends ChangeNotifier {
  late final PerformanceRepository performanceRepository;

  bool isEdited = false;
  List<String> decidedTechList = [];
  num totalScore = 0.0;
  num difficultyPoint = 0.0;
  num egr = 0.0;
  num cv = 0.0;
  bool isUnder16 = false; //高校生ルールかどうか

  init() => performanceRepository = PerformanceRepository();

  Map<String, num> difficultyData(Event event) {
    switch (event) {
      case Event.fx:
        return fxDifficulty;
      case Event.ph:
        return phDifficulty;
      case Event.sr:
        return srDifficulty;
      case Event.vt:
        return vtTechs;
      case Event.pb:
        return pbDifficulty;
      case Event.hb:
        return hbDifficulty;
    }
  }

  Map<String, int> groupData(Event event) {
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

  List<String> searchWords(Event event) {
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
    totalScore = 0.0;
    difficultyPoint = 0.0;
    egr = 0.0;
    cv = 0.0;
    notifyListeners();
  }

  void deleteTech(int index, Event event) {
    decidedTechList.remove(decidedTechList[index]);
    isEdited = true;
    calculateScore(decidedTechList, isUnder16, event);
    notifyListeners();
  }

  void setRule(Event event, bool isUnder16) {
    this.isUnder16 = isUnder16;
    calculateScore(decidedTechList, isUnder16, event);
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
    calculateScore(decidedTechList, isUnder16, event);
  }

  Future<void> setPerformance(Event event, bool isFirst) async {
    if (event == Event.fx) {
      await performanceRepository.setFxPerformance(
          totalScore, decidedTechList, cv, isFirst, isUnder16);
    }
    if (event == Event.ph) {
      await performanceRepository.setPhPerformance(
          totalScore, decidedTechList, isFirst, isUnder16);
    }
    if (event == Event.sr) {
      await performanceRepository.setSrPerformance(
          totalScore, decidedTechList, isFirst, isUnder16);
    }
    if (event == Event.pb) {
      await performanceRepository.setPbPerformance(
          totalScore, decidedTechList, isFirst, isUnder16);
    }
    if (event == Event.hb) {
      await performanceRepository.setHbPerformance(
          totalScore, decidedTechList, cv, isFirst, isUnder16);
    }
  }

  Future<void> updatePerformance(Event event, String scoreId) async {
    if (event == Event.fx) {
      await performanceRepository.updateFxPerformance(
          scoreId, totalScore, decidedTechList, cv, isUnder16);
    }
    if (event == Event.ph) {
      await performanceRepository.updatePhPerformance(
          scoreId, totalScore, decidedTechList, isUnder16);
    }
    if (event == Event.sr) {
      await performanceRepository.updateSrPerformance(
          scoreId, totalScore, decidedTechList, isUnder16);
    }
    if (event == Event.pb) {
      await performanceRepository.updatePbPerformance(
          scoreId, totalScore, decidedTechList, isUnder16);
    }
    if (event == Event.hb) {
      await performanceRepository.updateHbPerformance(
          scoreId, totalScore, decidedTechList, cv, isUnder16);
    }
  }

  void onCVSelected(num value) {
    cv = value;
    isEdited = true;
    notifyListeners();
  }

  int countGroup1(List<String> techList, Event event) {
    final techs = techList
        .where(
          (tech) => groupData(event)[tech] == 1,
        )
        .toList();
    return techs.length;
  }

  int countGroup2(List<String> techList, Event event) {
    final techs = techList
        .where(
          (tech) => groupData(event)[tech] == 2,
        )
        .toList();
    return techs.length;
  }

  int countGroup3(List<String> techList, Event event) {
    final techs = techList
        .where(
          (tech) => groupData(event)[tech] == 3,
        )
        .toList();
    return techs.length;
  }

  num difficultyGroup4(List<String> techList, Event event) {
    num difficulty = 0;
    for (final tech in techList) {
      if (event != Event.fx && groupData(event)[tech] == 4) {
        difficulty = difficultyData(event)[tech]!;
      }
    }
    return difficulty;
  }

  //要求点の計算
  num calculateEGR(List<String> techList, bool isUnder16, Event event) {
    var egr = 0.0;

    if (techList.isEmpty) {
      egr = 0;
    } else {
      if (event == Event.fx) {
        //床の要求点の計算
        final group1 = <String>[];
        final group2 = <String>[];
        final group3 = <String>[];
        for (final tech in techList) {
          switch (groupData(event)[tech]) {
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
        if (groupData(event)[techList.last]! != 1) {
          switch (difficultyData(event)[techList.last]!) {
            case 4:
              egr = egr * 10 + 5;
              egr /= 10;
              break;
            case 3:
              egr = egr * 10 + 3;
              egr /= 10;
              break;
          }

          if (isUnder16) {
            switch (difficultyData(event)[techList.last]!) {
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
        //床以外の要求点の計算
        final group1 = <String>[];
        final group2 = <String>[];
        final group3 = <String>[];
        var group4 = '';

        for (final tech in techList) {
          if (groupData(event)[tech] == 1) {
            group1.add(tech);
          }
          if (groupData(event)[tech] == 2) {
            group2.add(tech);
          }
          if (groupData(event)[tech] == 3) {
            group3.add(tech);
          }
          if (groupData(event)[tech] == 4) {
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
          switch (difficultyData(event)[group4]!) {
            case 4:
              egr = egr * 10 + 5;
              egr /= 10;
              break;
            case 3:
              egr = egr * 10 + 3;
              egr /= 10;
              break;
          }
          if (isUnder16) {
            switch (difficultyData(event)[group4]!) {
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
  num calculateDifficulty(List<String> techList, Event event) {
    var difficultyPoint = 0.0;

    if (techList.isNotEmpty) {
      for (final tech in techList) {
        difficultyPoint = difficultyPoint * 10 + difficultyData(event)[tech]!;
        difficultyPoint /= 10;
      }
    }

    return difficultyPoint;
  }

  //Dスコア計算
  num calcTotalScore(List<String> techList, bool isUnder16, Event event) {
    var egr = calculateEGR(techList, isUnder16, event);
    var difficulty = calculateDifficulty(techList, event);

    var tenTimesTotalScore = difficulty * 10 + egr * 10 + cv * 10;
    return tenTimesTotalScore / 10;
  }

  void calculateScore(List<String> techList, bool isUnder16, Event event) {
    egr = calculateEGR(techList, isUnder16, event);
    difficultyPoint = calculateDifficulty(techList, event);

    totalScore = difficultyPoint * 10 + egr * 10 + cv * 10;
    totalScore /= 10;

    notifyListeners();
  }

  void onReOrder(int oldIndex, int newIndex, Event event) {
    final numberChangedTech = decidedTechList.removeAt(oldIndex);
    if (oldIndex < newIndex) {
      decidedTechList.insert(newIndex - 1, numberChangedTech);
    } else {
      decidedTechList.insert(newIndex, numberChangedTech);
    }
    calculateScore(decidedTechList, isUnder16, event);
    isEdited = true;

    notifyListeners();
  }
}
