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
    // 处理 data 字段的转换
    T? convertedData;
    if (json['data'] != null) {
      if (fromJsonT != null) {
        // 优先使用提供的转换函数
        convertedData = fromJsonT(json['data']);
      } else {
        // 使用注册表的转换方法（支持基本类型和已注册的实体类）
        convertedData = JsonConverterRegistry().convert<T>(json['data']);
      }
    }

    return ApiResponse<T>(
      code: json['code'] as int? ?? json['status'] as int? ?? 0,
      message: json['message'] as String? ?? json['msg'] as String? ?? '',
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
