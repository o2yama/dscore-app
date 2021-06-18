import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreWithCV {
  ScoreWithCV(DocumentSnapshot doc) {
    total = doc.data()!['total'] as num;
    techs = List<String>.from(doc['components'] as List<dynamic>);
    cv = doc.data()!['cv'] as num;
    scoreId = doc.data()!['scoreId'] as String;
    isFavorite = isFavorite = doc.data()!['isFavorite'] as bool;
  }

  num total = 0;
  List<String> techs = [];
  num cv = 0;
  String scoreId = '';
  bool isFavorite = false;
}
