import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_test_demo/app/pages/splash/splash_page.dart';
import 'route_definition.dart';
import 'route_paths.dart';
import '../config/route_config.dart';
import '../../app/pages/home/home_providers.dart';
import '../../app/pages/detail/shop_detail_page.dart';
import '../../app/pages/login/login_providers.dart';
import '../../app/pages/webview/webview_page.dart';

/// 路由注册器 - 统一管理所有路由注册
class RouteRegistry {
  static final RouteRegistry _instance = RouteRegistry._internal();

  factory RouteRegistry() => _instance;

  RouteRegistry._internal();

  /// 初始化所有路由
  void initialize() {
    // 注册基础路由
    _registerBaseRoutes();

    // 注册功能模块路由
    _registerAuthRoutes();
    _registerUserRoutes();
    _registerProductRoutes();
    _registerOtherRoutes();

    // 注册全局中间件
    _registerGlobalMiddlewares();
  }

  /// 获取 Flutter Boost 路由工厂
  Map<String, FlutterBoostRouteFactory> getBoostRouteFactory() {
    final routes = <String, FlutterBoostRouteFactory>{};

    for (final routeEntry in RouteConfig().allRoutes.entries) {
      final route = routeEntry.value;
      routes[route.name] = _createBoostRouteFactory(route);
    }

    print("路由表数量${routes.length}");

    return routes;
  }

  /// 注册基础路由
  void _registerBaseRoutes() {
    RouteConfig().registerRoutes({
      RoutePaths.home.path: RouteDefinition(
        name: RoutePaths.home.path,
        builder: (context) => const HomeProviders(),
      ),
      RoutePaths.splash.path: RouteDefinition(
        name: RoutePaths.splash.path,
        builder: (context) => const SplashPage(),
      ),
      RoutePaths.welcome.path: RouteDefinition(
        name: RoutePaths.welcome.path,
        builder: (context) => const _PlaceholderPage(title: '欢迎页'),
      ),
    });
  }

  /// 注册认证相关路由
  void _registerAuthRoutes() {
    RouteConfig().registerRoutes({
      RoutePaths.auth.login.path: RouteDefinition(
        name: RoutePaths.auth.login.path,
        builder: (context) => const LoginProviders(),
      ),
      RoutePaths.auth.register.path: RouteDefinition(
        name: RoutePaths.auth.register.path,
        builder: (context) => const _PlaceholderPage(title: '注册'),
      ),
      RoutePaths.auth.forgotPassword.path: RouteDefinition(
        name: RoutePaths.auth.forgotPassword.path,
        builder: (context) => const _PlaceholderPage(title: '忘记密码'),
      ),
      RoutePaths.auth.verifyCode.path: RouteDefinition.dialog(
        name: RoutePaths.auth.verifyCode.path,
        builder: (context) => const _PlaceholderPage(title: '验证码'),
        opaque: false,
      ),
    });
  }

  /// 注册用户相关路由
  void _registerUserRoutes() {
    RouteConfig().registerRoutes({
      RoutePaths.user.profile.path: RouteDefinition(
        name: RoutePaths.user.profile.path,
        builder: (context) => const _PlaceholderPage(title: '个人资料'),
        withContainer: true,
      ),
      RoutePaths.user.settings.path: RouteDefinition(
        name: RoutePaths.user.settings.path,
        builder: (context) => const _PlaceholderPage(title: '设置'),
      ),
      RoutePaths.user.editProfile.path: RouteDefinition(
        name: RoutePaths.user.editProfile.path,
        builder: (context) => const _PlaceholderPage(title: '编辑资料'),
      ),
      RoutePaths.user.changePassword.path: RouteDefinition(
        name: RoutePaths.user.changePassword.path,
        builder: (context) => const _PlaceholderPage(title: '修改密码'),
      ),
      RoutePaths.user.avatarCrop.path: RouteDefinition.dialog(
        name: RoutePaths.user.avatarCrop.path,
        builder: (context) => const _PlaceholderPage(title: '裁剪头像'),
        opaque: false,
      ),
    });
  }

  /// 注册商品相关路由
  void _registerProductRoutes() {
    RouteConfig().registerRoutes({
      RoutePaths.product.list.path: RouteDefinition(
        name: RoutePaths.product.list.path,
        builder: (context) => const _PlaceholderPage(title: '商品列表'),
      ),
      RoutePaths.product.detail.path: RouteDefinition(
        name: RoutePaths.product.detail.path,
        builder: (context) {
          // 从路由参数中获取商品ID
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final productId = args?['id'] as int? ?? 0;
          return ShopDetailPage(productId: productId);
        },
      ),
      RoutePaths.product.search.path: RouteDefinition(
        name: RoutePaths.product.search.path,
        builder: (context) => const _PlaceholderPage(title: '商品搜索'),
      ),
      RoutePaths.product.category.path: RouteDefinition(
        name: RoutePaths.product.category.path,
        builder: (context) => const _PlaceholderPage(title: '商品分类'),
      ),
      RoutePaths.product.cart.path: RouteDefinition(
        name: RoutePaths.product.cart.path,
        builder: (context) => const _PlaceholderPage(title: '购物车'),
      ),
      RoutePaths.product.checkout.path: RouteDefinition(
        name: RoutePaths.product.checkout.path,
        builder: (context) => const _PlaceholderPage(title: '结算'),
      ),
      RoutePaths.product.orderConfirm.path: RouteDefinition.dialog(
        name: RoutePaths.product.orderConfirm.path,
        builder: (context) => const _PlaceholderPage(title: '订单确认'),
        opaque: false,
      ),
    });
  }

