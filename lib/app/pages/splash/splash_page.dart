import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_demo/app/pages/splash/api/splash_api.dart';
import 'package:flutter_test_demo/app/pages/splash/widgets/splash_protocol_dialog.dart';
import 'package:flutter_test_demo/navigation/core/navigator_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../navigation/core/route_paths.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';


/// 启动页
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  /// 倒计时剩余时间
  int _countdown = AppConstants.splashCountdownTime;

  /// 定时器
  Timer? _timer;

  /// 是否已经跳转
  bool _hasJumped = false;

  /// 启动图片URL（从服务器获取）
  String? _splashImageUrl;

  @override
  void initState() {
    super.initState();
    _initSplash();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// 初始化启动页
  Future<void> _initSplash() async {
    // 设置透明状态栏
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // 从服务器获取启动图片URL
    SplashApi.getSplashImage(
      onSuccess: (splashImageUrl) {
        if (splashImageUrl != null && splashImageUrl.isNotEmpty) {
          setState(() {
            _splashImageUrl = splashImageUrl;
          });
        }
      },
    );

    // 获取用户信用详情
    SplashApi.getUserCreditDetail();

    // 获取 IP 地址
    SplashApi.getIpAddress();

    // 检查应用更新
    await _checkAppUpdate();
  }

  /// 开始倒计时
  void _startCountdown() {
    _timer = Timer.periodic(
      Duration(milliseconds: AppConstants.delayTime),
      (timer) {
        if (_countdown > 0) {
          setState(() {
            _countdown--;
          });
        } else {
          timer.cancel();
          _jumpToHome();
        }
      },
    );
  }

  /// 检查应用更新
  Future<void> _checkAppUpdate() async {
    SplashApi.checkAppUpdate(
      onSuccess: (updateInfo) {
        if (updateInfo != null && updateInfo.versionCode != null) {
          // TODO: 获取当前应用版本号进行比较，显示更新弹窗
          // final needUpdate = updateInfo.versionCode! > currentVersionCode
          // if (needUpdate) { 显示更新弹窗 }
        }
        // 开始倒计时
        _startCountdown();
      },
      onError: (exception) {
        // 检查更新失败，继续倒计时
        _startCountdown();
      },
    );
  }

  /// 跳转到首页
  Future<void> _jumpToHome() async {
    if (_hasJumped) return;
    _hasJumped = true;

    // 检查用户是否同意协议
    final prefs = await SharedPreferences.getInstance();
    final hasAgreedProtocol = prefs.getBool('has_agreed_protocol') ?? false;

    print('用户是否同意协议: $hasAgreedProtocol==$mounted');

    if (!mounted) return;

    if (hasAgreedProtocol) {
      if (!mounted) return;

      if (mounted) {
        await context.nav.push(RoutePaths.home);
      }
    } else {
      // 未同意协议，显示协议弹窗
      _showProtocolDialog();
    }
  }

  /// 显示协议弹窗
  void _showProtocolDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => SplashProtocolDialog(
        onAgree: () async {
          // 保存用户同意状态
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('has_agreed_protocol', true);

          if (!mounted) return;

          // 使用State的context而不是dialog的context
          if (mounted) {
            context.nav.pop();// 关闭对话框
            // 跳转到主页
            await context.nav.push(RoutePaths.home);
          }
        },
        onDisagree: () {
          // 用户不同意，退出应用
          SystemNavigator.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 全屏背景图片
          _buildBackgroundImage(),

          // 右上角倒计时
          if (_countdown > 0) _buildCountdownWidget(),
        ],
      ),
    );
  }

  /// 构建背景图片
  Widget _buildBackgroundImage() {
    if (_splashImageUrl != null && _splashImageUrl!.isNotEmpty) {
      // 从网络加载图片
      return CachedNetworkImage(
        imageUrl: _splashImageUrl!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildDefaultBackground(),
        errorWidget: (context, url, error) => _buildDefaultBackground(),
      );
    } else {
      // 使用默认背景
      return _buildDefaultBackground();
    }
  }

  /// 构建默认背景
  Widget _buildDefaultBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.white,
      // TODO: 添加默认启动图片
      // child: Image.asset('assets/images/app_splash_ground.png', fit: BoxFit.cover),
    );
  }

  /// 构建倒计时组件
  Widget _buildCountdownWidget() {
    return Positioned(
      top: 45.h,
      right: 25.w,
      child: Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          // 透明背景
          color: Colors.transparent,
          // 橙色边框（原版是虚线，这里简化为实线）
          border: Border.all(
            color: AppColors.countdownText,
            width: 1.w,
          ),
          // 圆角 20dp
          borderRadius: BorderRadius.circular(20.r),
        ),
        alignment: Alignment.center,
        child: Text(
          '$_countdown',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.countdownText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
