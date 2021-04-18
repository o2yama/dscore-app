import 'package:cloud_firestore/cloud_firestore.dart';

// あん馬、吊り輪、平行棒
class ScoreWithoutCV {
  ScoreWithoutCV(DocumentSnapshot doc) {
    total = doc.data()!['total'];
    egr = doc.data()!['egr'];
    isFavorite = doc.data()!['isFavorite'];
  }

  num total = 0;
  num egr = 0;
  bool isFavorite = false;
}
