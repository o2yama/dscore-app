import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  CurrentUser(DocumentSnapshot doc) {
    this.id = doc.data()!['id'];
  }

  String id = '';
}
