import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticatedUser {
  AuthenticatedUser(DocumentSnapshot doc) {
    this.id = doc.data()!['id'];
    this.email = doc.data()!['email'];
    this.password = doc.data()!['password'];
  }

  String id = '';
  String? email;
  String? password;
}
