import 'package:dio/dio.dart';
import 'package:flutter_test_demo/app/provider/user_provider.dart';

/// 认证拦截器
/// 用于在请求头中添加 Token 等认证信息
class AuthInterceptor extends Interceptor {
  /// Token 获取回调
  final Future<String?> Function()? onGetToken;

  /// Token 刷新回调
  final Future<String?> Function()? onRefreshToken;

  /// 未授权回调（如跳转登录页）
  final void Function()? onUnauthorized;

  AuthInterceptor({
    this.onGetToken,
    this.onRefreshToken,
    this.onUnauthorized,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print("token = "+UserProvider.getUserToken());
    // 获取 Token
    if (onGetToken != null) {
      final token = await onGetToken!();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 处理 401 未授权错误
    if (err.response?.statusCode == 401) {
      // 尝试刷新 Token
      if (onRefreshToken != null) {
        try {
          final newToken = await onRefreshToken!();
          if (newToken != null && newToken.isNotEmpty) {
            // 更新请求头
            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

            // 重新发起请求
            final dio = Dio();
            final response = await dio.fetch(err.requestOptions);
            return handler.resolve(response);
          }
        } catch (e) {
          // Token 刷新失败，触发未授权回调
          onUnauthorized?.call();
        }
      } else {
        // 没有刷新 Token 的回调，直接触发未授权回调
        onUnauthorized?.call();
      }
    }
    super.onError(err, handler);
  }
}
