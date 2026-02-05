/// 框架初始化器使用示例
///
/// 展示如何使用 FrameworkInitializer 初始化应用中的各个框架

import 'framework_initializer.dart';

/// 示例1：在 main 函数中初始化所有框架
void example1() {
  // 一次性初始化所有框架
  FrameworkInitializer.initAll(
    FrameworkConfig(
      // 配置网络框架
      networkConfig: NetworkConfig(
        baseUrl: 'https://api.example.com',
        connectTimeout: 30000,
        receiveTimeout: 30000,
        enableLog: true,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // Token 获取回调
        onGetToken: () async {
          // 从本地存储获取 Token
          return 'your_token_here';
        },
        // Token 刷新回调
        onRefreshToken: () async {
          // 刷新 Token 的逻辑
          return 'new_token_here';
        },
        // 未授权回调
        onUnauthorized: () {
          // 跳转到登录页
          print('未授权，请重新登录');
        },
        // 全局错误处理
        onError: (exception) {
          print('全局错误: ${exception.message}');
        },
      ),
      // 是否初始化导航框架
      initNavigation: true,
    ),
  );
}

/// 示例2：单独初始化各个框架
void example2() {
  // 先初始化网络框架
  FrameworkInitializer.initNetwork(
    NetworkConfig(
      baseUrl: 'https://api.example.com',
      enableLog: true,
    ),
  );

  // 再初始化导航框架
  FrameworkInitializer.initNavigation();
}

/// 示例3：只初始化网络框架（不初始化导航）
void example3() {
  FrameworkInitializer.initNetwork(
    NetworkConfig(
      baseUrl: 'https://api.example.com',
      enableLog: false, // 生产环境关闭日志
    ),
  );
}

/// 示例4：检查初始化状态
void example4() {
  // 检查网络框架是否已初始化
  if (FrameworkInitializer.isNetworkInitialized) {
    print('网络框架已初始化');
  }

  // 检查导航框架是否已初始化
  if (FrameworkInitializer.isNavigationInitialized) {
    print('导航框架已初始化');
  }

  // 检查所有框架是否已初始化
  if (FrameworkInitializer.isAllInitialized) {
    print('所有框架已初始化');
  }
}

/// 示例5：在实际应用的 main 函数中使用
void main() {
  // 初始化所有框架
  FrameworkInitializer.initAll(
    FrameworkConfig(
      networkConfig: NetworkConfig(
        baseUrl: 'https://api.example.com',
        enableLog: true,
      ),
      initNavigation: true,
    ),
  );

  // 启动应用
  // runApp(MyApp());
}

