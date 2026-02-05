# Flutter Boost 路由框架

一个基于 Flutter Boost 封装的上层路由框架，提供简单明了的导航 API，支持中间件、类型安全的结果处理、跨平台桥接和完整的生命周期管理。

## 🚀 快速开始

### 1. 初始化框架

在你的 `main.dart` 中，只需要一行代码：

```dart
import 'navigation/navigation_initializer.dart';

void main() {
  // 初始化导航框架（包含所有路由注册）
  NavigationInitializer.initialize();

  runApp(const MyApp());
}
```

### 2. 使用简化版应用组件

```dart
import 'navigation/navigation_initializer.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigationApp(); // 自动处理所有路由配置
  }
}
```

### 3. 在页面中使用导航

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // 使用路由对象（推荐 - 类型安全）
            final result = await context.nav.push(RoutePaths.user.profile);

            if (result.success) {
              print('跳转成功');
            }
          },
          child: const Text('查看个人资料'),
        ),
      ),
    );
  }
}
```

## 📋 框架特性

### ✅ 自动路由注册
框架预定义了完整的路由集合，涵盖：
- 基础路由（home, splash, welcome）
- 认证路由（login, register, forgot_password）
- 用户路由（profile, settings, edit_profile）
- 商品路由（list, detail, search, cart）
- 其他功能路由（notification, feedback, webview）

### ✅ 类型安全的路由对象
```dart
// 使用路由对象 - 类型安全，避免硬编码字符串
await context.nav.push(RoutePaths.user.profile);
await context.nav.pushDialog(RoutePaths.auth.login);
await context.nav.pushBottomSheet(RoutePaths.other.share);

// 重构时只需要修改一处，无需全局搜索替换
class RoutePaths {
  static const user = UserRoutes._();
}

class UserRoutes {
  const UserRoutes._();
  final profile = const RoutePath('user/profile'); // 只需修改这里
}
```

### ✅ 多种导航类型
```dart
// 普通页面
context.nav.push(RoutePaths.user.profile);

// 弹窗
context.nav.pushDialog(RoutePaths.other.confirm);

// 透明弹窗
context.nav.pushTransparentDialog(RoutePaths.other.loading);

// 底部弹窗
context.nav.pushBottomSheet(RoutePaths.other.share);

// 仍然支持字符串方式（向后兼容）
context.nav.push('user/profile');
```

### ✅ 类型安全的结果处理
```dart
final result = await context.nav.push<String>('select_city');

if (result.success) {
  final city = result.data; // 类型安全
} else if (result.error == 'cancelled') {
  // 用户取消
}
```

### ✅ 中间件支持
```dart
// 注册全局中间件
RouteRegistry().registerGlobalMiddleware(AuthMiddleware());
RouteRegistry().registerGlobalMiddleware(LoggingMiddleware());

// 路由级中间件
RouteDefinition(
  name: 'admin',
  builder: (context) => AdminPage(),
  middlewares: [AuthMiddleware(), PermissionMiddleware()],
);
```

### ✅ 完整的生命周期管理
```dart
// 全局生命周期监听
class AppLifecycleObserver implements PageLifecycleObserver {
  @override
  void onPageShow(String routeName) {
    print("页面显示: $routeName");
    // 页面显示时的处理逻辑，如数据统计
    Analytics.trackPageView(routeName);
  }

  @override
  void onPageHide(String routeName) {
    print("页面隐藏: $routeName");
    // 页面隐藏时的处理逻辑
    Analytics.trackPageExit(routeName);
  }

  @override
  void onAppForeground(String routeName) {
    print("应用前台: $routeName");
    // 应用进入前台的处理逻辑
    AppTracker.onAppForeground();
  }

  @override
  void onAppBackground(String routeName) {
    print("应用后台: $routeName");
    // 应用进入后台的处理逻辑
    AppTracker.onAppBackground();
  }

  // 实现其他必需方法
  @override
  void onPageCreated(String routeName) {}

  @override
  void onPageDestroyed(String routeName) {}

  @override
  void onLifecycleChanged(String routeName, PageLifecycleState state) {}
}
  @override
  void onPageShow(String routeName) {
    super.onPageShow(routeName);
    // 页面显示时的处理逻辑
  }

  @override
  void onAppForeground(String routeName) {
    super.onAppForeground(routeName);
    // 应用进入前台的处理逻辑
  }
}

// 页面级生命周期监听
class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with PageLifecycleMixin<MyPage> {
  @override
  void onPageShow() {
    // 页面显示时调用 - 自动触发，无需手动注册
    print('页面显示');
    // 开始商品浏览计时
    _startViewTimer();
  }

