import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../dialog/loading_manager.dart';
import 'viewmodels/main_viewmodel.dart';
import 'views/home_tab_view.dart';
import 'views/sort_tab_view.dart';
import 'views/apply_quota_tab_view.dart';
import 'views/mine_tab_view.dart';

/// 主页面
/// 包含底部导航栏和4个Tab页面
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MainPageState();
}

class _MainPageState extends State<HomePage> with WidgetsBindingObserver {
  late PageController _pageController;
  late MainViewModel _mainViewModel;
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addObserver(this);

    // 延迟初始化，确保Provider已经准备好
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mainViewModel = Provider.of<MainViewModel>(context, listen: false);
      _mainViewModel.init();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 当应用恢复到前台时，调用resume
    if (state == AppLifecycleState.resumed) {
      _mainViewModel.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          LoadingManager.instance.showToast('再按一次退出应用');
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // 禁用滑动
          children: const [
            HomeTabView(),
            SortTabView(),
            ApplyQuotaTabView(),
            MineTabView(),
          ],
        ),
        bottomNavigationBar: Consumer<MainViewModel>(
          builder: (context, viewModel, child) {
            return Container(
              height: 78.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: viewModel.currentTabIndex,
                onTap: (index) {
                  viewModel.changeTab(index);
                  _pageController.jumpToPage(index);
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: const Color(0xFFFF3530), // 主题色
                unselectedItemColor: const Color(0xFF999999),
                selectedFontSize: 12.sp,
                unselectedFontSize: 12.sp,
                elevation: 0, // 移除默认阴影，使用自定义阴影
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/ic_menu_tab1.png',
                      width: 24.w,
                      height: 24.w,
                    ),
                    activeIcon: Image.asset(
                      'assets/images/ic_menu_tab1_p.png',
                      width: 24.w,
                      height: 24.w,
                    ),
                    label: '首页',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/ic_menu_tab2.png',
                      width: 24.w,
                      height: 24.w,
                    ),
                    activeIcon: Image.asset(
                      'assets/images/ic_menu_tab2_p.png',
                      width: 24.w,
                      height: 24.w,
                    ),
                    label: '排行榜',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/ic_menu_tab3.png',
                      width: 24.w,
                      height: 24.w,
                    ),
                    activeIcon: Image.asset(
                      'assets/images/ic_menu_tab3_p.png',
                      width: 24.w,
                      height: 24.w,
                    ),
                    label: '月付申请',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/ic_menu_tab4.png',
                      width: 24.w,
                      height: 24.w,
                    ),
                    activeIcon: Image.asset(
                      'assets/images/ic_menu_tab4_p.png',
                      width: 24.w,
                      height: 24.w,
                    ),
                    label: '我的',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
