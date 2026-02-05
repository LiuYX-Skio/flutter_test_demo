import 'package:flutter/material.dart';
import 'navigation/core/lifecycle_observer.dart';

/// 生命周期功能使用示例
class LifecycleExamplePage extends StatefulWidget {
  const LifecycleExamplePage({super.key});

  @override
  State<LifecycleExamplePage> createState() => _LifecycleExamplePageState();
}

class _LifecycleExamplePageState extends State<LifecycleExamplePage>
    with PageLifecycleMixin<LifecycleExamplePage> {
  String _lifecycleLog = '';

  @override
  void onPageShow() {
    super.onPageShow();
    _addLog('页面显示 (onPageShow)');
  }

  @override
  void onPageHide() {
    super.onPageHide();
    _addLog('页面隐藏 (onPageHide)');
  }

  @override
  void onAppForeground() {
    super.onAppForeground();
    _addLog('应用前台 (onAppForeground)');
  }

  @override
  void onAppBackground() {
    super.onAppBackground();
    _addLog('应用后台 (onAppBackground)');
  }

  void _addLog(String message) {
    setState(() {
      final timestamp = DateTime.now().toString().substring(11, 19);
      _lifecycleLog = '[$timestamp] $message\n$_lifecycleLog';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('生命周期示例'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: const Text(
              '这个页面使用了 PageLifecycleMixin\n'
              '生命周期事件会自动触发，无需手动注册',
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                _lifecycleLog.isEmpty ? '暂无生命周期日志' : _lifecycleLog,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => _addLog('手动日志测试'),
                  child: const Text('添加手动日志'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => setState(() => _lifecycleLog = ''),
                  child: const Text('清空日志'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 自定义全局生命周期观察者示例
class CustomGlobalObserver implements PageLifecycleObserver {
  @override
  void onPageShow(String routeName) {
    print('全局观察者: 页面显示 - $routeName');
  }

  @override
  void onPageHide(String routeName) {
    print('全局观察者: 页面隐藏 - $routeName');
  }

  @override
  void onAppForeground(String routeName) {
    print('全局观察者: 应用前台 - $routeName');
  }

  @override
  void onAppBackground(String routeName) {
    print('全局观察者: 应用后台 - $routeName');
  }

  // 实现其他必需方法
  @override
  void onPageCreated(String routeName) {}

  @override
  void onPageDestroyed(String routeName) {}

  @override
  void onLifecycleChanged(String routeName, PageLifecycleState state) {}
}