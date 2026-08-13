import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _key = 'current_user_id';
  static const String _emailKey = 'emailKey';
  static const String _isUserLoginKey = 'UserLoginKey';
  static const String _isFirstLaunchKey = 'FirstLaunchKey';
  static const String _isUserAccessTokenKey = 'UserAccessTokenKey';
  static const String _isUserRefreshTokenKey = 'UserRefreshTokenKey';
  static const String _isAvtarForProfileKey = 'AvtarForProfileKey';
  static const String isMapKeyValues = 'MapKeyValues';
  static const String _fcmTokenKey = 'fcm_token_key';
  static const String apiFetchKeyFromSever = 'api_Fetch_Key_From_Sever';
  static const String fetchSubsIsTrueKey = 'fetchSubsIsTrue';
  static const String _isAvtarForProfileUrlKey = 'avtarForProfileUrlKey';
  static const String _userProfileNameKey = 'userProfileNameKey';
  static const String _jettingAroundGameModel = 'model_data';
  static const String _jettingGameCountKey = 'jettingGameCountKey';
  static const String _jettingGameSetIdKey = 'jettingGameSetIdKey';

  static Future<void> saveJettingGame(Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();

    final String? existing = prefs.getString(_jettingAroundGameModel);

    List<dynamic> list = [];

    if (existing != null) {
      list = jsonDecode(existing);
    }

    list.add(payload);

    await prefs.setString(_jettingAroundGameModel, jsonEncode(list));
  }

  static Future<List<Map<String, dynamic>>> getJettingGames() async {
    final prefs = await SharedPreferences.getInstance();

    final String? existing = prefs.getString(_jettingAroundGameModel);

    if (existing == null) return [];

    return List<Map<String, dynamic>>.from(jsonDecode(existing));
  }

  static Future<void> clearJettingGames() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_jettingAroundGameModel);
  }

  /*static Future<void> saveJettingGameSetId(List<String> deviceIds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_jettingGameSetIdKey, deviceIds);
  }

  static Future<List<String>?> getJettingGameSetId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_jettingGameSetIdKey);
  }

  static Future<void> clearJettingGameSetId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jettingGameSetIdKey);
  }

  static Future<void> saveJettingGameCount(int deviceId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_jettingGameCountKey, deviceId);
  }

  static Future<int?> getJettingGameCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_jettingGameCountKey);
  }

  static Future<void> clearJettingGameCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jettingGameCountKey);
  }

  static Future<bool> saveModelWithId(
    String id,
    Map<String, Object> modelData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(modelData);
    return await prefs.setString('${_jettingAroundGameModel}_$id', jsonString);
  }

  static Future<Map<String, dynamic>?> getModelWithId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(
      '${_jettingAroundGameModel}_$id',
    );
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }*/

  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> removeString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> save(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, uid);
  }

  static Future<String?> read() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<void> saveApiFetchSubsIsTrueKey(bool isSet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(fetchSubsIsTrueKey, isSet);
  }

  static Future<bool?> getApiFetchSubsIsTrueKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(fetchSubsIsTrueKey);
  }

  static Future<void> saveApiFetchKeyFromSever(bool isSet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(apiFetchKeyFromSever, isSet);
  }

  static Future<bool?> getApiFetchKeyFromSever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(apiFetchKeyFromSever);
  }

  static Future<void> clearApiFetchServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(apiFetchKeyFromSever);
  }

  static Future<void> saveFCMToken(String deviceId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fcmTokenKey, deviceId);
  }

  static Future<String?> getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fcmTokenKey);
  }

  static Future<void> clearFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_fcmTokenKey);
  }

  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  static Future<String?> refreshAndUpdateFCMToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newToken = await FirebaseMessaging.instance.getToken();
      if (newToken != null && newToken.isNotEmpty) {
        await prefs.setString(_fcmTokenKey, newToken);
      }
      return newToken;
    } catch (e) {
      debugPrint("FCM refresh failed: $e");
      return null;
    }
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

  static Future<void> setUserAccessToken(String userAccessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_isUserAccessTokenKey, userAccessToken);
  }

  static Future<String?> getUserAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_isUserAccessTokenKey);
  }

  static Future<void> setUserRefreshToken(String userAccessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_isUserRefreshTokenKey, userAccessToken);
  }

  static Future<String?> getUserRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_isUserRefreshTokenKey);
  }

  static Future<void> setAvtarUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_isAvtarForProfileKey, userType);
  }

  static Future<String> getAvtarUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_isAvtarForProfileKey) ?? '';
  }

  static Future<void> setAvtarUserUrl(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_isAvtarForProfileUrlKey, userType);
  }

  static Future<String> getAvtarUserUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_isAvtarForProfileUrlKey) ?? '';
  }

  static Future<void> setUserProfileName(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProfileNameKey, userType);
  }

  static Future<String> getUserProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userProfileNameKey) ?? '';
  }

  static Future<void> seMapKeyValuesFromServer(String mapKeyValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(isMapKeyValues, mapKeyValue);
  }

  static Future<String> getMapKeyValuesForApi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(isMapKeyValues) ?? '';
  }

  static Future<void> removeTempKeyBeforeLaunch() async {
    removeMapApiKey();
    clearApiFetchServer();
    removeString('flight_params_1');
    removeString('flight_params_2');
  }

  static Future<void> removeMapApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(isMapKeyValues);
  }

  static Future<void> clearAll(
    List<String> keysToRemove,
    bool isComeFromAllClear,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    if (isComeFromAllClear == true) {
      await prefs.clear();
      await FirebaseMessaging.instance.deleteToken();
    } else {
      final keys = [
        _emailKey,
        _isUserLoginKey,
        _isUserAccessTokenKey,
        _isUserRefreshTokenKey,
        _isAvtarForProfileKey,
        _isAvtarForProfileUrlKey,
        _userProfileNameKey,
        _fcmTokenKey,
        isMapKeyValues,
        _fcmTokenKey,
        apiFetchKeyFromSever,
        fetchSubsIsTrueKey,
      ];
      for (final key in keys) {
        await prefs.remove(key);
      }
    }
  }
}
