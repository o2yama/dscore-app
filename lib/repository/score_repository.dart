import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/domain/performance.dart';
import 'package:dscore_app/domain/performance_with_cv.dart';
import 'package:dscore_app/domain/vt_tech.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class ScoreRepository {
  factory ScoreRepository() => _cache;
  ScoreRepository._internal();
  static final ScoreRepository _cache = ScoreRepository._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  AppUser? get currentUser => UserRepository().appUser;
  String uuid = '';

  void getUuid() {
    uuid = const Uuid().v4();
  }

  ///FavoriteScoreの取得
  Future<PerformanceWithCV?> getFavoriteFXScore() async {
    final scoreList = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .where('isFavorite', isEqualTo: true)
        .get();

    if (scoreList.size > 0) {
      return scoreList.docs.map((doc) => PerformanceWithCV(doc)).toList()[0];
    }
  }

  Future<Performance?> getFavoritePHScore() async {
    final scoreList = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .where('isFavorite', isEqualTo: true)
        .get();
    if (scoreList.size > 0) {
      return scoreList.docs.map((doc) => Performance(doc)).toList()[0];
    }
  }

  Future<Performance?> getFavoriteSRScore() async {
    final scoreList = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .where('isFavorite', isEqualTo: true)
        .get();
    if (scoreList.size > 0) {
      return scoreList.docs.map((doc) => Performance(doc)).toList()[0];
    }
  }

  Future<VTTech?> getVTScore() async {
    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('vt')
        .get();
    if (scores.size > 0) {
      return scores.docs.map((doc) => VTTech(doc)).toList()[0];
    }
  }

  Future<Performance?> getFavoritePBScore() async {
    final scoreList = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .where('isFavorite', isEqualTo: true)
        .get();
    if (scoreList.size > 0) {
      return scoreList.docs.map((doc) => Performance(doc)).toList()[0];
    }
  }

  Future<PerformanceWithCV?> getFavoriteHBScore() async {
    final scoreList = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .where('isFavorite', isEqualTo: true)
        .get();
    if (scoreList.size > 0) {
      return scoreList.docs.map((doc) => PerformanceWithCV(doc)).toList()[0];
    }
  }

  ///FavoriteScoreの更新
  Future<void> favoriteFXUpdate(String scoreId, bool isFavorite) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .doc(scoreId)
        .update(<String, dynamic>{'isFavorite': isFavorite});
  }

  Future<void> favoritePHUpdate(String scoreId, bool isFavorite) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .doc(scoreId)
        .update(<String, dynamic>{'isFavorite': isFavorite});
  }

  Future<void> favoriteSRUpdate(String scoreId, bool isFavorite) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .doc(scoreId)
        .update(<String, dynamic>{'isFavorite': isFavorite});
  }

  Future<void> favoritePBUpdate(String scoreId, bool isFavorite) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .doc(scoreId)
        .update(<String, dynamic>{'isFavorite': isFavorite});
  }

  Future<void> favoriteHBUpdate(String scoreId, bool isFavorite) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .doc(scoreId)
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
    var scoreList = <PerformanceWithCV>[];

    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .get()
        .then(
          (query) => query.docs.map((doc) => PerformanceWithCV(doc)).toList(),
        );

    //お気に入りの演技を0番目にする
    scoreList.add(scores.where((score) => score.isFavorite).toList()[0]);

    final otherScores = scores.where((score) => !score.isFavorite).toList();
    for (var score in otherScores) {
      scoreList.add(score);
    }

    return scoreList;
  }

  Future<List<Performance>> getPhPerformances() async {
    var scoreList = <Performance>[];

    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .get()
        .then(
          (query) => query.docs.map((doc) => Performance(doc)).toList(),
        );

    //お気に入りの演技を0番目にする
    scoreList.add(scores.where((score) => score.isFavorite).toList()[0]);

    final otherScores = scores.where((score) => !score.isFavorite).toList();
    for (var score in otherScores) {
      scoreList.add(score);
    }

    return scoreList;
  }

  Future<List<Performance>> getSrPerformances() async {
    var scoreList = <Performance>[];

    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .get()
        .then(
          (query) => query.docs.map((doc) => Performance(doc)).toList(),
        );

    //お気に入りの演技を0番目にする
    scoreList.add(scores.where((score) => score.isFavorite).toList()[0]);

    final otherScores = scores.where((score) => !score.isFavorite).toList();
    for (var score in otherScores) {
      scoreList.add(score);
    }

    return scoreList;
  }

  Future<List<Performance>> getPBPerformances() async {
    var scoreList = <Performance>[];

    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .get()
        .then(
          (query) => query.docs.map((doc) => Performance(doc)).toList(),
        );

    //お気に入りの演技を0番目にする
    scoreList.add(scores.where((score) => score.isFavorite).toList()[0]);

    final otherScores = scores.where((score) => !score.isFavorite).toList();
    for (var score in otherScores) {
      scoreList.add(score);
    }

    return scoreList;
  }

  Future<List<PerformanceWithCV>> getHBPerformances() async {
    var scoreList = <PerformanceWithCV>[];

    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .get()
        .then(
          (query) => query.docs.map((doc) => PerformanceWithCV(doc)).toList(),
        );

    //お気に入りの演技を0番目にする
    scoreList.add(scores.where((score) => score.isFavorite).toList()[0]);

    final otherScores = scores.where((score) => !score.isFavorite).toList();
    for (var score in otherScores) {
      scoreList.add(score);
    }

    return scoreList;
  }

  ///演技単体の取得
  Future<PerformanceWithCV> getFxPerformance(String scoreId) async {
    final fxScore = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .doc(scoreId)
        .get()
        .then((doc) => PerformanceWithCV(doc));
    return fxScore;
  }

  Future<Performance> getPHPerformance(String scoreId) async {
    final phScore = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .doc(scoreId)
        .get()
        .then((doc) => Performance(doc));
    return phScore;
  }

  Future<Performance> getSRPerformance(String scoreId) async {
    final srScore = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .doc(scoreId)
        .get()
        .then((doc) => Performance(doc));
    return srScore;
  }

  Future<Performance> getPBPerformance(String scoreId) async {
    final pbScore = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .doc(scoreId)
        .get()
        .then((doc) => Performance(doc));
    return pbScore;
  }

  Future<PerformanceWithCV> getHBPerformance(String scoreId) async {
    final hbScore = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .doc(scoreId)
        .get()
        .then((doc) => PerformanceWithCV(doc));
    return hbScore;
  }

  ///演技の登録
  Future<void> setFXScore(
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

  Future<void> setPHScore(
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

  Future<void> setSRScore(
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

  Future<void> setPBScore(
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

  Future<void> setHBScore(
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
  Future<void> updateFXScore(
    String scoreId,
    num total,
    List<String> techs,
    num cv,
    bool? isUnder16,
  ) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .doc(scoreId)
        .update(<String, dynamic>{
      'total': total,
      'components': techs,
      'isUnder16': isUnder16,
      'cv': cv,
    });
  }

  Future<void> updatePHScore(
    String scoreId,
    num total,
    List<String> techs,
    bool? isUnder16,
  ) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .doc(scoreId)
        .update(<String, dynamic>{
      'total': total,
      'components': techs,
      'isUnder16': isUnder16,
    });
  }

  Future<void> updateSRScore(
    String scoreId,
    num total,
    List<String> techs,
    bool? isUnder16,
  ) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .doc(scoreId)
        .update(<String, dynamic>{
      'total': total,
      'components': techs,
      'isUnder16': isUnder16,
    });
  }

  Future<void> updatePBScore(
    String scoreId,
    num total,
    List<String> techs,
    bool? isUnder16,
  ) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .doc(scoreId)
        .update(<String, dynamic>{
      'total': total,
      'components': techs,
      'isUnder16': isUnder16,
    });
  }

  Future<void> updateHBScore(
    String scoreId,
    num total,
    List<String> techs,
    num cv,
    bool? isUnder16,
  ) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .doc(scoreId)
        .update(<String, dynamic>{
      'total': total,
      'components': techs,
      'isUnder16': isUnder16,
      'cv': cv,
    });
  }

  ///演技の削除

  Future<void> deleteFXScore(String scoreId) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .doc(scoreId)
        .delete();
  }

  Future<void> deletePHScore(String scoreId) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .doc(scoreId)
        .delete();
  }

  Future<void> deleteSRScore(String scoreId) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .doc(scoreId)
        .delete();
  }

  Future<void> deletePBScore(String scoreId) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .doc(scoreId)
        .delete();
  }

  Future<void> deleteHBScore(String scoreId) async {
    await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .doc(scoreId)
        .delete();
  }

  ///跳馬の演技
  //初めてならset,それ以外はupdate
  //Userごとに1つでいいから、Userと同じidでOK
  Future<void> setVTScore(String techName, num score) async {
    final vtScore = await getVTScore();
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