  /// 注册其他功能路由
  void _registerOtherRoutes() {
    RouteConfig().registerRoutes({
      RoutePaths.other.notificationList.path: RouteDefinition(
        name: RoutePaths.other.notificationList.path,
        builder: (context) => const _PlaceholderPage(title: '消息列表'),
      ),
      RoutePaths.other.notificationDetail.path: RouteDefinition(
        name: RoutePaths.other.notificationDetail.path,
        builder: (context) => const _PlaceholderPage(title: '消息详情'),
      ),
      RoutePaths.other.feedback.path: RouteDefinition(
        name: RoutePaths.other.feedback.path,
        builder: (context) => const _PlaceholderPage(title: '意见反馈'),
      ),
      RoutePaths.other.about.path: RouteDefinition(
        name: RoutePaths.other.about.path,
        builder: (context) => const _PlaceholderPage(title: '关于我们'),
      ),
      RoutePaths.other.webview.path: RouteDefinition(
        name: RoutePaths.other.webview.path,
        builder: (context) {
          // 从路由参数中获取URL和标题
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final url = args?['url'] as String? ?? '';
          final title = args?['title'] as String? ?? '网页视图';
          return WebViewPage(url: url, title: title);
        },
        withContainer: true,
      ),
      RoutePaths.other.share.path: RouteDefinition(
        name: RoutePaths.other.share.path,
        builder: (context) => const _PlaceholderPage(title: '分享'),
        type: RouteType.bottomSheet,
        withContainer: false,
        opaque: false,
      ),
      RoutePaths.other.imagePreview.path: RouteDefinition(
        name: RoutePaths.other.imagePreview.path,
        builder: (context) => const _PlaceholderPage(title: '图片预览'),
        type: RouteType.transparentDialog,
        withContainer: false,
        opaque: false,
        barrierColor: null,
      ),
      RoutePaths.other.loading.path: RouteDefinition(
        name: RoutePaths.other.loading.path,
        builder: (context) => const _PlaceholderPage(title: '加载中'),
        type: RouteType.transparentDialog,
        withContainer: false,
        opaque: false,
        barrierColor: null,
      ),
      RoutePaths.other.confirm.path: RouteDefinition.dialog(
        name: RoutePaths.other.confirm.path,
        builder: (context) => const _PlaceholderPage(title: '确认对话框'),
        opaque: false,
      ),
      RoutePaths.other.error.path: RouteDefinition.dialog(
        name: RoutePaths.other.error.path,
        builder: (context) => const _PlaceholderPage(title: '错误提示'),
        opaque: false,
      ),
      // 月付相关路由
      RoutePaths.other.supplementMessage.path: RouteDefinition(
        name: RoutePaths.other.supplementMessage.path,
        builder: (context) => const _PlaceholderPage(title: '补充信息'),
        withContainer: true,
      ),
      RoutePaths.other.authMessage.path: RouteDefinition(
        name: RoutePaths.other.authMessage.path,
        builder: (context) => const _PlaceholderPage(title: '认证信息'),
        withContainer: true,
      ),
    });
  }

  /// 注册全局中间件
  void _registerGlobalMiddlewares() {
    // 这里可以注册一些基础的全局中间件
    // RouteConfig().registerGlobalMiddleware(LoggingMiddleware());
    // RouteConfig().registerGlobalMiddleware(CrashReportingMiddleware());
  }

  /// 创建 Flutter Boost 路由工厂
  FlutterBoostRouteFactory _createBoostRouteFactory(RouteDefinition route) {
    return (RouteSettings settings, bool isContainerPage, String? uniqueId) {
      switch (route.type) {
        case RouteType.page:
          return CupertinoPageRoute<dynamic>(
            settings: settings,
            builder: route.builder, // 直接透传builder
            maintainState: route.maintainState,
            fullscreenDialog: route.fullscreenDialog,
          );

        case RouteType.dialog:
          return CupertinoDialogRoute<dynamic>(
            settings: settings,
            context: settings.arguments as BuildContext,
            // 需透传context（关键）
            builder: (context) => route.builder(context),
            barrierColor: route.barrierColor ?? Colors.black54,
            barrierDismissible: true, // 点击遮罩关闭（可配置）
          );

        case RouteType.transparentDialog:
          return PageRouteBuilder<dynamic>(
            settings: settings,
            opaque: false,
            // 透明核心
            barrierColor: route.barrierColor ?? Colors.black12,
            maintainState: route.maintainState,
            // 模拟 Cupertino 动画
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return CupertinoPageTransition(
                primaryRouteAnimation: animation,
                secondaryRouteAnimation: secondaryAnimation,
                linearTransition: false,
                child: child,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) =>
                route.builder(context),
          );

        case RouteType.bottomSheet:
          return CupertinoModalPopupRoute<dynamic>(
            settings: settings,
            builder: route.builder, // 底部弹窗内容
            barrierColor: route.barrierColor ?? Colors.black12,
            barrierDismissible: true, // 点击遮罩关闭
          );
      }
    };
  }

  /// 动态注册路由（运行时添加）
  void registerRoute(RouteDefinition route) {
    RouteConfig().registerRoute(route);
  }

  /// 批量注册路由（运行时添加）
  void registerRoutes(Map<String, RouteDefinition> routes) {
    RouteConfig().registerRoutes(routes);
  }

  /// 移除路由
  void unregisterRoute(String routeName) {
    RouteConfig().removeRoute(routeName);
  }

  /// 清空所有路由
  void clearRoutes() {
    RouteConfig().clearRoutes();
  }

  /// 获取所有已注册的路由
  Map<String, RouteDefinition> get allRoutes => RouteConfig().allRoutes;

  /// 检查路由是否存在
  bool hasRoute(String routeName) => RouteConfig().hasRoute(routeName);
}

/// 占位页面组件 - 用于开发阶段
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            const Text(
              '这是一个占位页面\n请替换为实际的页面组件',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
