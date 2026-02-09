import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/user_input_field.dart';

/// 登录表单组件
class LoginForm extends StatelessWidget {
  final Function(String) onPhoneChanged;
  final Function(String) onCodeChanged;
  final VoidCallback onSendCode;
  final VoidCallback onLogin;
  final String sendCodeButtonText;
  final bool canSendCode;
  final bool canLogin;

  const LoginForm({
    super.key,
    required this.onPhoneChanged,
    required this.onCodeChanged,
    required this.onSendCode,
    required this.onLogin,
    required this.sendCodeButtonText,
    required this.canSendCode,
    required this.canLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 手机号输入框
        UserInputField(
          iconPath: 'assets/images/login_phone.webp',
          hintText: '请输入手机号',
          keyboardType: TextInputType.phone,
          maxLength: 11,
          onChanged: onPhoneChanged,
          showSendCode: false,
        ),

        SizedBox(height: 18.h),

        // 验证码输入框
        UserInputField(
          iconPath: 'assets/images/login_pwd.webp',
          hintText: '请输入验证码',
          keyboardType: TextInputType.number,
          maxLength: 6,
          onChanged: onCodeChanged,
          showSendCode: true,
          sendCodeText: sendCodeButtonText,
          onSendCode: canSendCode ? onSendCode : null,
        ),

        SizedBox(height: 40.h),

        // 登录按钮
        SizedBox(
          width: double.infinity,
          height: 47.h,
          child: ElevatedButton(
            onPressed: canLogin ? onLogin : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canLogin
                  ? const Color(0xFFFF3530) // color_FF3530
                  : const Color(0x4DFF3530), // color_4dFF3530
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29.w),
              ),
            ),
            child: Text(
              '登录',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}