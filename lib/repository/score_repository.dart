import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/domain/score.dart';
import 'package:dscore_app/domain/score_with_cv.dart';
import 'package:dscore_app/domain/vt_score.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class ScoreRepository {
  CurrentUser? get currentUser => UserRepository.currentUser;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  String uuid = '';

  Future<void> getUuid() async {
    uuid = Uuid().v4();
  }

  Future<List<ScoreWithCV>> getFXScores() async {
    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .get();
    List<ScoreWithCV> scoreList =
        scores.docs.map((doc) => ScoreWithCV(doc)).toList();
    return scoreList;
  }

  Future<List<Score>> getPHScores() async {
    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('ph')
        .get();
    List<Score> scoreList = scores.docs.map((doc) => Score(doc)).toList();
    return scoreList;
  }

  Future<List<Score>> getSRScores() async {
    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('sr')
        .get();
    List<Score> scoreList = scores.docs.map((doc) => Score(doc)).toList();
    return scoreList;
  }

  Future<List<Score>> getPBScores() async {
    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('pb')
        .get();
    List<Score> scoreList = scores.docs.map((doc) => Score(doc)).toList();
    return scoreList;
  }

  Future<List<ScoreWithCV>> getHBScores() async {
    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .get();
    List<ScoreWithCV> scoreList =
        scores.docs.map((doc) => ScoreWithCV(doc)).toList();
    return scoreList;
  }

  Future<VTScore?> getVTScore() async {
    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('vt')
        .get();
    VTScore score = scores.docs.map((doc) => VTScore(doc)).toList()[0];
    return score;
  }

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
          .set({
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
          .update({
        'score': score,
        'techName': techName,
      });
    }
  }
}
