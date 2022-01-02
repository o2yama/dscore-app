import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  CurrentUser(DocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc.data()!['id'] as String;
    email = doc.data()!['email'] as String;
  }

  String id = '';
  String email = '';
}
