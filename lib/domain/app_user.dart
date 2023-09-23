import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser(DocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc.data()!['id'] as String;
    email = doc.data()!['email'] as String;
    isAdmin = doc.data()!['isAdmin'] ?? false;
  }

  String id = '';
  String email = '';
  bool isAdmin = false;
}
