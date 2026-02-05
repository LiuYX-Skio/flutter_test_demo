/// HTTP 配置类
class HttpConfig {
  /// 基础 URL
  final String baseUrl;

  /// 连接超时时间（毫秒）
  final int connectTimeout;

  /// 接收超时时间（毫秒）
  final int receiveTimeout;

  /// 发送超时时间（毫秒）
  final int sendTimeout;

  /// 是否启用日志
  final bool enableLog;

  /// 请求头
  final Map<String, dynamic>? headers;

  /// 内容类型
  final String contentType;

  const HttpConfig({
    required this.baseUrl,
    this.connectTimeout = 30000,
    this.receiveTimeout = 30000,
    this.sendTimeout = 30000,
    this.enableLog = true,
    this.headers,
    this.contentType = 'application/json',
  });

  HttpConfig copyWith({
    String? baseUrl,
    int? connectTimeout,
    int? receiveTimeout,
    int? sendTimeout,
    bool? enableLog,
    Map<String, dynamic>? headers,
    String? contentType,
  }) {
    return HttpConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      enableLog: enableLog ?? this.enableLog,
      headers: headers ?? this.headers,
      contentType: contentType ?? this.contentType,
    );
  }
}
