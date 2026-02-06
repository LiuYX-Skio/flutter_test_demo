import 'package:flutter/widgets.dart';
import 'package:flutter_boost/flutter_boost.dart';

/// 页面生命周期状态
enum PageLifecycleState {
  /// 页面创建
  created,

  /// 页面显示
  showed,

  /// 页面隐藏
  hidden,

  /// 页面销毁
  destroyed,

  /// 应用进入前台
  foreground,

  /// 应用进入后台
  background,
}

/// 页面生命周期观察者接口
abstract class PageLifecycleObserver {
  /// 页面创建时调用
  void onPageCreated(String routeName) {}

  /// 页面显示时调用（对应 onPageShow）
  void onPageShow(String routeName) {}

  /// 页面隐藏时调用（对应 onPageHide）
  void onPageHide(String routeName) {}

  /// 页面销毁时调用
  void onPageDestroyed(String routeName) {}

  /// 应用进入前台时调用
  void onAppForeground(String routeName) {}

  /// 应用进入后台时调用
  void onAppBackground(String routeName) {}

  /// 生命周期状态变化
  void onLifecycleChanged(String routeName, PageLifecycleState state) {}
}

/// 全局页面生命周期观察者
/// 实现 Flutter Boost 的 GlobalPageVisibilityObserver
class GlobalPageLifecycleObserver with GlobalPageVisibilityObserver {
  final PageLifecycleObserver? _observer;

  GlobalPageLifecycleObserver([this._observer]);

  @override
  void onPagePush(Route route) {
    super.onPagePush(route);
    final routeName = route.settings.name ?? 'unknown';
    _observer?.onPageCreated(routeName);
    _observer?.onLifecycleChanged(routeName, PageLifecycleState.created);
  }

  @override
  void onPagePop(Route route) {
    super.onPagePop(route);
    final routeName = route.settings.name ?? 'unknown';
    _observer?.onPageDestroyed(routeName);
    _observer?.onLifecycleChanged(routeName, PageLifecycleState.destroyed);
  }

  @override
  void onPageShow(Route route) {
    super.onPageShow(route);
    final routeName = route.settings.name ?? 'unknown';
    _observer?.onPageShow(routeName);
    _observer?.onLifecycleChanged(routeName, PageLifecycleState.showed);
  }

  @override
  void onPageHide(Route route) {
    super.onPageHide(route);
    final routeName = route.settings.name ?? 'unknown';
    _observer?.onPageHide(routeName);
    _observer?.onLifecycleChanged(routeName, PageLifecycleState.hidden);
  }

  @override
  void onForeground(Route route) {
    super.onForeground(route);
    final routeName = route.settings.name ?? 'unknown';
    _observer?.onAppForeground(routeName);
    _observer?.onLifecycleChanged(routeName, PageLifecycleState.foreground);
  }

  @override
  void onBackground(Route route) {
    super.onBackground(route);
    final routeName = route.settings.name ?? 'unknown';
    _observer?.onAppBackground(routeName);
    _observer?.onLifecycleChanged(routeName, PageLifecycleState.background);
  }
}

/// 页面级生命周期观察者
/// 实现 Flutter Boost 的 PageVisibilityObserver
class PageLevelLifecycleObserver with PageVisibilityObserver {
  final PageLifecycleObserver? _observer;
  final String? routeName;

  PageLevelLifecycleObserver([this._observer, this.routeName]);

  @override
  void onPageShow() {
    super.onPageShow();
    final name = routeName ?? 'unknown_page';
    _observer?.onPageShow(name);
    _observer?.onLifecycleChanged(name, PageLifecycleState.showed);
  }

  @override
  void onPageHide() {
    super.onPageHide();
    final name = routeName ?? 'unknown_page';
    _observer?.onPageHide(name);
    _observer?.onLifecycleChanged(name, PageLifecycleState.hidden);
  }

  @override
  void onForeground() {
    super.onForeground();
    final name = routeName ?? 'unknown_page';
    _observer?.onAppForeground(name);
    _observer?.onLifecycleChanged(name, PageLifecycleState.foreground);
  }

