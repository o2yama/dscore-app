import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, Color> themes = {
  'イエロー': Colors.yellow,
  'ブルー': Colors.blue,
  'インディゴ': Colors.indigo,
  'オレンジ': Colors.orange,
  'グレー': Colors.grey,
  'グリーン': Colors.green,
  'ピンク': Colors.pinkAccent,
  'ブラック': Colors.black,
};

class ThemeColorModel extends ChangeNotifier {
  Color themeColor = Colors.white;
  bool isSelected = false;

  Future<void> setThemeColor(String color) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('themeColor', '$color');
  }

  Future<void> getThemeColor() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    themeColor = themes[pref.getString('themeColor')] ?? Colors.yellow;
    notifyListeners();
  }
}
