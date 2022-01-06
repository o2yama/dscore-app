import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/domain/score.dart';
import 'package:dscore_app/domain/score_with_cv.dart';
import 'package:dscore_app/domain/vt_score.dart';
import 'package:dscore_app/repository/score_repository.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final performanceListModelProvider =
    ChangeNotifierProvider((ref) => PerformanceListModel());

class PerformanceListModel extends ChangeNotifier {
  final scoreRepository = ScoreRepository();
  CurrentUser? get currentUser => UserRepository.currentUser;

  List<ScoreWithCV> fxScoreList = [];
  List<Score> phScoreList = [];
  List<Score> srScoreList = [];
  VTScore? vtScore;
  List<Score> pbScoreList = [];
  List<ScoreWithCV> hbScoreList = [];

  Future<void> getScores(Event event) async {
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
  }

  List scoreList(Event event) {
    switch (event) {
      case Event.fx:
        return fxScoreList;
      case Event.ph:
        return phScoreList;
      case Event.sr:
        return srScoreList;
      case Event.pb:
        return pbScoreList;
      case Event.hb:
        return hbScoreList;
      case Event.vt:
        return [];
    }
  }

  //お気に入り変更するため
  Future<List<String>> getScoreIds(Event event) async {
    var scoreIds = <String>[];
    if (event == Event.fx) {
      for (final fxScore in fxScoreList) {
        scoreIds.add(fxScore.scoreId);
      }
    }
    if (event == Event.pb) {
      for (final phScore in phScoreList) {
        scoreIds.add(phScore.scoreId);
      }
    }
    if (event == Event.sr) {
      for (final srScore in srScoreList) {
        scoreIds.add(srScore.scoreId);
      }
    }
    if (event == Event.pb) {
      for (final pbScore in pbScoreList) {
        scoreIds.add(pbScore.scoreId);
      }
    }
    if (event == Event.hb) {
      for (final hbScore in hbScoreList) {
        scoreIds.add(hbScore.scoreId);
      }
    }

    return scoreIds;
  }

  Future<void> onFavoriteButtonTapped(
    Event event,
    bool isFavorite,
    String scoreId,
  ) async {
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
  }

  Future<void> changeFavoriteState(
    String scoreId,
    Event event,
    bool isFavorite,
  ) async {
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
}
