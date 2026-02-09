import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 错误状态组件
class ErrorStateWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.w,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            message ?? '加载失败',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          if (onRetry != null) ...[
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: onRetry,
              child: Text('重试'),
            ),
          ],
        ],
      ),
    );
  }
}
