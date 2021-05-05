import 'package:cloud_firestore/cloud_firestore.dart';

//床、鉄棒
class Score {
  Score(DocumentSnapshot doc) {
    total = doc.data()!['total'];
    techs = List.from(doc['components']);
    id = doc.data()!['scoreId'];
    isFavorite = isFavorite = doc.data()!['isFavorite'];
  }

  num total = 0;
  List<String> techs = [];
  String id = '';
  bool isFavorite = false;
}
