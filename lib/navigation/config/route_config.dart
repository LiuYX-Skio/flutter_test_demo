import '../core/route_definition.dart';

/// 路由配置管理器
class RouteConfig {
  static final RouteConfig _instance = RouteConfig._internal();
  factory RouteConfig() => _instance;
  RouteConfig._internal();

  final Map<String, RouteDefinition> _routes = {};
  final List<RouteMiddleware> _globalMiddlewares = [];

  /// 注册单个路由
  void registerRoute(RouteDefinition route) {
    _routes[route.name] = route;
  }

  /// 批量注册路由
  void registerRoutes(Map<String, RouteDefinition> routes) {
    _routes.addAll(routes);
  }

  /// 注册全局中间件
  void registerGlobalMiddleware(RouteMiddleware middleware) {
    _globalMiddlewares.add(middleware);
  }

  /// 获取路由定义
  RouteDefinition? getRoute(String name) => _routes[name];

  /// 获取所有路由
  Map<String, RouteDefinition> get allRoutes => Map.unmodifiable(_routes);

  /// 获取全局中间件
  List<RouteMiddleware> get globalMiddlewares => List.unmodifiable(_globalMiddlewares);

  /// 检查路由是否存在
  bool hasRoute(String name) => _routes.containsKey(name);

  /// 清除所有路由
  void clearRoutes() {
    _routes.clear();
  }

  /// 移除路由
  void removeRoute(String name) {
    _routes.remove(name);
  }
}