import 'package:flutter/material.dart';
import 'package:flutter_test_demo/navigation/core/navigator_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../navigation/core/route_paths.dart';
import '../api/user_api.dart';
import '../models/user_models.dart';

/// 月付申请Tab视图
class ApplyQuotaTabView extends StatefulWidget {
  final bool showBackButton;

  const ApplyQuotaTabView({
    super.key,
    this.showBackButton = false,
  });

  @override
  State<ApplyQuotaTabView> createState() => _ApplyQuotaTabViewState();
}

class _ApplyQuotaTabViewState extends State<ApplyQuotaTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTopBackground(),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
          if (widget.showBackButton)
            Positioned(
              left: 5.w,
              top: 34.h,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).maybePop(),
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Image.asset(
                    'assets/images/icon_back.webp',
                    width: 12.w,
                    height: 18.h,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          Positioned(
            left: 12.w,
            right: 12.w,
            bottom: 20.h,
            child: _buildBottomButton(),
          ),
        ],
      ),
    );
  }

  /// 顶部渐变背景区域
  Widget _buildTopBackground() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 350.h,
          width: double.infinity,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFDCCC0),
                  Color(0xFFF23C38),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 20.w,
          top: 70.h,
          child: Text(
            '宝鱼月付',
            style: TextStyle(
              fontSize: 18.sp,
              color: const Color(0xFF1A1A1A), // color_1A1A1A
            ),
          ),
        ),
        Positioned(
          left: 20.w,
          top: 110.h,
          child: Text(
            '先享后付\n收货满意才付款',
            style: TextStyle(
              fontSize: 23.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A), // color_1A1A1A
              height: 1.2,
            ),
          ),
        ),
        Positioned(
          right: 7.w,
          top: 65.h,
          child: Image.asset(
            'assets/images/icon_packet.webp',
            width: 127.w,
            height: 119.h,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 182.h, left: 15.w, right: 15.w),
          child: Column(
            children: [
              _buildFeatureCards(),
              SizedBox(height: 12.h),
              _buildBottomProcess(),
            ],
          ),
        ),
      ],
    );
  }

  /// 功能介绍卡片区域
  Widget _buildFeatureCards() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildFeatureItemFullWidth(
            'assets/images/icon_t.webp',
            '轻松购物优惠多',
            '海量立减优惠，新人专享',
            top: 25.h,
            bottom: 25.h,
          ),
          _buildFeatureItemFullWidth(
            'assets/images/icon_m_kf.webp',
            '退款无忧有保障',
            '先收货再付款，下单无压力',
            top: 0,
            bottom: 25.h,
          ),
          _buildFeatureItemFullWidth(
            'assets/images/icon_yj.webp',
            '退货运费险',
            '可免退货运费',
            top: 0,
            bottom: 25.h,
          ),
          _buildFeatureItemFullWidth(
            'assets/images/icon_j.webp',
            '专属客服微信服务',
            '专属客服一对一',
            top: 0,
            bottom: 25.h,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItemFullWidth(
    String iconPath,
    String title,
    String desc, {
    required double top,
    required double bottom,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: 25.w,
        right: 25.w,
        top: top,
        bottom: bottom,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 50.w,
            height: 50.h,
          ),
          SizedBox(width: 19.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF1A1A1A), // color_1A1A1A
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF999999), // color_999999
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 底部流程展示区域
  Widget _buildBottomProcess() {
    return Container(
      padding: EdgeInsets.only(
        top: 12.h,
        bottom: 30.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon_month_line.webp',
                width: 40.w,
                height: 40.h,
              ),
              SizedBox(width: 20.w),
              Text(
                '哪里可以用',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF323233),
                ),
              ),
              SizedBox(width: 20.w),
              Transform.rotate(
                angle: 3.14159,
                child: Image.asset(
                  'assets/images/icon_month_line.webp',
                  width: 40.w,
                  height: 40.h,
                ),
              ),
            ],
          ),
          SizedBox(height: 7.h),
          Row(
            children: [
              _buildProcessItem('商城购物', 'assets/images/icon_zb.webp'),
              _buildProcessItem('商城回收', 'assets/images/icon_ms.webp'),
              _buildProcessItem('话费充值', 'assets/images/icon_hf.webp'),
            ],
          ),
        ],
      ),
    );
  }

  /// 流程项
  Widget _buildProcessItem(String title, String iconPath) {
    return Expanded(
      child: Column(
        children: [
          Image.asset(
            iconPath,
            width: 40.w,
            height: 40.h,
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return SizedBox(
      width: double.infinity,
      height: 49.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFFF3530),
          borderRadius: BorderRadius.circular(24.5.h),
        ),
        child: TextButton(
          onPressed: _onApplyButtonPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: const Text('立即开通'),
        ),
      ),
    );
  }

  Future<void> _onApplyButtonPressed() async {
    final hasAuthentication = await _hasAuthentication();
    if (!mounted) {
      return;
    }
    if (hasAuthentication) {
      _navigateToSupplementMessage();
      return;
    }
    _navigateToAuthMessage();
  }

  void _navigateToSupplementMessage() {
    context.nav.push(RoutePaths.other.supplementMessage);
  }

  void _navigateToAuthMessage() {
    context.nav.push(
      RoutePaths.other.authMessage,
      arguments: {'hasApply': true},
    );
  }

  Future<bool> _hasAuthentication() async {
    UserInfoEntity? userInfo;
    await UserApi.getUserInfo(
      onSuccess: (data) {
        userInfo = data;
      },
    );
    return userInfo?.hasAuthentication == true;
  }
}
