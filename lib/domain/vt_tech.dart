import 'package:cloud_firestore/cloud_firestore.dart';

class VTTech {
  VTTech(DocumentSnapshot<Map<String, dynamic>> doc) {
    techName = doc.data()!['techName'] as String;
    scoreId = doc.data()!['scoreId'] as String;
  }

  String techName = '';
  String scoreId = '';
}
