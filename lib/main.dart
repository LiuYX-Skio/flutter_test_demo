import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_demo/CustomFlutterBinding.dart';
import 'package:flutter_test_demo/app/constants/app_constants.dart';
import 'package:flutter_test_demo/navigation/core/route_paths.dart';
import '../core/framework_initializer.dart';
import 'navigation/navigation_initializer.dart';

void main() {
  CustomFlutterBinding();
  // 初始化所有框架
  FrameworkInitializer.initAll(
    FrameworkConfig(
      networkConfig: NetworkConfig(
        baseUrl: AppConstants.baseUrl,
        enableLog: true,
      ),
      initNavigation: true,
    ),
  );
  runApp(const ShopApp());
}

class ShopApp extends StatefulWidget {
  const ShopApp({super.key});

  @override
  State<ShopApp> createState() => _NavigationAppState();
}

class _NavigationAppState extends State<ShopApp> {
  @override
  void initState() {
    super.initState();
  }

  /// 应用构建器
  Widget appBuilder(Widget home) {
    return ScreenUtilInit(
        designSize: const Size(375, 817),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: home,
            builder: (_, __) {
              return home;
            },
          );
        });
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
      initialRoute: RoutePaths.splash.path, // 使用新的路由名称
    );
  }
}
