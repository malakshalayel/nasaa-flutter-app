import 'package:flutter/material.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeServices extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> loadedTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(CacheKeys.isDarkMode) ?? false;
    notifyListeners();
  }

  toggleTheme() async {
    _isDarkMode = !_isDarkMode;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(CacheKeys.isDarkMode, _isDarkMode);

    notifyListeners();
  }
}
