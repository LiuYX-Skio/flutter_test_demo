import 'package:dio/dio.dart';

/// API 异常类型
enum ApiExceptionType {
  /// 网络连接超时
  connectTimeout,

  /// 发送超时
  sendTimeout,

  /// 接收超时
  receiveTimeout,

  /// 请求取消
  cancel,

  /// 网络错误
  network,

  /// 业务错误
  business,

  /// 未知错误
  unknown,
}

/// 统一异常处理类
class ApiException implements Exception {
  /// 异常类型
  final ApiExceptionType type;

  /// 错误码
  final int? code;

  /// 错误信息
  final String message;

  /// 原始异常
  final dynamic originalError;

  const ApiException({
    required this.type,
    this.code,
    required this.message,
    this.originalError,
  });

  /// 从 DioException 创建
  factory ApiException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          type: ApiExceptionType.connectTimeout,
          message: '连接超时，请检查网络设置',
          originalError: error,
        );
      case DioExceptionType.sendTimeout:
        return ApiException(
          type: ApiExceptionType.sendTimeout,
          message: '请求超时，请稍后重试',
          originalError: error,
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          type: ApiExceptionType.receiveTimeout,
          message: '响应超时，请稍后重试',
          originalError: error,
        );
      case DioExceptionType.cancel:
        return ApiException(
          type: ApiExceptionType.cancel,
          message: '请求已取消',
          originalError: error,
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      default:
        return ApiException(
          type: ApiExceptionType.network,
          message: '网络连接失败，请检查网络设置',
          originalError: error,
        );
    }
  }

  /// 处理错误响应
  static ApiException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    String message;

    switch (statusCode) {
      case 400:
        message = '请求参数错误';
        break;
      case 401:
        message = '未授权，请重新登录';
        break;
      case 403:
        message = '拒绝访问';
        break;
      case 404:
        message = '请求的资源不存在';
        break;
      case 500:
        message = '服务器内部错误';
        break;
      case 502:
        message = '网关错误';
        break;
      case 503:
        message = '服务不可用';
        break;
      case 504:
        message = '网关超时';
        break;
      default:
        message = '请求失败，错误码：$statusCode';
    }

    return ApiException(
      type: ApiExceptionType.network,
      code: statusCode,
      message: message,
      originalError: error,
    );
  }

  /// 业务异常
  factory ApiException.business({
    required int code,
    required String message,
  }) {
    return ApiException(
      type: ApiExceptionType.business,
      code: code,
      message: message,
    );
  }

  @override
  String toString() {
    return 'ApiException{type: $type, code: $code, message: $message}';
  }
}
