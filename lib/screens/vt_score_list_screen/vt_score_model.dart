import 'package:dscore_app/data/vt.dart';
import 'package:dscore_app/repository/performance_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vtScoreModelProvider = ChangeNotifierProvider(
  (ref) => VtScoreModel()..init(),
);

class VtScoreModel extends ChangeNotifier {
  late final PerformanceRepository performanceRepository;

  String techName = '';
  num difficulty = 0.0;

  init() {
    performanceRepository = PerformanceRepository();
  }

  Future<void> getVTScore() async {
    final vtScore = await performanceRepository.getVTPerformance();
    if (vtScore != null) {
      techName = vtScore.techName;
      difficulty = vtTechs[techName]!;
    }
  }

  void onVTTechSelected(int index) {
    final vtTechList = vtTechs.keys.map((tech) => tech.toString()).toList();
    techName = vtTechList[index];
    difficulty = vtTechs[techName]!;
    notifyListeners();
  }

  Future<void> setVTScore() async {
    await performanceRepository.setVt(techName, difficulty);
  }
}
