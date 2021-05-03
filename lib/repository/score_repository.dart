import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dscore_app/domain/current_user.dart';
import 'package:dscore_app/domain/score.dart';
import 'package:dscore_app/domain/vt_score.dart';
import 'package:dscore_app/repository/user_repository.dart';

class ScoreRepository {
  CurrentUser? get currentUser => UserRepository.currentUser;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Score>> getFXScores() async {
    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .get();
    List<Score> scoreList = scores.docs.map((doc) => Score(doc)).toList();
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

  Future<List<VTScore>> getVTScores() async {
    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('vt')
        .get();
    List<VTScore> scoreList = scores.docs.map((doc) => VTScore(doc)).toList();
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

  Future<List<Score>> getHBScores() async {
    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('hb')
        .get();
    List<Score> scoreList = scores.docs.map((doc) => Score(doc)).toList();
    return scoreList;
  }
}
