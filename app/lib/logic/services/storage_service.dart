import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageService {
  static late final SharedPreferences _storage;

  static Future<void> init() async {
    _storage = await SharedPreferences.getInstance();
  }

  static bool getBoolSync({
    required String key,
    bool defaultValue = false,
  }) {
    final bool value = _storage.getBool(key) ?? defaultValue;
    return value;
  }

  static Future<void> setBool({
    required String key,
    required bool value,
  }) async {
    await _storage.setBool(key, value);
  }

  static String? getString({
    required String key,
    String? defaultValue,
  }) {
    final String? value = _storage.getString(key) ?? defaultValue;
    return value;
  }

  static Future<void> setString({
    required String key,
    required String value,
  }) async {
    await _storage.setString(key, value);
  }

  static List<String>? getListString({
    required String key,
    List<String>? defaultValue,
  }) {
    final List<String>? value = _storage.getStringList(key) ?? defaultValue;
    return value;
  }

  static Future<void> setListString({
    required String key,
    required List<String> value,
  }) async {
    await _storage.setStringList(key, value);
  }

  static Future<void> removeValue({
    required String key,
  }) async {
    await _storage.remove(key);
  }

  static Future<void> deleteNotSecuredString({required String key}) async {
    await _storage.remove(key);
  }

  static Future<void> reset() async {
    await _storage.clear();
  }
}

enum StorageConsts {
  favourites;

  String get txt => toString().split('.')[1];
}
