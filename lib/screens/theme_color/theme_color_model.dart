import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, Color?> themes = {
  'イエロー': Colors.yellow[700],
  'ブルー': Colors.blue,
  'インディゴ': Colors.indigo,
  'オレンジ': Colors.orange[700],
  'グレー': Colors.grey,
  'グリーン': Colors.green,
  'ピンク': Colors.pinkAccent,
  'ブラック': Colors.black,
};

final themeModelProvider = ChangeNotifierProvider((ref) => ThemeColorModel());

class ThemeColorModel extends ChangeNotifier {
  Color themeColor = Colors.white;

  Future<void> setThemeColor(String color) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('themeColor', color);
  }

  Future<void> getThemeColor() async {
    final pref = await SharedPreferences.getInstance();
    themeColor = (themes[pref.getString('themeColor')] ?? Colors.yellow[700])!;
    notifyListeners();
  }
}
