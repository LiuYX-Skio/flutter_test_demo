import 'route_definition.dart';

/// 中间件管理器
class MiddlewareManager {
  final List<RouteMiddleware> _middlewares = [];

  /// 添加中间件
  void addMiddleware(RouteMiddleware middleware) {
    _middlewares.add(middleware);
  }

  /// 移除中间件
  void removeMiddleware(String name) {
    _middlewares.removeWhere((m) => m.name == name);
  }

  /// 执行中间件链
  Future<bool> executeChain(
      String routeName,
      Map<String, dynamic>? arguments,
      List<RouteMiddleware> additionalMiddlewares,
      ) async {
    final allMiddlewares = [..._middlewares, ...additionalMiddlewares];

    for (final middleware in allMiddlewares) {
      final result = await middleware.process(routeName, arguments);
      if (!result) {
        return false; // 中间件阻止了导航
      }
    }

    return true;
  }

  /// 清空中介件
  void clear() {
    _middlewares.clear();
  }
}