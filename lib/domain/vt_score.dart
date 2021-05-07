import 'package:cloud_firestore/cloud_firestore.dart';

class VTScore {
  VTScore(DocumentSnapshot doc) {
    score = doc.data()!['score'];
    techName = doc.data()!['techName'];
    id = doc.data()!['scoreId'];
  }

  num score = 0;
  String techName = '';
  String id = '';
}
