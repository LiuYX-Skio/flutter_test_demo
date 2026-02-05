/// 路由结果类
class RouteResult<T> {
  final bool success;
  final T? data;
  final String? error;
  final String? routeName;

  const RouteResult._({
    required this.success,
    this.data,
    this.error,
    this.routeName,
  });

  /// 成功结果
  factory RouteResult.success(T data, {String? routeName}) {
    return RouteResult._(
      success: true,
      data: data,
      routeName: routeName,
    );
  }

  /// 失败结果
  factory RouteResult.error(String error, {String? routeName}) {
    return RouteResult._(
      success: false,
      error: error,
      routeName: routeName,
    );
  }

  /// 取消结果
  factory RouteResult.cancelled({String? routeName}) {
    return RouteResult._(
      success: false,
      error: 'cancelled',
      routeName: routeName,
    );
  }
}

/// 类型化的路由结果
class TypedRouteResult<T> extends RouteResult<T> {
  const TypedRouteResult._({
    required super.success,
    super.data,
    super.error,
    super.routeName,
  }) : super._();

  factory TypedRouteResult.success(T data, {String? routeName}) {
    return TypedRouteResult._(
      success: true,
      data: data,
      routeName: routeName,
    );
  }
}