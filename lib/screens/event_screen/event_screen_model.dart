import 'package:flutter/material.dart';

class EventScreenModel extends ChangeNotifier {
  bool isFavorite = false;
  String dropDownValue = 'one';

  Future<bool> getIsFavorite() async {
    return false;
  }

  void onFavoriteButtonTapped() {
    if (isFavorite) {
      isFavorite = false;
    } else {
      isFavorite = true;
    }
    notifyListeners();
  }
}
