import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences 工具类
/// 提供通用的本地存储操作方法
class SharedPreferencesUtil {

  /// 获取 SharedPreferences 实例
  static Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  /// 通用方法：设置字符串值
  static Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  /// 通用方法：获取字符串值
  static Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  /// 通用方法：设置布尔值
  static Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(key, value);
  }

  /// 通用方法：获取布尔值
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await _prefs;
    return prefs.getBool(key) ?? defaultValue;
  }

  /// 通用方法：设置整数值
  static Future<void> setInt(String key, int value) async {
    final prefs = await _prefs;
    await prefs.setInt(key, value);
  }

  /// 通用方法：获取整数值
  static Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }

  /// 通用方法：设置双精度浮点数值
  static Future<void> setDouble(String key, double value) async {
    final prefs = await _prefs;
    await prefs.setDouble(key, value);
  }

  /// 通用方法：获取双精度浮点数值
  static Future<double?> getDouble(String key) async {
    final prefs = await _prefs;
    return prefs.getDouble(key);
  }

  /// 通用方法：设置字符串列表
  static Future<void> setStringList(String key, List<String> value) async {
    final prefs = await _prefs;
    await prefs.setStringList(key, value);
  }

  /// 通用方法：获取字符串列表
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await _prefs;
    return prefs.getStringList(key);
  }

  /// 通用方法：移除指定键的值
  static Future<void> remove(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }

  /// 通用方法：清空所有数据
  static Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  /// 通用方法：检查是否包含指定键
  static Future<bool> containsKey(String key) async {
    final prefs = await _prefs;
    return prefs.containsKey(key);
  }

  /// 获取所有键值对
  static Future<Map<String, dynamic>> getAll() async {
    final prefs = await _prefs;
    final keys = prefs.getKeys();
    final result = <String, dynamic>{};

    for (final key in keys) {
      result[key] = prefs.get(key);
    }

    return result;
  }
}