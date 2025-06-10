// lib/utils/shared_prefs_helper.dart

import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _emailKey = 'emailKey';
  static const String _isUserLoginKey = 'UserLoginKey';
  static const String _isFirstLaunchKey = 'isFirstLaunchKey';

  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<void> saveIsUserLogin(bool isUserLogin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isUserLoginKey, isUserLogin);
  }

  static Future<bool?> getIsUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isUserLoginKey);
  }

  static Future<void> setFirstLaunchDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstLaunchKey, true);
  }

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstLaunchKey) ?? false;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
