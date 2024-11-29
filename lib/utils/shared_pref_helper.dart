import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static final SharedPrefHelper instance = SharedPrefHelper._internal();

  factory SharedPrefHelper() => instance;

  SharedPrefHelper._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> saveString(String key, String value) async {
    if (_prefs == null) await init();
    return _prefs!.setString(key, value);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<bool> saveInt(String key, int value) async {
    if (_prefs == null) await init();
    return _prefs!.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  Future<bool> saveBool(String key, bool value) async {
    if (_prefs == null) await init();
    return _prefs!.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  Future<bool> removeString(String key) async {
    if (_prefs == null) await init();
    return _prefs!.remove(key);
  }
}