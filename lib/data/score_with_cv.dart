import 'package:cloud_firestore/cloud_firestore.dart';

//床、鉄棒
class ScoreWithCV {
  ScoreWithCV(DocumentSnapshot doc) {
    total = doc.data()!['total'];
    cv = doc.data()!['cv'];
    egr = doc.data()!['egr'];
    isFavorite = doc.data()!['isFavorite'];
  }

  num total = 0;
  num cv = 0;
  num egr = 0;
  bool isFavorite = false;
}
