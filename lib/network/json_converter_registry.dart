/// JSON 类型转换器注册表
/// 用于自动将 JSON 转换为对应的实体类
class JsonConverterRegistry {
  static final JsonConverterRegistry _instance = JsonConverterRegistry._internal();

  factory JsonConverterRegistry() => _instance;

  JsonConverterRegistry._internal();

  /// 存储类型转换函数的映射表
  final Map<Type, Function> _converters = {};

  /// 存储 List 类型的元素转换函数
  final Map<Type, Function> _listItemConverters = {};

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

  /// 注册 List 类型的元素转换器
  ///
  /// 示例:
  /// ```dart
  /// registry.registerListItem<UserEntity>(
  ///   (json) => UserEntity.fromJson(json as Map<String, dynamic>)
  /// );
  /// ```
  void registerListItem<T>(T Function(dynamic json) converter) {
    _listItemConverters[T] = converter;
  }

  /// 获取类型转换器
  T Function(dynamic json)? getConverter<T>() {
    final converter = _converters[T];
    if (converter == null) return null;
    return converter as T Function(dynamic json);
  }

  /// 获取 List 元素类型转换器
  T Function(dynamic json)? getListItemConverter<T>() {
    final converter = _listItemConverters[T];
    if (converter == null) return null;
    return converter as T Function(dynamic json);
  }

  /// 转换 JSON 为指定类型
  T? convert<T>(dynamic json) {
    if (json == null) {
      print("no json");
      return null;
    };

    // 处理基本类型
    if (T == String || T == int || T == double || T == bool) {
      return json as T;
    }

    // 处理 List 类型
    if (T.toString().startsWith('List<')) {
      if (json is! List) {
        throw ArgumentError('Expected List but got ${json.runtimeType}');
      }

      // 如果是 List<dynamic>，直接返回
      if (T == List<dynamic>) {
        return json as T;
      }

      // 尝试转换 List 中的每个元素
      return _convertList<T>(json);
    }

    // 处理 Map 类型
    if (T.toString().startsWith('Map<')) {
      print("json map");
      return json as T;
    }

    // 使用注册的转换器
    final converter = getConverter<T>();
    if (converter != null) {
      return converter(json);
    }

    print("no converter");

    // 如果没有注册转换器，返回 null
    return null;
  }

  /// 转换 List 类型
  T _convertList<T>(List json) {
    // 提取泛型类型字符串，例如 "List<UserEntity>" -> "UserEntity"
    final typeString = T.toString();
    final match = RegExp(r'List<(.+)>').firstMatch(typeString);

    if (match == null) {
      // 无法提取泛型类型，返回原始 List
      return json as T;
    }

    // 尝试根据类型字符串查找对应的转换器
    // 这里我们遍历已注册的转换器，找到匹配的类型
    for (final entry in _listItemConverters.entries) {
      if (entry.key.toString() == match.group(1)) {
        final itemConverter = entry.value;
        final convertedList = json.map((item) => itemConverter(item)).toList();
        return convertedList as T;
      }
    }

    // 如果没有找到对应的元素转换器，尝试直接转换
    return json as T;
  }

  /// 清空所有注册的转换器
  void clear() {
    _converters.clear();
    _listItemConverters.clear();
  }
}