  @override
  void onPageHide() {
    // 页面隐藏时调用
    print('页面隐藏');
    // 停止计时
    _stopViewTimer();
  }

  @override
  void onAppForeground() {
    // 应用回到前台时调用
    print('应用前台');
    // 刷新数据
    _refreshData();
  }

  @override
  void onAppBackground() {
    // 应用进入后台时调用
    print('应用后台');
    // 保存状态
    _saveState();
  }

  void _startViewTimer() {}
  void _stopViewTimer() {}
  void _refreshData() {}
  void _saveState() {}
}
```

### ✅ 高性能单例模式
```dart
// NavigatorService 是单例模式，每次调用返回同一个实例
final nav1 = NavigatorService(); // 返回单例实例
final nav2 = NavigatorService(); // 返回同一个实例
assert(nav1 == nav2); // true

// 便捷的扩展方法，内部使用单例
context.nav.push('route'); // 高效，无额外开销

// 直接调用工厂构造函数
NavigatorService().push('route'); // 同样高效
```

### ✅ 跨平台桥接
```dart
// Flutter 跳转到原生
PlatformBridge().pushNative('native_settings');

// 原生跳转到 Flutter
PlatformBridge().pushFromNative('flutter_page');
```

## 📖 详细使用方法

### 路由注册

框架已经预注册了所有常用路由，你也可以动态添加：

```dart
// 动态注册路由
RouteRegistry().registerRoute(
  RouteDefinition(
    name: 'custom_page',
    builder: (context) => const CustomPage(),
  ),
);

// 批量注册
RouteRegistry().registerRoutes({
  'page1': RouteDefinition(name: 'page1', builder: (context) => Page1()),
  'page2': RouteDefinition(name: 'page2', builder: (context) => Page2()),
});
```

### 导航方法

#### 基础导航
```dart
// 带参数的页面跳转
final result = await context.nav.push(
  'product/detail',
  arguments: {'productId': '123'},
);

// 替换当前页面
await context.nav.replace('new_page');

// 清空路由栈并跳转
await context.nav.pushAndRemoveUntil('home');
```

#### 弹窗导航
```dart
// 确认对话框
final confirmResult = await context.nav.pushDialog<bool>('confirm');

// 选择对话框
final choiceResult = await context.nav.pushDialog<String>('select_option');

// 透明加载弹窗
await context.nav.pushTransparentDialog('loading');
```

#### 页面关闭
```dart
// 关闭当前页面
NavigatorService().pop();

// 关闭并返回结果
NavigatorService().pop('selected_value');

// 关闭到指定路由
NavigatorService().popUntil('home');
```

### 结果处理

```dart
class CitySelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('北京'),
          onTap: () => NavigatorService().pop(
            RouteResult.success('北京')
          ),
        ),
        ListTile(
          title: const Text('上海'),
          onTap: () => NavigatorService().pop(
            RouteResult.success('上海')
          ),
        ),
        // 取消按钮
        TextButton(
          onPressed: () => NavigatorService().pop(
            RouteResult.cancelled()
          ),
          child: const Text('取消'),
        ),
      ],
    );
  }
}

// 使用时
final result = await context.nav.push<String>('city_selector');
if (result.success) {
  print('选择的城市: ${result.data}');
} else if (result.error == 'cancelled') {
  print('用户取消选择');
}
```

### 中间件

#### 创建中间件
```dart
class AuthMiddleware extends RouteMiddleware {
  @override
  String get name => 'auth';

  @override
  Future<bool> process(String routeName, Map<String, dynamic>? arguments) async {
    final isLoggedIn = await checkLoginStatus();

    if (!isLoggedIn && _requiresAuth(routeName)) {
      // 未登录，跳转到登录页
      await NavigatorService().push('auth/login');
      return false; // 阻止原导航
    }

    return true; // 允许导航
  }

  bool _requiresAuth(String routeName) {
    return routeName.startsWith('user/') ||
           routeName.startsWith('product/cart');
  }
}
```

#### 注册中间件
```dart
// 全局中间件（所有路由）
RouteRegistry().registerGlobalMiddleware(AuthMiddleware());
RouteRegistry().registerGlobalMiddleware(LoggingMiddleware());

