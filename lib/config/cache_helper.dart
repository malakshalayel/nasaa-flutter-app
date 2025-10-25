import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _prefs;
  static FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> set({required String key, required dynamic value}) async {
    if (value is String) {
      _prefs.setString(key, value);
    } else if (value is int) {
      _prefs.setInt(key, value);
    } else if (value is bool) {
      _prefs.setBool(key, value);
    } else if (value is double) {
      _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      _prefs.setStringList(key, value);
    }
  }

  static String? getString({required String key}) {
    return _prefs.getString(key);
  }

  static bool? getBool({required String key}) {
    return _prefs.getBool(key);
  }

  static int? getInt({required String key}) {
    return _prefs.getInt(key);
  }

  static double? getDouble({required String key}) {
    return _prefs.getDouble(key);
  }

  static List<String>? getStringList({required String key}) {
    return _prefs.getStringList(key);
  }

  static Future<void> remove({required String key}) async {
    await _prefs.remove(key);
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }

  static Future<void> writeSecureStorage({
    required String key,
    required String value,
  }) async {
    await secureStorage.write(key: key, value: value);
  }

  static Future<String?> readSecureStorage({required String key}) async {
    return await secureStorage.read(key: key);
  }

  static Future<void> deleteSecureStorage({required String key}) async {
    await secureStorage.delete(key: key);
  }

  static Future<void> deleteAllSecureStorge() async {
    await secureStorage.deleteAll();
  }
}
