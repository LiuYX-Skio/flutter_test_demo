import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamineIngPage extends StatelessWidget {
  const ExamineIngPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 44.h),
          _buildTopBar(context, '审核中'),
          SizedBox(height: 60.h),
          Image.asset(
            'assets/images/examine_ing.webp',
            width: 180.w,
            height: 180.w,
          ),
          SizedBox(height: 20.h),
          Text(
            '审核中，请耐心等待半个工作日\n审核结果会以短信的方式通知您.\n请您稍后重启app刷新页面',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.sp, color: const Color(0xFF333333), height: 1.5),
          ),
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