// 路由级中间件（特定路由）
RouteRegistry().registerRoute(
  RouteDefinition(
    name: 'admin/panel',
    builder: (context) => AdminPanel(),
    middlewares: [
      AuthMiddleware(),
      AdminPermissionMiddleware(),
    ],
  ),
);
```

### 生命周期管理

#### 全局生命周期监听

```dart
void main() {
  // 初始化导航框架（已包含默认的全局生命周期监听）
  NavigationInitializer.initialize();

  // 可以添加自定义的全局生命周期观察者
  PageLifecycleManager().addGlobalObserver(
    SimpleGlobalLifecycleObserver(
      onStateChanged: (routeName, state) {
        switch (state) {
          case PageLifecycleState.showed:
            // 页面显示 - 对应 Android onResume, iOS viewDidAppear
            Analytics.trackPageView(routeName);
            break;
          case PageLifecycleState.hidden:
            // 页面隐藏 - 对应 Android onStop, iOS viewDidDisappear
            Analytics.trackPageExit(routeName);
            break;
          case PageLifecycleState.foreground:
            // 应用进入前台
            AppTracker.onAppForeground();
            break;
          case PageLifecycleState.background:
            // 应用进入后台
            AppTracker.onAppBackground();
            break;
          default:
            break;
        }
      },
    ),
  );

  runApp(const MyApp());
}
```

#### 自定义全局生命周期观察者

```dart
class AppLifecycleObserver extends GlobalPageLifecycleObserver {
  @override
  void onPageCreated(String routeName) {
    super.onPageCreated(routeName);
    print("页面创建: $routeName");
    // 可以在这里初始化页面相关的数据
  }

  @override
  void onPageShow(String routeName) {
    super.onPageShow(routeName);
    print("页面显示: $routeName");
    // 页面显示时的业务逻辑，如开始计时、刷新数据等
  }

  @override
  void onPageHide(String routeName) {
    super.onPageHide(routeName);
    print("页面隐藏: $routeName");
    // 页面隐藏时的业务逻辑，如暂停计时、保存状态等
  }

  @override
  void onPageDestroyed(String routeName) {
    super.onPageDestroyed(routeName);
    print("页面销毁: $routeName");
    // 页面销毁时的清理逻辑
  }

  @override
  void onAppForeground(String routeName) {
    super.onAppForeground(routeName);
    print("应用前台: $routeName");
    // 应用回到前台的处理，如重新连接网络、刷新数据等
  }

  @override
  void onAppBackground(String routeName) {
    super.onAppBackground(routeName);
    print("应用后台: $routeName");
    // 应用进入后台的处理，如保存数据、断开连接等
  }
}

// 注册全局观察者
PageLifecycleManager().addGlobalObserver(AppLifecycleObserver());
```

#### 页面级生命周期监听

方法一：使用 PageLifecycleMixin（推荐）

```dart
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with PageLifecycleMixin<ProductDetailPage> {

  @override
  void onPageShow() {
    // 页面显示时调用 - 自动触发，无需手动注册
    print('商品详情页显示');
    // 开始商品浏览计时
    _startViewTimer();
    // 刷新商品数据
    _refreshProductData();
  }

  @override
  void onPageHide() {
    // 页面隐藏时调用
    print('商品详情页隐藏');
    // 停止计时
    _stopViewTimer();
    // 保存浏览记录
    _saveViewHistory();
  }

  @override
  void onAppForeground() {
    // 应用回到前台时调用
    print('应用回到前台');
    // 重新连接网络、刷新数据等
    _refreshProductData();
  }

  @override
  void onAppBackground() {
    // 应用进入后台时调用
    print('应用进入后台');
    // 保存草稿、断开不必要的连接等
    _saveDraft();
  }

  void _startViewTimer() {
    // 实现浏览计时逻辑
  }

  void _stopViewTimer() {
    // 停止计时并记录时长
  }

  void _refreshProductData() {
    // 刷新商品数据
  }

  void _saveViewHistory() {
    // 保存浏览历史
  }

  void _saveDraft() {
    // 保存草稿数据
  }
}
```

方法二：手动实现生命周期监听

```dart
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    implements PageLifecycleObserver {
  late PageLevelLifecycleObserver _observer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 手动注册生命周期观察者
    final route = ModalRoute.of(context)!;
    final routeName = route.settings.name ?? 'user_profile';
    _observer = PageLevelLifecycleObserver(this, routeName);
    PageVisibilityBinding.instance.addObserver(_observer, route);
  }

  @override
  void dispose() {
    // 手动移除生命周期观察者
    PageVisibilityBinding.instance.removeObserver(_observer);
    super.dispose();
  }

  @override
  void onPageShow(String routeName) {
    print("用户资料页显示");
    // 页面显示时的逻辑
  }

  @override
  void onPageHide(String routeName) {
    print("用户资料页隐藏");
    // 页面隐藏时的逻辑
  }

  @override
  void onAppForeground(String routeName) {
    print("应用前台 - 用户资料页");
    // 应用回到前台的逻辑
  }

  @override
  void onAppBackground(String routeName) {
    print("应用后台 - 用户资料页");
    // 应用进入后台的逻辑
  }

  // 实现其他必需方法
  @override
  void onPageCreated(String routeName) {}

  @override
  void onPageDestroyed(String routeName) {}

  @override
  void onLifecycleChanged(String routeName, PageLifecycleState state) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('用户资料')),
      body: const Center(
        child: Text('用户资料页面'),
      ),
    );
  }
}
```

### 路由监听

```dart
class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late StreamSubscription<String> _routeSubscription;

  @override
  void initState() {
    super.initState();

    // 监听路由变化
    _routeSubscription = NavigatorService().routeChanges.listen((route) {
      print('当前路由: $route');
      // 更新应用状态
      setState(() => _currentRoute = route);
    });
  }

  @override
  void dispose() {
    _routeSubscription.cancel();
    super.dispose();
  }
}
```

### 跨平台桥接

```dart
// Flutter 跳转到原生页面
final result = await PlatformBridge().pushNative<String>(
  'native_camera',
  arguments: {'quality': 'high'},
);

