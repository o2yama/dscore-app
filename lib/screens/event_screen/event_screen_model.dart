import 'package:flutter/material.dart';

class EventScreenModel extends ChangeNotifier {
  bool isFavorite = false;
  String dropDownValue = 'one';

  void onFavoriteButtonTapped() {
    if (isFavorite) {
      isFavorite = false;
    } else {
      isFavorite = true;
    }
    notifyListeners();
  }
}
