import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dscore_app/domain/app_user.dart';
import 'package:dscore_app/domain/performance.dart';
import 'package:dscore_app/domain/performance_with_cv.dart';
import 'package:dscore_app/domain/vt_tech.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class PerformanceRepository {
  factory PerformanceRepository() => _cache;
  PerformanceRepository._internal();
  static final PerformanceRepository _cache = PerformanceRepository._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  AppUser? get currentUser => UserRepository().appUser;
  String uuid = '';

  void getUuid() {
    uuid = const Uuid().v4();
  }

  ///FavoritePerformanceの取得
  Future<PerformanceWithCV?> getStarFxPerformance() async {
    final performanceList = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .where('isFavorite', isEqualTo: true)
        .get();

    if (performanceList.size > 0) {
      return performanceList.docs
          .map((doc) => PerformanceWithCV(doc))
          .toList()[0];
    }
    return null;
  }

  Future<Performance?> getStarPhPerformance() async {
    final performanceList = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .where('isFavorite', isEqualTo: true)
        .get();
    if (performanceList.size > 0) {
      return performanceList.docs.map((doc) => Performance(doc)).toList()[0];
    }
    return null;
  }

  Future<Performance?> getStarSrPerformance() async {
    final performanceList = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .where('isFavorite', isEqualTo: true)
        .get();
    if (performanceList.size > 0) {
      return performanceList.docs.map((doc) => Performance(doc)).toList()[0];
    }
    return null;
  }

  Future<VTTech?> getVTPerformance() async {
    final techs = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('vt')
        .get();
    if (techs.size > 0) {
      return techs.docs.map((doc) => VTTech(doc)).toList()[0];
    }
    return null;
  }

  Future<Performance?> getStarPbPerformance() async {
    final performanceList = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .where('isFavorite', isEqualTo: true)
        .get();
    if (performanceList.size > 0) {
      return performanceList.docs.map((doc) => Performance(doc)).toList()[0];
    }
    return null;
  }

  Future<PerformanceWithCV?> getStarHbPerformance() async {
    final performanceList = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .where('isFavorite', isEqualTo: true)
        .get();
    if (performanceList.size > 0) {
      return performanceList.docs
          .map((doc) => PerformanceWithCV(doc))
          .toList()[0];
    }
    return null;
  }

  ///FavoriteScoreの更新
  Future<void> updateFxFavorite(String performanceId, bool isFavorite) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .doc(performanceId)
        .update(<String, dynamic>{'isFavorite': isFavorite});
  }

  Future<void> updatePhFavorite(String performanceId, bool isFavorite) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .doc(performanceId)
        .update(<String, dynamic>{'isFavorite': isFavorite});
  }

  Future<void> updateSrFavorite(String performanceId, bool isFavorite) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .doc(performanceId)
        .update(<String, dynamic>{'isFavorite': isFavorite});
  }

  Future<void> updatePbFavorite(String performanceId, bool isFavorite) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .doc(performanceId)
        .update(<String, dynamic>{'isFavorite': isFavorite});
  }

  Future<void> updateHbFavorite(String performanceId, bool isFavorite) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .doc(performanceId)
        .update(<String, dynamic>{'isFavorite': isFavorite});
  }

  ///各種目の監視
  List<PerformanceWithCV> watchFxScores() {
    var scoreList = <PerformanceWithCV>[];

    final snapshots = _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .snapshots();
    snapshots.listen((event) {
      scoreList = event.docs.map((doc) => PerformanceWithCV(doc)).toList();
    });

    return scoreList;
  }

  List<Performance> watchPhScores() {
    var scoreList = <Performance>[];

    final snapshots = _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .snapshots();
    snapshots.listen((snapshot) {
      scoreList = snapshot.docs.map((doc) => Performance(doc)).toList();
    });

    return scoreList;
  }

  List<Performance> watchSrScores() {
    var scoreList = <Performance>[];

    final snapshots = _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .snapshots();
    snapshots.listen((snapshot) {
      scoreList = snapshot.docs.map((doc) => Performance(doc)).toList();
    });

    return scoreList;
  }

  List<Performance> watchPbScores() {
    var scoreList = <Performance>[];

    final snapshots = _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .snapshots();
    snapshots.listen((snapshot) {
      scoreList = snapshot.docs.map((doc) => Performance(doc)).toList();
    });

    return scoreList;
  }

  List<PerformanceWithCV> watchHbScores() {
    var scoreList = <PerformanceWithCV>[];

    final snapshots = _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .snapshots();
    snapshots.listen((event) {
      scoreList = event.docs.map((doc) => PerformanceWithCV(doc)).toList();
    });

    return scoreList;
  }

  ///各種目の演技の取得
  Future<List<PerformanceWithCV>> getFxPerformances() async {
    final performances = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .get()
        .then(
          (query) => query.docs.map((doc) => PerformanceWithCV(doc)).toList(),
        );

    //お気に入りの演技を0番目にする処理
    return sortPWithCvList(performances);
  }

  Future<List<Performance>> getPhPerformances() async {
    final performances = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .get()
        .then(
          (query) => query.docs.map((doc) => Performance(doc)).toList(),
        );

    //お気に入りの演技を0番目にする処理
    return sortPList(performances);
  }

  Future<List<Performance>> getSrPerformances() async {
    final performances = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .get()
        .then(
          (query) => query.docs.map((doc) => Performance(doc)).toList(),
        );

    //お気に入りの演技を0番目にする処理
    return sortPList(performances);
  }

  Future<List<Performance>> getPBPerformances() async {
    final performances = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .get()
        .then(
          (query) => query.docs.map((doc) => Performance(doc)).toList(),
        );

    //お気に入りの演技を0番目にする処理
    return sortPList(performances);
  }

  Future<List<PerformanceWithCV>> getHBPerformances() async {
    final performances = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .get()
        .then(
          (query) => query.docs.map((doc) => PerformanceWithCV(doc)).toList(),
        );

    //お気に入りの演技を0番目にする処理
    return sortPWithCvList(performances);
  }

  List<Performance> sortPList(List<Performance> performances) {
    var performanceList = <Performance>[];

    final favoritePerformance =
        performances.where((score) => score.isFavorite).toList();
    if (favoritePerformance.isNotEmpty) {
      performanceList.add(favoritePerformance[0]);
    }

    final otherScores =
        performances.where((score) => !score.isFavorite).toList();
    for (var score in otherScores) {
      performanceList.add(score);
    }

    return performanceList;
  }

  List<PerformanceWithCV> sortPWithCvList(
      List<PerformanceWithCV> performances) {
    var performanceList = <PerformanceWithCV>[];

    final favoritePerformance =
        performances.where((score) => score.isFavorite).toList();
    if (favoritePerformance.isNotEmpty) {
      performanceList.add(favoritePerformance[0]);
    }

    final otherScores =
        performances.where((score) => !score.isFavorite).toList();
    for (var score in otherScores) {
      performanceList.add(score);
    }

    return performanceList;
  }

  ///演技単体の取得
  Future<PerformanceWithCV> getFxPerformance(String performanceId) async {
    final fxScore = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .doc(performanceId)
        .get()
        .then((doc) => PerformanceWithCV(doc));
    return fxScore;
  }

  Future<Performance> getPHPerformance(String performanceId) async {
    final phScore = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .doc(performanceId)
        .get()
        .then((doc) => Performance(doc));
    return phScore;
  }

  Future<Performance> getSRPerformance(String performanceId) async {
    final srScore = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .doc(performanceId)
        .get()
        .then((doc) => Performance(doc));
    return srScore;
  }

  Future<Performance> getPBPerformance(String performanceId) async {
    final pbScore = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .doc(performanceId)
        .get()
        .then((doc) => Performance(doc));
    return pbScore;
  }

  Future<PerformanceWithCV> getHBPerformance(String performanceId) async {
    final hbScore = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .doc(performanceId)
        .get()
        .then((doc) => PerformanceWithCV(doc));
    return hbScore;
  }

  ///演技の登録
  Future<void> setFxPerformance(
    num total,
    List<String> techList,
    num cv,
    bool isFavorite,
    bool? isUnder16,
  ) async {
    getUuid();
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .doc(uuid)
        .set(<String, dynamic>{
      'scoreId': uuid,
      'total': total,
      'components': techList,
      'isFavorite': isFavorite,
      'isUnder16': isUnder16,
      'cv': cv,
    });
  }

  Future<void> setPhPerformance(
    num total,
    List<String> techs,
    bool isFavorite,
    bool? isUnder16,
  ) async {
    getUuid();
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .doc(uuid)
        .set(<String, dynamic>{
      'scoreId': uuid,
      'total': total,
      'components': techs,
      'isFavorite': isFavorite,
      'isUnder16': isUnder16,
    });
  }

  Future<void> setSrPerformance(
    num total,
    List<String> techs,
    bool isFavorite,
    bool? isUnder16,
  ) async {
    getUuid();
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .doc(uuid)
        .set(<String, dynamic>{
      'scoreId': uuid,
      'total': total,
      'components': techs,
      'isFavorite': isFavorite,
      'isUnder16': isUnder16,
    });
  }

  Future<void> setPbPerformance(
    num total,
    List<String> techs,
    bool isFavorite,
    bool? isUnder16,
  ) async {
    getUuid();
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .doc(uuid)
        .set(<String, dynamic>{
      'scoreId': uuid,
      'total': total,
      'components': techs,
      'isFavorite': isFavorite,
      'isUnder16': isUnder16,
    });
  }

  Future<void> setHbPerformance(
    num total,
    List<String> techs,
    num cv,
    bool isFavorite,
    bool? isUnder16,
  ) async {
    getUuid();
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .doc(uuid)
        .set(<String, dynamic>{
      'scoreId': uuid,
      'total': total,
      'components': techs,
      'isFavorite': isFavorite,
      'isUnder16': isUnder16,
      'cv': cv,
    });
  }

  ///演技の更新
  Future<void> updateFxPerformance(
    String performanceId,
    num total,
    List<String> techs,
    num cv,
    bool? isUnder16,
  ) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .doc(performanceId)
        .update(<String, dynamic>{
      'total': total,
      'components': techs,
      'isUnder16': isUnder16,
      'cv': cv,
    });
  }

  Future<void> updatePhPerformance(
    String performanceId,
    num total,
    List<String> techs,
    bool? isUnder16,
  ) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .doc(performanceId)
        .update(<String, dynamic>{
      'total': total,
      'components': techs,
      'isUnder16': isUnder16,
    });
  }

  Future<void> updateSrPerformance(
    String performanceId,
    num total,
    List<String> techs,
    bool? isUnder16,
  ) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .doc(performanceId)
        .update(<String, dynamic>{
      'total': total,
      'components': techs,
      'isUnder16': isUnder16,
    });
  }

  Future<void> updatePbPerformance(
    String performanceId,
    num total,
    List<String> techs,
    bool? isUnder16,
  ) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .doc(performanceId)
        .update(<String, dynamic>{
      'total': total,
      'components': techs,
      'isUnder16': isUnder16,
    });
  }

  Future<void> updateHbPerformance(
    String performanceId,
    num total,
    List<String> techs,
    num cv,
    bool? isUnder16,
  ) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .doc(performanceId)
        .update(<String, dynamic>{
      'total': total,
      'components': techs,
      'isUnder16': isUnder16,
      'cv': cv,
    });
  }

  ///演技の削除

  Future<void> deleteFxPerformance(String performanceId) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .doc(performanceId)
        .delete();
  }

  Future<void> deletePhPerformance(String performanceId) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .doc(performanceId)
        .delete();
  }

  Future<void> deleteSrPerformance(String performanceId) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .doc(performanceId)
        .delete();
  }

  Future<void> deletePbPerformance(String performanceId) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .doc(performanceId)
        .delete();
  }

  Future<void> deleteHbPerformance(String performanceId) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .doc(performanceId)
        .delete();
  }

  ///跳馬の演技
  //初めてならset,それ以外はupdate
  //Userごとに1つでいいから、Userと同じidでOK
  Future<void> setVt(String techName, num score) async {
    final vtScore = await getVTPerformance();
    if (vtScore == null) {
      await _db
          .collection('users')
          .doc(currentUser!.id)
          .collection('vt')
          .doc(currentUser!.id)
          .set(<String, dynamic>{
        'scoreId': currentUser!.id,
        'score': score,
        'techName': techName,
      });
    } else {
      await _db
          .collection('users')
          .doc(currentUser!.id)
          .collection('vt')
          .doc(currentUser!.id)
          .update(<String, dynamic>{
        'score': score,
        'techName': techName,
      });
    }
  }
}
