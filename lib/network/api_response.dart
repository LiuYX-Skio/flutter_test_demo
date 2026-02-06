import 'json_converter_registry.dart';

/// 统一 API 响应模型
class ApiResponse<T> {
  /// 业务状态码
  final int code;

  /// 响应消息
  final String message;

  /// 响应数据
  final T? data;

  /// 是否成功
  bool get isSuccess => code == 200 || code == 0;

  const ApiResponse({
    required this.code,
    required this.message,
    this.data,
  });

  /// 从 JSON 创建响应对象
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic json)? fromJsonT,
  }) {
    final code = json['code'] as int? ?? json['status'] as int? ?? 0;
    final message = json['message'] as String? ?? json['msg'] as String? ?? '';

    // 处理 data 字段的转换
    T? convertedData;
    final data = json['data'];

    // 只有当 data 不为 null 且不是空字符串时才尝试转换
    if (data != null && data != '') {
      // 如果 data 是基本类型（String, int, double, bool），直接尝试转换
      if (data is String || data is int || data is double || data is bool) {
        try {
          convertedData = data as T?;
        } catch (e) {
          convertedData = null;
        }
      } else {
        // data 是复杂类型（Map 或 List），使用转换器
        if (fromJsonT != null) {
          try {
            convertedData = fromJsonT(data);
          } catch (e) {
            convertedData = null;
            print("fromJsonT e: $e");
          }
        } else {
          try {
            convertedData = JsonConverterRegistry().convert<T>(data);
          } catch (e) {
            print("innerJsonT e: $e");
            convertedData = null;
          }
        }
      }
    }

    return ApiResponse<T>(
      code: code,
      message: message,
      data: convertedData,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data,
    };
  }

  /// 成功响应
  factory ApiResponse.success({T? data, String? message}) {
    return ApiResponse<T>(
      code: 200,
      message: message ?? 'Success',
      data: data,
    );
  }

  /// 失败响应
  factory ApiResponse.failure({required int code, required String message}) {
    return ApiResponse<T>(
      code: code,
      message: message,
    );
  }

  @override
  String toString() {
    return 'ApiResponse{code: $code, message: $message, data: $data}';
  }
}
