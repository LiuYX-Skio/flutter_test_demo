import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';

class AccountSafePage extends StatelessWidget {
  const AccountSafePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          Container(height: 44.h, color: Colors.white),
          _buildTopBar(context),
          Container(height: 8.h, color: Colors.white),
          SizedBox(height: 10.h),
          _buildAccountRow(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 44.h,
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Image.asset(
                'assets/images/icon_back.webp',
                width: 12.w,
                height: 18.h,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '账户与安全',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
          SizedBox(width: 36.w),
        ],
      ),
    );
  }

  Widget _buildAccountRow(BuildContext context) {
    return InkWell(
      onTap: () => context.nav.push(RoutePaths.user.accountSafeDetail),
      child: Container(
        height: 49.h,
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Text(
                '账号注销',
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
}
