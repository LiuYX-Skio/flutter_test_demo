import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamineFailPage extends StatelessWidget {
  const ExamineFailPage({super.key, this.nextApplyTime});

  final String? nextApplyTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 44.h),
          _buildTopBar(context, '审核失败'),
          SizedBox(height: 60.h),
          Image.asset(
            'assets/images/examine_fail.webp',
            width: 180.w,
            height: 180.w,
          ),
          SizedBox(height: 20.h),
          Text(
            '您的购物次数积累不足，暂无法申请月付',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333)),
          ),
          if (nextApplyTime != null && nextApplyTime!.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              '下次可申请时间：$nextApplyTime',
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
            ),
          ],
          SizedBox(height: 40.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFF3530),
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('返回购物',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, String title) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.asset(
              'assets/images/icon_back.webp',
              width: 12.w,
              height: 18.h,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF1A1A1A)),
          ),
          const Spacer(),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }
}
