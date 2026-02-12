import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../app/provider/user_provider.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../../home/api/user_api.dart';

class SystemSettingPage extends StatefulWidget {
  const SystemSettingPage({super.key});

  @override
  State<SystemSettingPage> createState() => _SystemSettingPageState();
}

class _SystemSettingPageState extends State<SystemSettingPage>
    with WidgetsBindingObserver {
  final List<String> _systemData = const [
    '收货地址',
    '',
    '账号与安全',
    '',
    '注册协议',
    '/',
    '隐私协议',
    '/',
    '个人隐私共享清单',
    '/',
    '个人隐私收集清单',
    '',
    '关于我们',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshUserState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshUserState();
    }
  }

  Future<void> _refreshUserState() async {
    await UserProvider.updateUserInfo();
    if (mounted) {
      setState(() {});
    }
  }

  List<_SystemSettingItem> _buildItems() {
    final items = <_SystemSettingItem>[];
    for (final content in _systemData) {
      if (content == '/') {
        items.add(const _SystemSettingItem.line());
      } else if (content.isEmpty) {
        items.add(const _SystemSettingItem.space());
      } else {
        items.add(_SystemSettingItem.content(content));
      }
    }
    if (UserProvider.isLogin()) {
      items.add(const _SystemSettingItem.space());
      items.add(const _SystemSettingItem.login('退出登录'));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          SizedBox(height: 44.h),
          _buildTopBar(),
          SizedBox(height: 8.h),
          Container(
            height: 0.5.h,
            color: const Color(0xFFEDEFF2),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                switch (item.type) {
                  case _SystemSettingItemType.space:
                    return SizedBox(height: 12.h);
                  case _SystemSettingItemType.line:
                    return Container(
                      margin: EdgeInsets.only(left: 15.w),
                      height: 0.5.h,
                      color: const Color(0xFFEDEFF2),
                    );
                  case _SystemSettingItemType.login:
                    return _buildLoginOut(item.content ?? '');
                  case _SystemSettingItemType.content:
                    return _buildContentItem(item.content ?? '');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return SizedBox(
      height: 44.h,
      child: Stack(
        children: [
          Positioned(
            left: 5.w,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Image.asset(
                  'assets/images/icon_back.webp',
                  width: 12.w,
                  height: 18.h,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              '设置',
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentItem(String title) {
    return InkWell(
      onTap: () => _onItemTap(title),
      child: Container(
        height: 49.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
            Image.asset(
              'assets/images/icon_system_right_arrow.webp',
              width: 7.w,
              height: 12.h,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginOut(String title) {
    return GestureDetector(
      onTap: _onLoginOut,
      child: Container(
        height: 49.h,
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ),
    );
  }

  void _onItemTap(String title) {
    switch (title) {
      case '收货地址':
        if (!UserProvider.isLogin()) {
          context.nav.push(RoutePaths.auth.login);
        } else {
          context.nav.push(RoutePaths.user.addressList);
        }
        break;
      case '账号与安全':
        if (!UserProvider.isLogin()) {
          context.nav.push(RoutePaths.auth.login);
        } else {
          context.nav.push(RoutePaths.user.accountSafe);
        }
        break;
      case '注册协议':
        context.nav.push(
          RoutePaths.other.webview,
          arguments: {
            'url': AppConstants.userRegisterProtocolUrl,
            'title': AppConstants.registerProtocolTitle,
          },
        );
        break;
      case '隐私协议':
        context.nav.push(
          RoutePaths.other.webview,
          arguments: {
            'url': AppConstants.privacyProtocolUrl,
            'title': AppConstants.privacyProtocolTitle,
          },
        );
        break;
      case '个人隐私共享清单':
        context.nav.push(
          RoutePaths.other.webview,
          arguments: {
            'url': AppConstants.userPrivacyShareProtocolUrl,
            'title': AppConstants.privacyShareTitle,
          },
        );
        break;
      case '个人隐私收集清单':
        context.nav.push(
          RoutePaths.other.webview,
          arguments: {
            'url': AppConstants.userPrivacyGatherProtocolUrl,
            'title': AppConstants.privacyGatherTitle,
          },
        );
        break;
      case '关于我们':
        if (!UserProvider.isLogin()) {
          context.nav.push(RoutePaths.auth.login);
        } else {
          context.nav.push(RoutePaths.other.about);
        }
        break;
    }
  }

  void _onLoginOut() {
    if (!UserProvider.isLogin()) {
      return;
    }
    UserApi.loginOut(
      onSuccess: (_) async {
        await UserProvider.clearUserInfo();
        await LoadingManager.instance.showToast('已退出登录');
        if (mounted) {
          setState(() {});
        }
        NavigatorService.instance.pop();
        NavigatorService.instance.push(RoutePaths.auth.login);
      },
    );
  }
}

enum _SystemSettingItemType { content, space, line, login }

class _SystemSettingItem {
  final _SystemSettingItemType type;
  final String? content;

  const _SystemSettingItem._(this.type, this.content);

  const _SystemSettingItem.content(String content)
      : this._(_SystemSettingItemType.content, content);

  const _SystemSettingItem.space()
      : this._(_SystemSettingItemType.space, null);

  const _SystemSettingItem.line()
      : this._(_SystemSettingItemType.line, null);

  const _SystemSettingItem.login(String content)
      : this._(_SystemSettingItemType.login, content);
}
