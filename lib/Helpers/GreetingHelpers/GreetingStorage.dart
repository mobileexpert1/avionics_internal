import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GreetingStorage {
  static const String key = "chat_greetings";

  static Future<void> save(
      String sessionId,
      String greeting,
      ) async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(key);

    Map<String, dynamic> map = {};

    if (data != null) {
      map = jsonDecode(data);
    }

    map[sessionId] = greeting;

    await prefs.setString(key, jsonEncode(map));
  }

  static Future<String?> get(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(key);

    if (data == null) return null;

    final map = jsonDecode(data);

    return map[sessionId];
  }
}