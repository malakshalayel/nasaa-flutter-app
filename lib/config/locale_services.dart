import 'package:flutter/material.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleServices extends ChangeNotifier {
  Locale _locale = Locale("en");
  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _locale = Locale(prefs.getString(CacheKeys.localKey) ?? "en");
    notifyListeners();
  }

  Future<void> choiceLanguge(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == "en") {
      _locale = Locale('en');
      prefs.setString(CacheKeys.localKey, "en");
    } else {
      _locale = Locale('ar');
      prefs.setString(CacheKeys.localKey, "ar");
    }
    notifyListeners();
  }
}
