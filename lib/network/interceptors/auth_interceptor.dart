import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test_demo/app/provider/user_provider.dart';

import '../../app/constants/app_constants.dart';
import '../../navigation/core/navigator_service.dart';
import '../../navigation/core/route_paths.dart';

/// 认证拦截器
/// 用于在请求头中添加 Token 等认证信息
class AuthInterceptor extends Interceptor {
  static bool _isNavigatingToLogin = false;
  static DateTime? _lastLoginNavigateAt;

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
    // 获取 Token
    if (onGetToken != null) {
      final token = await onGetToken!();
      if (token != null && token.isNotEmpty) {
        options.headers['Authori-zation'] = token;
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      dynamic data = response.data;
      Map<String, dynamic>? json;
      if (data is Map<String, dynamic>) {
        json = data;
      } else if (data is String) {
        json = jsonDecode(data) as Map<String, dynamic>;
      }
      if (json != null) {
        final code = json['code'] as int? ?? json['status'] as int? ?? 0;
        if (code == AppConstants.AUTH_LOGIN_CODE) {
          UserProvider.clearUserInfo();
          _navigateToLoginIfNeeded();
        }
      }
    } catch (e) {
      print("AuthInterceptor error $e");
    }

    super.onResponse(response, handler);
  }

  void _navigateToLoginIfNeeded() {
    if (_isNavigatingToLogin) {
      return;
    }
    final now = DateTime.now();
    final last = _lastLoginNavigateAt;
    if (last != null && now.difference(last).inMilliseconds < 800) {
      return;
    }
    _lastLoginNavigateAt = now;
    _isNavigatingToLogin = true;
    NavigatorService.instance.push(RoutePaths.auth.login).whenComplete(() {
      _isNavigatingToLogin = false;
    });
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
