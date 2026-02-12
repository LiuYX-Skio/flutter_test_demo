import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_demo/app/constants/app_constants.dart';
import 'package:flutter_test_demo/app/pages/login/viewmodels/login_viewmodel.dart';
import 'package:flutter_test_demo/app/pages/login/widgets/login_form.dart';
import 'package:flutter_test_demo/app/pages/login/widgets/protocol_agreement.dart';
import 'package:provider/provider.dart';
import '../../../navigation/core/navigator_service.dart';
import '../../../navigation/core/route_paths.dart';

/// 登录页面 - 完全按照Android UnionLoginActivity实现
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // 延迟初始化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<LoginViewModel>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final keyboardVisible = keyboardInset > 0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          return SafeArea(
            child: Column(
              children: [
                // 顶部导航栏
                _buildTopBar(),

                // 主内容区域
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 28.w,
                      right: 28.w,
                      bottom: keyboardInset + 16.h,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 42.h),

                        // Logo
                        Image.asset(
                          'assets/images/login_logo.webp',
                          width: 60.w,
                          height: 60.w,
                        ),

                        SizedBox(height: 20.h),

                        // 标题
                        Text(
                          '欢迎登录宝鱼商城',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF333333), // color_333333
                          ),
                        ),

                        SizedBox(height: 60.h),

                        // 登录表单
                        LoginForm(
                          onPhoneChanged: (phone) =>
                              viewModel.updatePhone(phone),
                          onCodeChanged: (code) => viewModel.updateCode(code),
                          onSendCode: () => _sendSmsCode(viewModel),
                          onLogin: () => _login(viewModel),
                          sendCodeButtonText: viewModel.sendCodeButtonText,
                          canLogin: viewModel.canLogin,
                          canSendCode: viewModel.canSendCode,
                        ),

                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),

                // 协议同意区域
                if (!keyboardVisible)
                  ProtocolAgreement(
                    isAgreed: viewModel.isProtocolAgreed,
                    onToggle: () => viewModel.toggleProtocolAgreement(),
                    onUserProtocol: _openUserProtocol,
                    onPrivacyProtocol: _openPrivacyProtocol,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 顶部导航栏
  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 10.w,
        right: 10.w,
        top: 10.h,
        bottom: 10.h,
      ),
      child: Row(
        children: [
          // 返回按钮
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(10.w),
              child: Image.asset(
                'assets/images/ic_black_back.png',
                width: 12.w,
                height: 18.h,
              ),
            ),
          ),

          Expanded(
            child: Text(
              '登录',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                color: const Color(0xFF333333), // color_333333
              ),
            ),
          ),

          // 右侧占位
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  /// 发送短信验证码
  void _sendSmsCode(LoginViewModel viewModel) async {
    if (viewModel.phone.isEmpty) {
      viewModel.setError('请输入手机号');
      return;
    }

    if (!viewModel.isValidPhoneNumber(viewModel.phone)) {
      viewModel.setError('请输入正确格式的手机号');
      return;
    }

    final success = await viewModel.sendSmsCode(viewModel.phone);
    if (success) {
      // 启动倒计时
      viewModel.startCodeTimer();
    }
  }

  /// 登录
  void _login(LoginViewModel viewModel) async {
    if (viewModel.phone.isEmpty) {
      viewModel.setError('请输入手机号');
      return;
    }

    if (viewModel.code.isEmpty) {
      viewModel.setError('请输入验证码');
      return;
    }

    if (!viewModel.isProtocolAgreed) {
      viewModel.setError('请勾选同意协议');
      return;
    }

    final success = await viewModel.phoneLogin(
      phone: viewModel.phone,
      code: viewModel.code,
    );

    if (success) {
      // 登录成功，跳转到首页
      if (context.mounted) {
        context.nav.pushAndRemoveUntil(RoutePaths.home);
      }
    }
  }

  /// 打开用户协议
  void _openUserProtocol() {
    if (context.mounted) {
      context.nav.push(
        RoutePaths.other.webview,
        arguments: {
          'url': AppConstants.userProtocolUrl,
          'title': AppConstants.userProtocolTitle,
        },
      );
    }
  }

  /// 打开隐私协议
  void _openPrivacyProtocol() {
    if (context.mounted) {
      context.nav.push(
        RoutePaths.other.webview,
        arguments: {
          'url': AppConstants.privacyProtocolUrl,
          'title': AppConstants.privacyProtocolTitle,
        },
      );
    }
  }
}
