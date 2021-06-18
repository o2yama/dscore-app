import 'package:cloud_firestore/cloud_firestore.dart';

class VTScore {
  VTScore(DocumentSnapshot doc) {
    score = doc.data()!['score'] as num;
    techName = doc.data()!['techName'] as String;
    scoreId = doc.data()!['scoreId'] as String;
  }

  num score = 0;
  String techName = '';
  String scoreId = '';
}