  @override
  void onBackground() {
    super.onBackground();
    final name = routeName ?? 'unknown_page';
    _observer?.onAppBackground(name);
    _observer?.onLifecycleChanged(name, PageLifecycleState.background);
  }
}

/// 页面生命周期管理器
class PageLifecycleManager {
  static final PageLifecycleManager _instance = PageLifecycleManager._internal();
  factory PageLifecycleManager() => _instance;
  PageLifecycleManager._internal();

  final List<GlobalPageLifecycleObserver> _globalObservers = [];

  /// 添加全局生命周期观察者
  void addGlobalObserver(PageLifecycleObserver observer) {
    final globalObserver = GlobalPageLifecycleObserver(observer);
    PageVisibilityBinding.instance.addGlobalObserver(globalObserver);
    _globalObservers.add(globalObserver);
  }

  /// 移除全局生命周期观察者
  void removeGlobalObserver(PageLifecycleObserver observer) {
    // 移除匹配的观察者
    _globalObservers.removeWhere((globalObserver) {
      if (globalObserver._observer == observer) {
        PageVisibilityBinding.instance.removeGlobalObserver(globalObserver);
        return true;
      }
      return false;
    });
  }

  /// 获取所有全局观察者
  List<PageLifecycleObserver> get globalObservers =>
      _globalObservers.map((e) => e._observer).whereType<PageLifecycleObserver>().toList();

  /// 清空所有观察者
  void clear() {
    for (final observer in _globalObservers) {
      PageVisibilityBinding.instance.removeGlobalObserver(observer);
    }
    _globalObservers.clear();
  }
}

/// 简化的全局生命周期观察者实现
class SimpleGlobalLifecycleObserver implements PageLifecycleObserver {
  final void Function(String routeName, PageLifecycleState state)? onStateChanged;

  SimpleGlobalLifecycleObserver({this.onStateChanged});

  @override
  void onPageCreated(String routeName) {}

  @override
  void onPageShow(String routeName) {}

  @override
  void onPageHide(String routeName) {}

  @override
  void onPageDestroyed(String routeName) {}

  @override
  void onAppForeground(String routeName) {}

  @override
  void onAppBackground(String routeName) {}

  @override
  void onLifecycleChanged(String routeName, PageLifecycleState state) {
    onStateChanged?.call(routeName, state);
  }
}

/// 页面生命周期Mixin
/// 不实现 PageLifecycleObserver 接口，避免方法签名冲突
mixin PageLifecycleMixin<T extends StatefulWidget> on State<T> {
  late PageLevelLifecycleObserver _observer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在 didChangeDependencies 中注册观察者
    final route = ModalRoute.of(context);
    if (route != null) {
      final routeName = route.settings.name ?? 'unknown_page';
      _observer = PageLevelLifecycleObserver(
        _PageLifecycleDelegate(this),
        routeName,
      );
      PageVisibilityBinding.instance.addObserver(_observer, route);
    }
  }

  @override
  void dispose() {
    // 移除观察者
    PageVisibilityBinding.instance.removeObserver(_observer);
    super.dispose();
  }

  /// 页面显示时调用
  void onPageShow() {}

  /// 页面隐藏时调用
  void onPageHide() {}

  /// 应用进入前台时调用
  void onAppForeground() {}

  /// 应用进入后台时调用
  void onAppBackground() {}
}

/// 页面生命周期委托 - 桥接 Mixin 和 Observer
class _PageLifecycleDelegate implements PageLifecycleObserver {
  final PageLifecycleMixin _mixin;

  _PageLifecycleDelegate(this._mixin);

  @override
  void onPageShow(String routeName) => _mixin.onPageShow();

  @override
  void onPageHide(String routeName) => _mixin.onPageHide();

  @override
  void onAppForeground(String routeName) => _mixin.onAppForeground();

  @override
  void onAppBackground(String routeName) => _mixin.onAppBackground();

  @override
  void onPageCreated(String routeName) {}

  @override
  void onPageDestroyed(String routeName) {}

  @override
  void onLifecycleChanged(String routeName, PageLifecycleState state) {}
}