// 原生跳转到 Flutter 页面
final result = await PlatformBridge().pushFromNative<String>(
  'flutter_settings',
  arguments: {'section': 'account'},
);

// 发送结果回原生
PlatformBridge().sendResultToNative({
  'status': 'success',
  'data': userInfo,
});
```

## 🔧 高级配置

### 自定义路由注册

如果你需要完全自定义路由，可以继承 `RouteRegistry`：

```dart
class CustomRouteRegistry extends RouteRegistry {
  @override
  void initialize() {
    // 注册你的自定义路由
    registerRoutes({
      'my_page': RouteDefinition(
        name: 'my_page',
        builder: (context) => const MyPage(),
      ),
    });

    // 调用父类初始化
    super.initialize();
  }
}
```

### 路由分组管理

```dart
class RouteGroups {
  static const auth = [
    'auth/login',
    'auth/register',
    'auth/forgot_password',
  ];

  static const user = [
    'user/profile',
    'user/settings',
    'user/edit_profile',
  ];

  static const product = [
    'product/list',
    'product/detail',
    'product/cart',
  ];
}

// 使用
bool isAuthRoute(String route) => RouteGroups.auth.contains(route);
bool isUserRoute(String route) => RouteGroups.user.contains(route);
```

## 📚 完整示例

查看 `navigation_example.dart` 获取完整的用法示例。

## 🛠 框架架构

```
lib/navigation/
├── core/
│   ├── route_definition.dart     # 路由定义和配置
│   ├── navigator_service.dart    # 导航服务核心
│   ├── route_registry.dart       # 路由注册器 ⭐ 新增
│   ├── route_paths.dart          # 路由路径常量 ⭐ 新增
│   ├── lifecycle_observer.dart   # 生命周期管理 ⭐ 新增
│   └── middleware.dart          # 中间件系统
├── utils/
│   ├── route_result.dart        # 路由结果处理
│   └── platform_bridge.dart     # 跨平台桥接
├── config/
│   └── route_config.dart        # 路由配置管理
├── navigation_initializer.dart  # 初始化器 ⭐ 新增
├── navigation_example.dart      # 完整使用示例 ⭐ 新增
├── navigation_lifecycle_example.dart # 生命周期示例 ⭐ 新增
└── README.md                    # 文档
```

### 核心组件说明

- **route_definition.dart**: 路由定义、配置和路由类型枚举
- **navigator_service.dart**: 导航服务核心，封装 Flutter Boost API
- **route_registry.dart**: 路由注册器，统一管理路由注册
- **lifecycle_observer.dart**: 生命周期观察者系统，全局和页面级生命周期管理
- **middleware.dart**: 中间件系统，支持路由拦截和处理
- **route_result.dart**: 类型安全的结果处理
- **platform_bridge.dart**: 跨平台桥接，Flutter 与原生平台通信
- **route_config.dart**: 路由配置管理器
- **navigation_initializer.dart**: 框架初始化器，一键启动所有功能

这个框架让你只需要关心业务逻辑，无需处理复杂的路由配置！🎉