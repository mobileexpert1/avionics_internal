import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _emailKey = 'emailKey';
  static const String _isUserLoginKey = 'UserLoginKey';
  static const String _isFirstLaunchKey = 'FirstLaunchKey';
  static const String _isUserAccessTokenKey = 'UserAccessTokenKey';
  static const String _isUserRefreshTokenKey = 'UserRefreshTokenKey';
  static const String _isAvtarForProfileKey = 'AvtarForProfileKey';
  static const String isMapKeyValues = 'MapKeyValues';

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
    return prefs.getString(_isAvtarForProfileKey) ?? 'student';
  }

  static Future<void> seMapKeyValuesFromServer(String mapKeyValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(isMapKeyValues, mapKeyValue);
  }

  static Future<String> getMapKeyValuesForApi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(isMapKeyValues) ?? '';
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
    } else {
      final keys = [
        _emailKey,
        _isUserLoginKey,
        _isUserAccessTokenKey,
        _isUserRefreshTokenKey,
        _isAvtarForProfileKey,
      ];
      for (final key in keys) {
        await prefs.remove(key);
      }
    }
  }
}
