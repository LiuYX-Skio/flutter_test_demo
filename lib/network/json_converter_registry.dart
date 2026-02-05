/// JSON 类型转换器注册表
/// 用于自动将 JSON 转换为对应的实体类
class JsonConverterRegistry {
  static final JsonConverterRegistry _instance = JsonConverterRegistry._internal();

  factory JsonConverterRegistry() => _instance;

  JsonConverterRegistry._internal();

  /// 存储类型转换函数的映射表
  final Map<Type, Function> _converters = {};

  /// 注册类型转换器
  ///
  /// 示例:
  /// ```dart
  /// registry.register<AppUpdateEntity>(
  ///   (json) => AppUpdateEntity.fromJson(json as Map<String, dynamic>)
  /// );
  /// ```
  void register<T>(T Function(dynamic json) converter) {
    _converters[T] = converter;
  }

  /// 获取类型转换器
  T Function(dynamic json)? getConverter<T>() {
    final converter = _converters[T];
    if (converter == null) return null;
    return converter as T Function(dynamic json);
  }

  /// 转换 JSON 为指定类型
  T? convert<T>(dynamic json) {
    if (json == null) return null;

    // 处理基本类型
    if (T == String || T == int || T == double || T == bool) {
      return json as T;
    }

    // 处理 List 类型
    if (T.toString().startsWith('List<')) {
      return json as T;
    }

    // 处理 Map 类型
    if (T.toString().startsWith('Map<')) {
      return json as T;
    }

    // 使用注册的转换器
    final converter = getConverter<T>();
    if (converter != null) {
      return converter(json);
    }

    // 如果没有注册转换器，尝试直接转换
    return json as T;
  }

  /// 清空所有注册的转换器
  void clear() {
    _converters.clear();
  }
}
