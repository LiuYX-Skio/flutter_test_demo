class StringUtils {
  static String getNotNullParam(String? param) {
    return isEmpty(param) ? "" : param!;
  }

  /// 判断字符串是否为空（null 或长度为 0）
  static bool isEmpty(String? str) {
    return str == null || str.isEmpty;
  }
}
