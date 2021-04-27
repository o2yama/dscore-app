import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dscore_app/data/current_user.dart';
import 'package:dscore_app/data/score.dart';
import 'package:dscore_app/repository/user_repository.dart';

class ScoreRepository {
  CurrentUser? get currentUser => UserRepository.currentUser;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Score>> getFxScores() async {
    final scores = await _db
        .collection('users')
        .doc(currentUser!.id)
        .collection('fx')
        .get();
    List<Score> scoreList = scores.docs.map((doc) => Score(doc)).toList();
    return scoreList;
  }
}
