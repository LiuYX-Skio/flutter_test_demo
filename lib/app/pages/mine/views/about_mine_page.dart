import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';

class AboutMinePage extends StatelessWidget {
  const AboutMinePage({super.key});

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
          _buildContent(),
          const Spacer(),
          _buildBottomLink(context),
          SizedBox(height: 30.h),
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
                '关于我们',
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

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.only(top: 37.h, bottom: 65.h),
      color: Colors.white,
      child: Column(
        children: [
          Image.asset(
            'assets/images/app_logo.webp',
            width: 68.w,
            height: 68.w,
          ),
          SizedBox(height: 12.h),
          Text(
            '宝鱼商城',
            style: TextStyle(
              fontSize: 17.sp,
              color: const Color(0xFF333333),
            ),
          ),
          SizedBox(height: 42.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 23.w),
            child: Text(
              '在宝鱼商城，我们相信购物不仅仅是交易，更是一种享受。我们致力于通过技术革新，让每一次购物都成为愉悦的体验。我们的目标是打造一个用户友好、安全可靠的购物平台，让每一位用户都能轻松找到心仪的商品，享受专业化的购物服务。宝鱼团队由一群充满激情的行业专家组成，包括资深的技术开发者、创意设计师、市场分析师和客户服务专家。我们共同致力于提供一个无缝、智能的购物环境。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: const Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.nav.push(
          RoutePaths.other.webview,
          arguments: {
            'url': AppConstants.userRemarkProtocolUrl,
            'title': AppConstants.remarkProtocolTitle,
          },
        );
      },
      child: Text(
        'icp备案号：琼ICP备2022009814号-9A',
        style: TextStyle(
          fontSize: 13.sp,
          color: const Color(0xFF333333),
        ),
      ),
    );
  }
}
