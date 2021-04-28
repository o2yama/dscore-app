import 'package:cloud_firestore/cloud_firestore.dart';

class VTScore {
  VTScore(DocumentSnapshot doc) {
    score = doc.data()!['score'];
    techName = doc.data()!['techName'];
    isFavorite = doc.data()!['isFavorite'];
  }

  num score = 0;
  String techName = '';
  bool isFavorite = false;
}
