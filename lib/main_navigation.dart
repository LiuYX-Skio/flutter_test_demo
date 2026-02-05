import 'package:flutter/material.dart';
import 'package:flutter_test_demo/CustomFlutterBinding.dart';
import 'navigation/navigation_initializer.dart';

/// 使用导航框架的简化版main函数
void main() {
  CustomFlutterBinding();
  runApp(const MyNavigationApp());
}

/// 简化版应用 - 使用导航框架
class MyNavigationApp extends StatelessWidget {
  const MyNavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigationApp();
  }
}

/// 或者如果你想保留原有的初始化逻辑，可以这样写：
/*
void main() {
  CustomFlutterBinding();

  // 初始化导航框架（只需要这一行）
  NavigationInitializer.initialize();

  runApp(const MyNavigationApp());
}

class MyNavigationApp extends StatefulWidget {
  const MyNavigationApp({super.key});

  @override
  State<MyNavigationApp> createState() => _MyNavigationAppState();
}

class _MyNavigationAppState extends State<MyNavigationApp> {
  @override
  Widget build(BuildContext context) {
    return FlutterBoostApp(
      _routeFactory,
      appBuilder: _appBuilder,
      initialRoute: "home",
    );
  }

  Widget _appBuilder(Widget home) {
    return MaterialApp(
      home: home,
      debugShowCheckedModeBanner: false,
      builder: (_, __) => home,
    );
  }

  Route<dynamic>? _routeFactory(
    RouteSettings settings,
    bool isContainerPage,
    String? uniqueId,
  ) {
    final routes = NavigationInitializer.getBoostRoutes();
    final FlutterBoostRouteFactory? func = routes[settings.name];
    return func?.call(settings, isContainerPage, uniqueId);
  }
}
*/