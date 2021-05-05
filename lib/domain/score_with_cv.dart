import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreWithCV {
  ScoreWithCV(DocumentSnapshot doc) {
    total = doc.data()!['total'];
    techs = List.from(doc['components']);
    cv = doc.data()!['cv'];
    isFavorite = isFavorite = doc.data()!['isFavorite'];
  }

  num total = 0;
  List<String> techs = [];
  num cv = 0;
  bool isFavorite = false;
}
