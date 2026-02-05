import 'package:flutter/material.dart';
import 'navigation/core/navigator_service.dart';
import 'navigation/core/route_paths.dart';

/// 导航框架使用示例页面
class NavigationExamplePage extends StatefulWidget {
  const NavigationExamplePage({super.key});

  @override
  State<NavigationExamplePage> createState() => _NavigationExamplePageState();
}

class _NavigationExamplePageState extends State<NavigationExamplePage> {
  String _lastResult = '暂无结果';

  // 获取导航服务的便捷引用（可选）
  // NavigatorService get _nav => NavigatorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('导航框架示例'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '路由导航示例',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 基础页面跳转
            _buildSection(
              '基础页面跳转 (使用路由对象)',
              [
                _buildButton('跳转到用户资料', () => _navigateToPage(RoutePaths.user.profile)),
                _buildButton('跳转到设置页面', () => _navigateToPage(RoutePaths.user.settings)),
                _buildButton('跳转到商品列表', () => _navigateToPage(RoutePaths.product.list)),
                _buildButton('跳转到消息列表', () => _navigateToPage(RoutePaths.other.notificationList)),
              ],
            ),

            // 弹窗跳转
            _buildSection(
              '弹窗跳转 (使用路由对象)',
              [
                _buildButton('显示确认对话框', () => _showDialog(RoutePaths.other.confirm)),
                _buildButton('显示登录弹窗', () => _showDialog(RoutePaths.auth.login)),
                _buildButton('显示分享面板', () => _showBottomSheet(RoutePaths.other.share)),
                _buildButton('显示图片预览', () => _showTransparentDialog(RoutePaths.other.imagePreview)),
                _buildButton('显示加载弹窗', () => _showTransparentDialog(RoutePaths.other.loading)),
              ],
            ),

            // 参数传递
            _buildSection(
              '参数传递 (使用路由对象)',
              [
                _buildButton('带参数跳转商品详情', () => _navigateWithParams()),
                _buildButton('带参数跳转用户编辑', () => _navigateWithParamsToEdit()),
              ],
            ),

            // 结果处理
            _buildSection(
              '结果处理',
              [
                Text('上次操作结果: $_lastResult'),
                const SizedBox(height: 10),
                _buildButton('选择城市（返回结果）', () => _selectCity()),
              ],
            ),

            // 路由状态
            _buildSection(
              '路由状态 (使用路由对象)',
              [
                _buildButton('检查路由是否存在', () => _checkRouteExists()),
                _buildButton('获取当前路由', () => _getCurrentRoute()),
                _buildButton('监听路由变化', () => _listenToRouteChanges()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> buttons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        ...buttons,
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 40),
        ),
      ),
    );
  }

  // 基础页面跳转
  void _navigateToPage(dynamic routeName) async {
    final result = await context.nav.push(routeName);
    final routeDisplay = routeName is RoutePath ? routeName.path : routeName.toString();
    _updateResult('跳转到 $routeDisplay: ${result.success ? '成功' : '失败'}');
  }

  // 显示弹窗
  void _showDialog(dynamic routeName) async {
    final result = await context.nav.pushDialog(routeName);
    final routeDisplay = routeName is RoutePath ? routeName.path : routeName.toString();
    _updateResult('弹窗 $routeDisplay: ${result.success ? '确认' : '取消'}');
  }

  // 显示底部弹窗
  void _showBottomSheet(dynamic routeName) async {
    final result = await context.nav.pushBottomSheet(routeName);
    final routeDisplay = routeName is RoutePath ? routeName.path : routeName.toString();
    _updateResult('底部弹窗 $routeDisplay: ${result.success ? '选择' : '取消'}');
  }

  // 显示透明弹窗
  void _showTransparentDialog(dynamic routeName) async {
    await context.nav.pushTransparentDialog(routeName);
    final routeDisplay = routeName is RoutePath ? routeName.path : routeName.toString();
    _updateResult('透明弹窗 $routeDisplay: 显示完成');
  }

  // 带参数跳转
  void _navigateWithParams() async {
    final result = await context.nav.push(
      RoutePaths.product.detail,
      arguments: {
        'productId': '12345',
        'source': 'example_page',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    _updateResult('商品详情参数跳转: ${result.success ? '成功' : '失败'}');
  }

  // 带参数跳转到编辑页面
  void _navigateWithParamsToEdit() async {
    final result = await context.nav.push(
      RoutePaths.user.editProfile,
      arguments: {
        'userId': 'user123',
        'editMode': 'full',
        'from': 'settings',
      },
    );
    _updateResult('编辑资料参数跳转: ${result.success ? '成功' : '失败'}');
  }

  // 选择城市（模拟返回结果）
  void _selectCity() async {
    // 这里模拟一个选择城市的操作
    final result = await context.nav.push<String>(RoutePaths.product.search);
    if (result.success) {
      _updateResult('选择城市: ${result.data ?? '未知'}');
    } else {
      _updateResult('取消选择城市');
    }
  }

  // 检查路由是否存在
  void _checkRouteExists() {
    final routes = [RoutePaths.home, RoutePaths.user.profile, const RoutePath('nonexistent_route')];
    final results = routes.map((route) =>
      '${route.path}: ${context.nav.hasRoute(route) ? '存在' : '不存在'}'
    ).join(', ');

    _updateResult('路由检查: $results');
  }

  // 获取当前路由
  void _getCurrentRoute() {
    final currentRoute = context.nav.currentRoute;
    _updateResult('当前路由: ${currentRoute ?? '未知'}');
  }

  // 监听路由变化
  void _listenToRouteChanges() {
    context.nav.routeChanges.listen((route) {
      _updateResult('路由变化: $route');
    });
    _updateResult('已开始监听路由变化');
  }

  void _updateResult(String result) {
    setState(() {
      _lastResult = result;
    });

    // 也可以打印到控制台
    print('导航结果: $result');
  }
}