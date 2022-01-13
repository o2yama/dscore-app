import 'package:dscore_app/domain/performance.dart';
import 'package:dscore_app/domain/performance_with_cv.dart';
import 'package:dscore_app/domain/vt_tech.dart';
import 'package:dscore_app/repository/score_repository.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final performanceListModelProvider = ChangeNotifierProvider(
  (ref) => PerformanceListModel(),
);

class PerformanceListModel extends ChangeNotifier {
  final scoreRepository = ScoreRepository();

  List<PerformanceWithCV> fxPerformanceList = [];
  List<Performance> phPerformanceList = [];
  List<Performance> srPerformanceList = [];
  VTTech? vtTech;
  List<Performance> pbPerformanceList = [];
  List<PerformanceWithCV> hbPerformanceList = [];

  Future<void> getPerformances(Event event) async {
    switch (event) {
      case Event.fx:
        fxPerformanceList = await scoreRepository.getFxPerformances();
        break;
      case Event.ph:
        phPerformanceList = await scoreRepository.getPhPerformances();
        break;
      case Event.sr:
        srPerformanceList = await scoreRepository.getSrPerformances();
        break;
      case Event.vt:
        break;
      case Event.pb:
        pbPerformanceList = await scoreRepository.getPBPerformances();
        break;
      case Event.hb:
        hbPerformanceList = await scoreRepository.getHBPerformances();
        break;
    }
  }

  List performanceList(Event event) {
    switch (event) {
      case Event.fx:
        return fxPerformanceList;
      case Event.ph:
        return phPerformanceList;
      case Event.sr:
        return srPerformanceList;
      case Event.pb:
        return pbPerformanceList;
      case Event.hb:
        return hbPerformanceList;
      case Event.vt:
        return [];
    }
  }

  //お気に入り変更するため
  Future<List<String>> getScoreIds(Event event) async {
    var scoreIds = <String>[];
    if (event == Event.fx) {
      for (final fxScore in fxPerformanceList) {
        scoreIds.add(fxScore.scoreId);
      }
    }
    if (event == Event.pb) {
      for (final phScore in phPerformanceList) {
        scoreIds.add(phScore.scoreId);
      }
    }
    if (event == Event.sr) {
      for (final srScore in srPerformanceList) {
        scoreIds.add(srScore.scoreId);
      }
    }
    if (event == Event.pb) {
      for (final pbScore in pbPerformanceList) {
        scoreIds.add(pbScore.scoreId);
      }
    }
    if (event == Event.hb) {
      for (final hbScore in hbPerformanceList) {
        scoreIds.add(hbScore.scoreId);
      }
    }

    return scoreIds;
  }

  Future<void> onStarTapped(
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

    // await getScores(event);
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
    // await getScores(event);
    notifyListeners();
  }

  //ログアウト時
  void resetScores() {
    fxPerformanceList = [];
    phPerformanceList = [];
    srPerformanceList = [];
    vtTech = null;
    pbPerformanceList = [];
    hbPerformanceList = [];
    notifyListeners();
  }
}
