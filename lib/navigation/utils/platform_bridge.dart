import 'dart:async';
import 'package:flutter/services.dart';
import 'route_result.dart';

/// 跨平台路由桥接
class PlatformBridge {
  static final PlatformBridge _instance = PlatformBridge._internal();
  factory PlatformBridge() => _instance;
  PlatformBridge._internal();

  static const MethodChannel _channel = MethodChannel('com.example.flutter_boost/navigation');
  final StreamController<NativeNavigationRequest> _nativeRequestsController = StreamController<NativeNavigationRequest>.broadcast();

  /// 从 Flutter 跳转到原生页面
  Future<RouteResult<T?>> pushNative<T>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    try {
      final result = await _channel.invokeMethod('pushNative', {
        'routeName': routeName,
        'arguments': arguments,
      });
      return RouteResult.success(result as T?, routeName: routeName);
    } catch (e) {
      return RouteResult.error(e.toString(), routeName: routeName);
    }
  }

  /// 从原生跳转到 Flutter 页面
  Future<RouteResult<T?>> pushFromNative<T>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    try {
      final result = await _channel.invokeMethod('pushFromNative', {
        'routeName': routeName,
        'arguments': arguments,
      });
      return RouteResult.success(result as T?, routeName: routeName);
    } catch (e) {
      return RouteResult.error(e.toString(), routeName: routeName);
    }
  }

  /// 发送结果回原生
  void sendResultToNative<T>(T result) {
    _channel.invokeMethod('sendResultToNative', {'result': result});
  }

  /// 监听来自原生的导航请求
  Stream<NativeNavigationRequest> get nativeNavigationRequests => _nativeRequestsController.stream;

  /// 初始化平台桥接
  void initialize() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onNativeNavigationRequest':
        final args = call.arguments as Map<String, dynamic>;
        final request = NativeNavigationRequest(
          routeName: args['routeName'] as String,
          arguments: args['arguments'] as Map<String, dynamic>?,
          requestId: args['requestId'] as String?,
        );
        _nativeRequestsController.add(request);
        break;
    }
  }

  /// 清理资源
  void dispose() {
    _nativeRequestsController.close();
  }
}

/// 原生导航请求
class NativeNavigationRequest {
  final String routeName;
  final Map<String, dynamic>? arguments;
  final String? requestId;

  const NativeNavigationRequest({
    required this.routeName,
    this.arguments,
    this.requestId,
  });
}