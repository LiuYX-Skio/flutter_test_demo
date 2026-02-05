import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'core/route_registry.dart';
import 'core/lifecycle_observer.dart';
import 'utils/platform_bridge.dart';

/// 导航框架初始化器 - 统一初始化所有导航相关功能
class NavigationInitializer {
  static bool _initialized = false;

  /// 初始化整个导航框架
  static void initialize() {
    if (_initialized) return;

    // 1. 初始化路由注册器
    RouteRegistry().initialize();

    // 2. 初始化平台桥接
    PlatformBridge().initialize();

    // 3. 初始化生命周期观察者
    _setupLifecycleObservers();

    // 4. 初始化 Flutter Boost
    _setupFlutterBoost();

    _initialized = true;
  }

  /// 获取 Flutter Boost 路由工厂
  static Map<String, FlutterBoostRouteFactory> getBoostRoutes() {
    return RouteRegistry().getBoostRouteFactory();
  }

  /// 设置生命周期观察者
  static void _setupLifecycleObservers() {
    // 添加默认的全局生命周期观察者
    final globalObserver = SimpleGlobalLifecycleObserver(
      onStateChanged: (routeName, state) {
        // 可以在这里添加全局的生命周期处理逻辑
        // 例如：页面访问统计、性能监控等
        print('Global Lifecycle: $routeName -> $state');
      },
    );

    PageLifecycleManager().addGlobalObserver(globalObserver);
  }

  /// 设置 Flutter Boost
  static void _setupFlutterBoost() {
    // Flutter Boost 的路由设置通常在 FlutterBoostApp 中完成
    // 这里可以进行其他初始化工作
  }

  /// 检查是否已初始化
  static bool get isInitialized => _initialized;

  /// 重置初始化状态（主要用于测试）
  static void reset() {
    _initialized = false;
  }
}

/// 简化版应用入口 - 使用导航框架
class NavigationApp extends StatefulWidget {
  const NavigationApp({super.key});

  @override
  State<NavigationApp> createState() => _NavigationAppState();
}

class _NavigationAppState extends State<NavigationApp> {
  @override
  void initState() {
    super.initState();
    // 初始化导航框架
    NavigationInitializer.initialize();
  }

  /// 应用构建器
  Widget appBuilder(Widget home) {
    return MaterialApp(
      home: home,
      debugShowCheckedModeBanner: false,

      /// 必须加上builder参数，否则showDialog等会出问题
      builder: (_, __) {
        return home;
      },
    );
  }

  /// 路由工厂
  Route<dynamic>? routeFactory(
    RouteSettings settings,
    bool isContainerPage,
    String? uniqueId,
  ) {
    final routes = NavigationInitializer.getBoostRoutes();
    final FlutterBoostRouteFactory? func = routes[settings.name];
    if (func == null) {
      return null;
    }
    return func(settings, isContainerPage, uniqueId);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterBoostApp(
      routeFactory,
      appBuilder: appBuilder,
      initialRoute: "home", // 使用新的路由名称
    );
  }
}