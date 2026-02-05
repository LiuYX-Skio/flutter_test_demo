import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'route_definition.dart';
import 'route_paths.dart';
import '../utils/route_result.dart';
import '../config/route_config.dart';
import 'middle_ware.dart';

/// 导航服务类 - 封装 Flutter Boost 路由 API
class NavigatorService {
  static final NavigatorService _instance = NavigatorService._internal();
  factory NavigatorService() => _instance;
  NavigatorService._internal();

  final MiddlewareManager _middlewareManager = MiddlewareManager();
  final StreamController<String> _routeChangesController = StreamController<String>.broadcast();
  String? _currentRoute;

  /// 注册路由
  void registerRoutes(Map<String, RouteDefinition> routes) {
    RouteConfig().registerRoutes(routes);
  }

  /// 注册中间件
  void registerMiddleware(RouteMiddleware middleware) {
    _middlewareManager.addMiddleware(middleware);
  }

  /// 移除中间件
  void unregisterMiddleware(String middlewareName) {
    _middlewareManager.removeMiddleware(middlewareName);
  }

  /// 导航到页面
  Future<RouteResult<T?>> push<T>(
    dynamic routeName, {
    Map<String, dynamic>? arguments,
    bool withContainer = false,
    bool opaque = true,
  }) async {
    final String path = routeName is RoutePath ? routeName.path : routeName as String;
    try {
      final route = RouteConfig().getRoute(path);
      if (route == null) {
        return RouteResult.error('Route not found: $path');
      }

      // 执行中间件
      final canProceed = await _middlewareManager.executeChain(
        path,
        arguments,
        route.middlewares,
      );

      if (!canProceed) {
        return RouteResult.cancelled(routeName: path);
      }

      // 使用 Flutter Boost 导航
      final result = await BoostNavigator.instance.push(
        path,
        withContainer: withContainer,
        arguments: arguments,
        opaque: opaque,
      );

      _updateCurrentRoute(path);
      return RouteResult.success(result as T?, routeName: path);
    } catch (e) {
      return RouteResult.error(e.toString(), routeName: path);
    }
  }

  /// 导航到弹窗
  Future<RouteResult<T?>> pushDialog<T>(
    dynamic routeName, {
    Map<String, dynamic>? arguments,
    bool withContainer = false,
  }) async {
    final String path = routeName is RoutePath ? routeName.path : routeName as String;
    try {
      final route = RouteConfig().getRoute(path);
      if (route == null) {
        return RouteResult.error('Route not found: $path');
      }

      final canProceed = await _middlewareManager.executeChain(
        path,
        arguments,
        route.middlewares,
      );

      if (!canProceed) {
        return RouteResult.cancelled(routeName: path);
      }

      final result = await BoostNavigator.instance.push(
        path,
        withContainer: withContainer,
        opaque: false,
        arguments: arguments,
      );

      _updateCurrentRoute(path);
      return RouteResult.success(result as T?, routeName: path);
    } catch (e) {
      return RouteResult.error(e.toString(), routeName: path);
    }
  }

  /// 导航到透明弹窗
  Future<RouteResult<T?>> pushTransparentDialog<T>(
    dynamic routeName, {
    Map<String, dynamic>? arguments,
    bool withContainer = false,
  }) async {
    final String path = routeName is RoutePath ? routeName.path : routeName as String;
    try {
      final route = RouteConfig().getRoute(path);
      if (route == null) {
        return RouteResult.error('Route not found: $path');
      }

      final canProceed = await _middlewareManager.executeChain(
        path,
        arguments,
        route.middlewares,
      );

      if (!canProceed) {
        return RouteResult.cancelled(routeName: path);
      }

      final result = await BoostNavigator.instance.push(
        path,
        withContainer: withContainer,
        opaque: false,
        arguments: arguments,
      );

      _updateCurrentRoute(path);
      return RouteResult.success(result as T?, routeName: path);
    } catch (e) {
      return RouteResult.error(e.toString(), routeName: path);
    }
  }

  /// 导航到底部弹窗
  Future<RouteResult<T?>> pushBottomSheet<T>(
    dynamic routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    final String path = routeName is RoutePath ? routeName.path : routeName as String;
    try {
      final route = RouteConfig().getRoute(path);
      if (route == null) {
        return RouteResult.error('Route not found: $path');
      }

      final canProceed = await _middlewareManager.executeChain(
        path,
        arguments,
        route.middlewares,
      );

      if (!canProceed) {
        return RouteResult.cancelled(routeName: path);
      }

      final result = await BoostNavigator.instance.push(
        path,
        withContainer: false,
        opaque: false,
        arguments: arguments,
      );

      _updateCurrentRoute(path);
      return RouteResult.success(result as T?, routeName: path);
    } catch (e) {
      return RouteResult.error(e.toString(), routeName: path);
    }
  }

  /// 关闭当前页面
  void pop<T>([T? result]) {
    BoostNavigator.instance.pop(result);
  }

  /// 关闭多个页面
  void popUntil(String routeName) {
    // Flutter Boost 不直接支持 popUntil，需要实现自定义逻辑
    // 这里可以根据实际情况实现
  }

  /// 替换当前页面
  Future<RouteResult<T?>> replace<T>(
    dynamic routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    final String path = routeName is RoutePath ? routeName.path : routeName as String;
    try {
      pop(); // 先关闭当前页面
      return await push<T>(path, arguments: arguments);
    } catch (e) {
      return RouteResult.error(e.toString(), routeName: path);
    }
  }

  /// 清空路由栈并导航
  Future<RouteResult<T?>> pushAndRemoveUntil<T>(
    dynamic routeName, {
    Map<String, dynamic>? arguments,
    dynamic untilRoute,
  }) async {
    final String path = routeName is RoutePath ? routeName.path : routeName as String;
    try {
      // Flutter Boost 不直接支持 pushAndRemoveUntil
      // 这里可以根据实际情况实现
      return await push<T>(path, arguments: arguments);
    } catch (e) {
      return RouteResult.error(e.toString(), routeName: path);
    }
  }

  /// 获取当前路由名称
  String? get currentRoute => _currentRoute;

  /// 检查路由是否存在
  bool hasRoute(dynamic routeName) {
    final String path = routeName is RoutePath ? routeName.path : routeName as String;
    return RouteConfig().hasRoute(path);
  }

  /// 监听路由变化
  Stream<String> get routeChanges => _routeChangesController.stream;

  void _updateCurrentRoute(String routeName) {
    _currentRoute = routeName;
    _routeChangesController.add(routeName);
  }

  /// 清理资源
  void dispose() {
    _routeChangesController.close();
  }
}

/// 扩展方法 - 让调用更简洁
extension NavigatorServiceExtensions on BuildContext {
  NavigatorService get nav => NavigatorService();

  Future<RouteResult<T?>> push<T>(dynamic routeName, {Map<String, dynamic>? arguments}) {
    return NavigatorService().push<T>(routeName, arguments: arguments);
  }

  Future<RouteResult<T?>> pushDialog<T>(dynamic routeName, {Map<String, dynamic>? arguments}) {
    return NavigatorService().pushDialog<T>(routeName, arguments: arguments);
  }

  Future<RouteResult<T?>> pushBottomSheet<T>(dynamic routeName, {Map<String, dynamic>? arguments}) {
    return NavigatorService().pushBottomSheet<T>(routeName, arguments: arguments);
  }

  Future<RouteResult<T?>> pushTransparentDialog<T>(dynamic routeName, {Map<String, dynamic>? arguments}) {
    return NavigatorService().pushTransparentDialog<T>(routeName, arguments: arguments);
  }
}