import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_demo/app/constants/app_colors.dart';

/// 启动页协议弹窗
class SplashProtocolDialog extends StatelessWidget {
  final VoidCallback onAgree;
  final VoidCallback onDisagree;

  const SplashProtocolDialog({
    super.key,
    required this.onAgree,
    required this.onDisagree,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            Text(
              '用户协议和隐私政策',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),

            // 内容
            Text(
              '欢迎使用本应用！\n\n'
              '在使用前，请您仔细阅读并同意《用户协议》和《隐私政策》。'
              '我们将严格保护您的个人信息安全。',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),

            // 按钮
            Row(
              children: [
                Expanded(
                  child: _buildButton(
                    text: '不同意',
                    onTap: onDisagree,
                    isAgree: false,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildButton(
                    text: '同意',
                    onTap: onAgree,
                    isAgree: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onTap,
    required bool isAgree,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: isAgree ? AppColors.countdownText : Colors.grey[300],
          borderRadius: BorderRadius.circular(22.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            color: isAgree ? AppColors.white : Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
