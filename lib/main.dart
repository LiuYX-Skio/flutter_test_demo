import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_demo/CustomFlutterBinding.dart';
import 'package:flutter_test_demo/app/constants/app_constants.dart';
import 'package:flutter_test_demo/app/provider/user_provider.dart';
import 'package:flutter_test_demo/navigation/core/route_paths.dart';
import '../core/framework_initializer.dart';
import 'navigation/navigation_initializer.dart';

void main() {
  runZonedGuarded(() {
      CustomFlutterBinding();
      // 初始化所有框架
      FrameworkInitializer.initAll(
        FrameworkConfig(
          networkConfig: NetworkConfig(
            baseUrl: AppConstants.baseUrl,
            enableLog: true,
            onGetToken: () async {
              return UserProvider.getUserToken();
            },
          ),
          initNavigation: true,
        ),
      );
      runApp(const ShopApp());
    },
    (dynamic error, dynamic stack) {
      print("Something went wrong!");
    },
  );
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
          builder: EasyLoading.init(),
        );
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
      initialRoute: RoutePaths.home.path, // 使用新的路由名称
    );
  }
}
