import 'package:ecommerce_app_huma_volve/core/network/secure_storage_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  CacheHelper._(); // Private constructor to prevent instantiation

  static late SharedPreferences _prefs;

  // ============= Cache Keys Constants =============
  static const String kIsOnBoardingViewSeen = 'isOnBoardingViewSeen';
  static const String kToken = 'token';
  static const String kUserId = 'userId';
  static const String kUserName = 'userName';
  static const String kUserEmail = 'userEmail';
  static const String kIsLoggedIn = 'isLoggedIn';
  static const String kLanguage = 'language';
  static const String kThemeMode = 'themeMode';

  // ============= Initialize =============
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============= String Methods =============

  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// Get String value
  static String? getString(String key) {
    return _prefs.getString(key);
  }

  // ============= Bool Methods =============
  /// Save Bool value
  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// Get Bool value (default: false)
  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  // ============= Int Methods =============
  /// Save Int value
  static Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// Get Int value
  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // ============= Double Methods =============
  /// Save Double value
  static Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  /// Get Double value
  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // ============= Generic Methods =============
  /// Get any data type
  static dynamic get(String key) {
    return _prefs.get(key);
  }

  /// Save data dynamically based on type
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return await setString(key, value);
    } else if (value is bool) {
      return await setBool(key, value);
    } else if (value is int) {
      return await setInt(key, value);
    } else if (value is double) {
      return await setDouble(key, value);
    }
    return false;
  }

  // ============= Utility Methods =============
  /// Check if key exists
  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Remove specific key
  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// Clear all data
  static Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  /// Get all keys
  static Set<String> getAllKeys() {
    return _prefs.getKeys();
  }

  // ============= User Session Methods =============
  /// Check if user is logged in
  static bool get isLoggedIn => getBool(kIsLoggedIn);

  /// Check if onboarding is completed
  static bool get isOnBoardingCompleted => getBool(kIsOnBoardingViewSeen);

  /// Clear user session (both SharedPreferences and SecureStorage)
  static Future<void> logout() async {
    // Clear tokens from SecureStorage
    await SecureStorageHelper().clearTokens();

    // Clear user data from SharedPreferences
    await remove(kToken);
    await remove(kUserId);
    await remove(kUserName);
    await remove(kUserEmail);
    await setBool(kIsLoggedIn, false);
  }

  /// Clear user session (deprecated - use logout() instead)
  @Deprecated('Use logout() instead')
  static Future<void> clearUserSession() async {
    await logout();
  }
}
