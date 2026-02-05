/// 网络框架使用示例
///
/// 这个文件展示了如何使用封装的网络框架
/// 注意：这是示例代码，不要在生产环境中直接使用

import 'network.dart';

/// 示例：初始化网络框架
void initNetwork() {
  // 1. 创建配置
  final config = HttpConfig(
    baseUrl: 'https://api.example.com',
    connectTimeout: 30000,
    receiveTimeout: 30000,
    enableLog: true,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  // 2. 初始化 HTTP 客户端
  HttpClient.instance.init(config);

  // 3. 添加认证拦截器（可选）
  HttpClient.instance.addAuthInterceptor(
    onGetToken: () async {
      // 从本地存储获取 Token
      return 'your_token_here';
    },
    onRefreshToken: () async {
      // 刷新 Token 的逻辑
      return 'new_token_here';
    },
    onUnauthorized: () {
      // 未授权时的处理，如跳转到登录页
      print('未授权，请重新登录');
    },
  );

  // 4. 添加全局错误处理（可选）
  HttpClient.instance.addErrorInterceptor(
    onError: (exception) {
      // 全局错误处理
      print('全局错误: ${exception.message}');
    },
  );
}

/// 示例：GET 请求
Future<void> getExample() async {
  try {
    // 简单的 GET 请求
    final result = await HttpClient.instance.get<Map<String, dynamic>>(
      '/api/users',
    );
    print('GET 请求结果: $result');

    // 带查询参数的 GET 请求
    final result2 = await HttpClient.instance.get<Map<String, dynamic>>(
      '/api/users',
      queryParameters: {'page': 1, 'size': 10},
    );
    print('带参数的 GET 请求结果: $result2');
  } on ApiException catch (e) {
    print('请求失败: ${e.message}');
  }
}

/// 示例：POST 请求
Future<void> postExample() async {
  try {
    // POST 请求
    final result = await HttpClient.instance.post<Map<String, dynamic>>(
      '/api/login',
      data: {
        'username': 'test',
        'password': '123456',
      },
    );
    print('POST 请求结果: $result');
  } on ApiException catch (e) {
    print('请求失败: ${e.message}');
  }
}

/// 示例：PUT 和 DELETE 请求
Future<void> putDeleteExample() async {
  try {
    // PUT 请求
    await HttpClient.instance.put<Map<String, dynamic>>(
      '/api/users/1',
      data: {'name': 'Updated Name'},
    );

    // DELETE 请求
    await HttpClient.instance.delete<Map<String, dynamic>>('/api/users/1');
  } on ApiException catch (e) {
    print('请求失败: ${e.message}');
  }
}

/// 示例：文件上传
Future<void> uploadExample() async {
  try {
    final result = await HttpClient.instance.upload<Map<String, dynamic>>(
      '/api/upload',
      '/path/to/file.jpg',
      fileName: 'avatar.jpg',
      data: {'userId': '123'},
      onSendProgress: (sent, total) {
        print('上传进度: ${(sent / total * 100).toStringAsFixed(2)}%');
      },
    );
    print('上传成功: $result');
  } on ApiException catch (e) {
    print('上传失败: ${e.message}');
  }
}

/// 示例：文件下载
Future<void> downloadExample() async {
  try {
    await HttpClient.instance.download(
      '/api/files/document.pdf',
      '/path/to/save/document.pdf',
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print('下载进度: ${(received / total * 100).toStringAsFixed(2)}%');
        }
      },
    );
    print('下载完成');
  } on ApiException catch (e) {
    print('下载失败: ${e.message}');
  }
}

/// 示例：取消请求
Future<void> cancelExample() async {
  final cancelToken = CancelToken();

  // 3秒后取消请求
  Future.delayed(Duration(seconds: 3), () {
    cancelToken.cancel('用户取消了请求');
  });

  try {
    await HttpClient.instance.get<Map<String, dynamic>>(
      '/api/long-request',
      cancelToken: cancelToken,
    );
  } on ApiException catch (e) {
    if (e.type == ApiExceptionType.cancel) {
      print('请求已取消');
    }
  }
}

/// 示例数据模型
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}

/// 示例：使用自定义数据模型
Future<void> customModelExample() async {
  try {
    // 单个对象
    final user = await HttpClient.instance.get<User>(
      '/api/users/1',
      fromJsonT: (json) => User.fromJson(json as Map<String, dynamic>),
    );
    print('用户信息: ${user?.name}');

    // 列表对象
    final users = await HttpClient.instance.get<List<User>>(
      '/api/users',
      fromJsonT: (json) {
        final list = json as List;
        return list.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
      },
    );
    print('用户列表: ${users?.length}');
  } on ApiException catch (e) {
    print('请求失败: ${e.message}');
  }
}
