import 'package:cloud_firestore/cloud_firestore.dart';

class Tech {
  Tech(DocumentSnapshot doc) {
    techName = doc.data()!['techName'];
    techPoint = doc.data()!['techPoint'];
    group = doc.data()!['group'];
  }

  String techName = '';
  num techPoint = 0;
  int group = 1;
}
