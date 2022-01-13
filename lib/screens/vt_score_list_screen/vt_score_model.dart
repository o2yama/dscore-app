import 'package:dscore_app/data/vt.dart';
import 'package:dscore_app/repository/performance_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vtScoreModelProvider = ChangeNotifierProvider((ref) => VtScoreModel());

class VtScoreModel extends ChangeNotifier {
  final performanceRepository = PerformanceRepository();

  String techName = '';
  num difficulty = 0.0;

  Future<void> getVTScore() async {
    final vtScore = await performanceRepository.getVTPerformance();
    if (vtScore != null) {
      techName = vtScore.techName;
      difficulty = vtTech[techName]!;
    }
  }

  void onVTTechSelected(int index) {
    final vtTechList = vtTech.keys.map((tech) => tech.toString()).toList();
    techName = vtTechList[index];
    difficulty = vtTech[techName]!;
    notifyListeners();
  }

  Future<void> setVTScore() async {
    await performanceRepository.setVt(techName, difficulty);
  }
}
