import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ✅ Use a class for constants instead of global variables
class CacheKeys {
  CacheKeys._(); // Private constructor

  static const String imageKey = 'profile_image';
  static const String nameKey = 'nameUser';
  static const String emailKey = 'emailUser';
  static const String genderKey = 'genderUser';
  static const String birthKey = 'birthUser';
  static const String tokenKey = 'token';
  static const String refreshTokenKey = 'refresh_token';
  static const String isDarkMode = 'isDarkMode';
  static const String localKey = 'local';
}

class CacheHelper {
  // Private constructor to prevent instantiation
  CacheHelper._();

  static late SharedPreferences _prefs;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ✅ Make this static too
  static Future<void> set({required String key, required dynamic value}) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
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

  // Secure Storage methods
  static Future<void> writeSecureStorage({
    required String key,
    required String value,
  }) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> readSecureStorage({required String key}) async {
    return await _secureStorage.read(key: key);
  }

  static Future<void> deleteSecureStorage({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  static Future<void> deleteAllSecureStorage() async {
    await _secureStorage.deleteAll();
  }
}
