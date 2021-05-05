import 'package:dscore_app/domain/vt_score.dart';
import 'package:dscore_app/repository/score_repository.dart';
import 'package:flutter/cupertino.dart';

class TotalScoreListModel extends ChangeNotifier {
  TotalScoreListModel({required this.scoreRepository});
  ScoreRepository scoreRepository;

  bool isLoading = false;

  VTScore? vtScore;

  Future<void> getVTScores() async {
    isLoading = true;
    notifyListeners();

    vtScore = await scoreRepository.getVTScore();

    isLoading = false;
    notifyListeners();
  }
}
