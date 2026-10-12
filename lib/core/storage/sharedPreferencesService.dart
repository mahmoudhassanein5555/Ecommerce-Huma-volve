import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setData({
    required String key,
    required dynamic value,
  }) async {
    if (_preferences == null) await init();

    if (value is String) return await _preferences!.setString(key, value);
    if (value is int) return await _preferences!.setInt(key, value);
    if (value is bool) return await _preferences!.setBool(key, value);
    if (value is double) return await _preferences!.setDouble(key, value);

    return false;
  }

  static dynamic getData({required String key}) {
    return _preferences?.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    if (_preferences == null) await init();
    return await _preferences!.remove(key);
  }

  static Future<bool> clearAll() async {
    if (_preferences == null) await init();
    return await _preferences!.clear();
  }
}
