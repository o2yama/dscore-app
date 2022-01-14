import 'package:dscore_app/domain/performance.dart';
import 'package:dscore_app/domain/performance_with_cv.dart';
import 'package:dscore_app/domain/vt_tech.dart';
import 'package:dscore_app/repository/performance_repository.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final performanceListModelProvider = ChangeNotifierProvider(
  (ref) => PerformanceListModel()..init(),
);

class PerformanceListModel extends ChangeNotifier {
  late final PerformanceRepository performanceRepository;

  List<PerformanceWithCV> fxPerformanceList = <PerformanceWithCV>[];
  List<Performance> phPerformanceList = <Performance>[];
  List<Performance> srPerformanceList = <Performance>[];
  VTTech? vtTech;
  List<Performance> pbPerformanceList = <Performance>[];
  List<PerformanceWithCV> hbPerformanceList = <PerformanceWithCV>[];

  init() {
    performanceRepository = PerformanceRepository();
  }

  Future<void> getPerformances(Event event) async {
    switch (event) {
      case Event.fx:
        fxPerformanceList = await performanceRepository.getFxPerformances();
        break;
      case Event.ph:
        phPerformanceList = await performanceRepository.getPhPerformances();
        break;
      case Event.sr:
        srPerformanceList = await performanceRepository.getSrPerformances();
        break;
      case Event.vt:
        break;
      case Event.pb:
        pbPerformanceList = await performanceRepository.getPBPerformances();
        break;
      case Event.hb:
        hbPerformanceList = await performanceRepository.getHBPerformances();
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

  ///お気に入り変更
  Future<void> onStarTapped(
      Event event, bool isFavorite, String scoreId) async {
    if (!isFavorite) {
      //1度全てのスコアをのisFavoriteをfalseにする
      await changeAllFavoriteToFalse(event);
    }

    await changeFavoriteState(scoreId, event, !isFavorite);

    notifyListeners();
  }

  Future<void> changeAllFavoriteToFalse(Event event) async {
    if (event == Event.fx) {
      for (final fxScore in fxPerformanceList) {
        await performanceRepository.updateFxFavorite(fxScore.scoreId, false);
      }
    }
    if (event == Event.ph) {
      for (final phScore in phPerformanceList) {
        await performanceRepository.updatePhFavorite(phScore.scoreId, false);
      }
    }
    if (event == Event.sr) {
      for (final srScore in srPerformanceList) {
        await performanceRepository.updateSrFavorite(srScore.scoreId, false);
      }
    }
    if (event == Event.pb) {
      for (final pbScore in pbPerformanceList) {
        await performanceRepository.updatePbFavorite(pbScore.scoreId, false);
      }
    }
    if (event == Event.hb) {
      for (final hbScore in hbPerformanceList) {
        await performanceRepository.updateHbFavorite(hbScore.scoreId, false);
      }
    }

    await getPerformances(event);

    notifyListeners();
  }

  Future<void> changeFavoriteState(
    String scoreId,
    Event event,
    bool isFavorite,
  ) async {
    if (event == Event.fx) {
      await performanceRepository.updateFxFavorite(scoreId, isFavorite);
    }
    if (event == Event.ph) {
      await performanceRepository.updatePhFavorite(scoreId, isFavorite);
    }
    if (event == Event.sr) {
      await performanceRepository.updateSrFavorite(scoreId, isFavorite);
    }
    if (event == Event.pb) {
      await performanceRepository.updatePbFavorite(scoreId, isFavorite);
    }
    if (event == Event.hb) {
      await performanceRepository.updateHbFavorite(scoreId, isFavorite);
    }
  }

  Future<void> deletePerformance(Event event, String scoreId) async {
    if (event == Event.fx) {
      await performanceRepository.deleteFxPerformance(scoreId);
    }
    if (event == Event.ph) {
      await performanceRepository.deletePhPerformance(scoreId);
    }
    if (event == Event.sr) {
      await performanceRepository.deleteSrPerformance(scoreId);
    }
    if (event == Event.pb) {
      await performanceRepository.deletePbPerformance(scoreId);
    }
    if (event == Event.hb) {
      await performanceRepository.deleteHbPerformance(scoreId);
    }
    await getPerformances(event);
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
