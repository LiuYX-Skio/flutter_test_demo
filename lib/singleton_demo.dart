import 'navigation/core/navigator_service.dart';

/// 演示 NavigatorService 的单例特性
void demonstrateSingleton() {
  print('=== NavigatorService 单例演示 ===');

  // 获取多个实例
  final nav1 = NavigatorService();
  final nav2 = NavigatorService();
  final nav3 = NavigatorService();

  // 验证是同一个实例
  print('nav1 == nav2: ${nav1 == nav2}'); // true
  print('nav2 == nav3: ${nav2 == nav3}'); // true
  print('nav1 == nav3: ${nav1 == nav3}'); // true

  // 验证 hashCode 相同
  print('nav1.hashCode: ${nav1.hashCode}');
  print('nav2.hashCode: ${nav2.hashCode}');
  print('nav3.hashCode: ${nav3.hashCode}');

  // 验证内部状态共享
  print('所有实例共享同一个内部状态');

  print('=== 单例演示结束 ===');
}

/// 性能对比演示
void performanceDemo() {
  print('=== 性能演示 ===');

  // 模拟多次调用
  final startTime = DateTime.now();
  for (var i = 0; i < 10000; i++) {
    // 不做实际操作，只是获取实例引用
    NavigatorService();
  }
  final endTime = DateTime.now();

  final duration = endTime.difference(startTime);
  print('创建 10000 个 "实例" 耗时: ${duration.inMilliseconds}ms');
  print('平均每个实例耗时: ${duration.inMicroseconds / 10000}μs');
  print('实际上只创建了一个实例，后续都是返回引用');

  print('=== 性能演示结束 ===');
}