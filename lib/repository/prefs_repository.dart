import 'package:shared_preferences/shared_preferences.dart';

class PrefsRepository {
  factory PrefsRepository() => _cache;
  PrefsRepository._internal();
  static final PrefsRepository _cache = PrefsRepository._internal();

  late final SharedPreferences _prefs;

  Future<void> getInstance() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setAttPermission(bool inPermitted) async {
    await _prefs.setBool('att', inPermitted);
  }

  bool getAttPermission() {
    return _prefs.getBool('att') ?? false;
  }
}
