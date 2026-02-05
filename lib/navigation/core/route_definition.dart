import 'package:flutter/widgets.dart';

/// 路由类型枚举
enum RouteType {
  /// 普通页面
  page,

  /// 弹窗/对话框
  dialog,

  /// 底部弹窗
  bottomSheet,

  /// 透明弹窗
  transparentDialog,
}

/// 页面过渡类型
enum PageTransition {
  /// 默认过渡
  defaultTransition,

  /// 无过渡
  none,

  /// 淡入淡出
  fade,

  /// 滑动过渡
  slide,

  /// 缩放过渡
  scale,

  /// 旋转过渡
  rotation,
}

/// 路由定义类
class RouteDefinition {
  /// 路由名称
  final String name;

  /// 页面构造器
  final WidgetBuilder builder;

  /// 路由类型
  final RouteType type;

  /// 是否需要原生容器
  final bool withContainer;

  /// 是否透明
  final bool opaque;

  /// 背景颜色（用于弹窗）
  final Color? barrierColor;

  /// 页面过渡类型
  final PageTransition transition;

  /// 是否保持页面状态
  final bool maintainState;

  /// 是否全屏显示
  final bool fullscreenDialog;

  /// 中间件列表
  final List<RouteMiddleware> middlewares;

  const RouteDefinition({
    required this.name,
    required this.builder,
    this.type = RouteType.page,
    this.withContainer = false,
    this.opaque = true,
    this.barrierColor,
    this.transition = PageTransition.defaultTransition,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.middlewares = const [],
  });

  /// 创建弹窗路由定义
  factory RouteDefinition.dialog({
    required String name,
    required WidgetBuilder builder,
    bool withContainer = false,
    bool opaque = false,
    Color? barrierColor,
    List<RouteMiddleware> middlewares = const [],
  }) {
    return RouteDefinition(
      name: name,
      builder: builder,
      type: RouteType.dialog,
      withContainer: withContainer,
      opaque: opaque,
      barrierColor: barrierColor,
      middlewares: middlewares,
    );
  }

  /// 创建透明弹窗路由定义
  factory RouteDefinition.transparentDialog({
    required String name,
    required WidgetBuilder builder,
    bool withContainer = false,
    Color? barrierColor,
    List<RouteMiddleware> middlewares = const [],
  }) {
    return RouteDefinition(
      name: name,
      builder: builder,
      type: RouteType.transparentDialog,
      withContainer: withContainer,
      opaque: false,
      barrierColor: barrierColor ?? const Color(0x00000000),
      middlewares: middlewares,
    );
  }

  /// 创建底部弹窗路由定义
  factory RouteDefinition.bottomSheet({
    required String name,
    required WidgetBuilder builder,
    List<RouteMiddleware> middlewares = const [],
  }) {
    return RouteDefinition(
      name: name,
      builder: builder,
      type: RouteType.bottomSheet,
      withContainer: false,
      opaque: false,
      middlewares: middlewares,
    );
  }
}

/// 路由中间件抽象类
abstract class RouteMiddleware {
  /// 执行中间件逻辑
  Future<bool> process(String routeName, Map<String, dynamic>? arguments);

  /// 中间件名称
  String get name;
}

/// 认证中间件
class AuthMiddleware extends RouteMiddleware {
  @override
  String get name => 'auth';

  @override
  Future<bool> process(String routeName, Map<String, dynamic>? arguments) async {
    // 实现认证检查逻辑
    // 返回 true 表示允许导航，false 表示阻止
    return true;
  }
}

/// 日志中间件
class LoggingMiddleware extends RouteMiddleware {
  @override
  String get name => 'logging';

  @override
  Future<bool> process(String routeName, Map<String, dynamic>? arguments) async {
    print('导航到路由: $routeName, 参数: $arguments');
    return true;
  }
}