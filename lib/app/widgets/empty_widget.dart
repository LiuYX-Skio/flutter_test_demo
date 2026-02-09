import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 空状态组件
class EmptyWidget extends StatelessWidget {
  final String? message;
  final IconData? icon;

  const EmptyWidget({
    super.key,
    this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/home_auth_hint.png',
            width: 24.w,
            height: 24.w,
          ),
          SizedBox(height: 16.h),
          Text(
            message ?? '暂无数据',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
