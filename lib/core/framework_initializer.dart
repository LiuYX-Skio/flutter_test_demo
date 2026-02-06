import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../network/network.dart';
import '../navigation/navigation_initializer.dart';

/// 框架初始化配置
class FrameworkConfig {
  /// 网络框架配置
  final NetworkConfig? networkConfig;

  /// 是否初始化导航框架
  final bool initNavigation;

  const FrameworkConfig({
    this.networkConfig,
    this.initNavigation = true,
  });
}

/// 网络框架配置
class NetworkConfig {
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

  /// Token 获取回调
  final Future<String?> Function()? onGetToken;

  /// Token 刷新回调
  final Future<String?> Function()? onRefreshToken;

  /// 未授权回调
  final void Function()? onUnauthorized;

  /// 全局错误处理回调
  final void Function(ApiException exception)? onError;

  const NetworkConfig({
    required this.baseUrl,
    this.connectTimeout = 30000,
    this.receiveTimeout = 30000,
    this.sendTimeout = 30000,
    this.enableLog = true,
    this.headers,
    this.onGetToken,
    this.onRefreshToken,
    this.onUnauthorized,
    this.onError,
  });
}

/// 统一框架初始化器
///
/// 负责初始化应用中的所有框架，包括：
/// - 网络框架
/// - 导航框架
/// - 其他框架（可扩展）
///
/// 使用方式：
/// ```dart
/// // 方式1：使用配置对象初始化所有框架
/// FrameworkInitializer.initAll(FrameworkConfig(
///   networkConfig: NetworkConfig(baseUrl: 'https://api.example.com'),
/// ));
///
/// // 方式2：单独初始化各个框架
/// FrameworkInitializer.initNetwork(NetworkConfig(baseUrl: 'https://api.example.com'));
/// FrameworkInitializer.initNavigation();
/// ```
class FrameworkInitializer {
  // 初始化状态标记
  static bool _networkInitialized = false;
  static bool _navigationInitialized = false;

  /// 私有构造函数，防止实例化
  FrameworkInitializer._();

  /// 初始化所有框架
  ///
  /// [config] 框架配置对象
  static void initAll(FrameworkConfig config) {
    // 初始化网络框架
    if (config.networkConfig != null) {
      initNetwork(config.networkConfig!);
    }

    // 初始化导航框架
    if (config.initNavigation) {
      initNavigation();
    }
    initEasyDialog();
  }



  static void initEasyDialog() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  /// 初始化网络框架
  ///
  /// [config] 网络配置对象
  static void initNetwork(NetworkConfig config) {
    if (_networkInitialized) {
      print('⚠️ 网络框架已经初始化，跳过重复初始化');
      return;
    }

    // 1. 创建 HTTP 配置
    final httpConfig = HttpConfig(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      enableLog: config.enableLog,
      headers: config.headers,
    );

    // 2. 初始化 HTTP 客户端
    HttpClient.instance.init(httpConfig);

    // 2.5. 注册 JSON 类型转换器
    NetworkInitializer.init();

    // 3. 添加认证拦截器（如果提供了回调）
    if (config.onGetToken != null ||
        config.onRefreshToken != null ||
        config.onUnauthorized != null) {
      HttpClient.instance.addAuthInterceptor(
        onGetToken: config.onGetToken,
        onRefreshToken: config.onRefreshToken,
        onUnauthorized: config.onUnauthorized,
      );
    }

    _networkInitialized = true;
    print('✅ 网络框架初始化完成');
  }

  /// 初始化导航框架
  static void initNavigation() {
    if (_navigationInitialized) {
      print('⚠️ 导航框架已经初始化，跳过重复初始化');
      return;
    }

    NavigationInitializer.initialize();

    _navigationInitialized = true;
    print('✅ 导航框架初始化完成');
  }

  /// 检查网络框架是否已初始化
  static bool get isNetworkInitialized => _networkInitialized;

  /// 检查导航框架是否已初始化
  static bool get isNavigationInitialized => _navigationInitialized;

  /// 检查所有框架是否已初始化
  static bool get isAllInitialized =>
      _networkInitialized && _navigationInitialized;
}
