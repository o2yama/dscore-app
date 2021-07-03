import 'package:cloud_firestore/cloud_firestore.dart';

//床、鉄棒
class Score {
  Score(DocumentSnapshot doc) {
    total = doc.data()!['total'] as num;
    techs = List<String>.from(doc['components'] as List<dynamic>);
    scoreId = doc.data()!['scoreId'] as String;
    isFavorite = doc.data()!['isFavorite'] as bool;
    isUnder16 = doc.data()!['isUnder16'] as bool? ?? false;
  }

  num total = 0;
  List<String> techs = [];
  String scoreId = '';
  bool isFavorite = false;
  bool isUnder16 = false;
}
