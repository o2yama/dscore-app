import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  CurrentUser(DocumentSnapshot doc) {
    this.id = doc.data()!['id'];
    this.email = doc.data()!['email'];
  }

  String id = '';
  String? email;
}
