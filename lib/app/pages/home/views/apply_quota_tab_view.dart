import 'package:flutter/material.dart';
import 'package:flutter_test_demo/app/widgets/error_widget.dart';
import 'package:flutter_test_demo/app/widgets/loading_widget.dart';
import 'package:flutter_test_demo/navigation/core/navigator_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../navigation/core/route_paths.dart';
import '../viewmodels/apply_quota_viewmodel.dart';

/// 月付申请Tab视图
class ApplyQuotaTabView extends StatefulWidget {
  const ApplyQuotaTabView({Key? key}) : super(key: key);

  @override
  State<ApplyQuotaTabView> createState() => _ApplyQuotaTabViewState();
}

class _ApplyQuotaTabViewState extends State<ApplyQuotaTabView>
    with AutomaticKeepAliveClientMixin {
  late ApplyQuotaViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    // 延迟初始化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<ApplyQuotaViewModel>(context, listen: false);
      _viewModel.refresh();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<ApplyQuotaViewModel>(
      builder: (context, viewModel, child) {
        // 加载中
        if (viewModel.isLoading && viewModel.userCreditDetail == null) {
          return const LoadingWidget(message: '加载中...');
        }

        // 加载失败
        if (viewModel.errorMessage != null &&
            viewModel.userCreditDetail == null) {
          return ErrorStateWidget(
            message: viewModel.errorMessage,
            onRetry: () => viewModel.refresh(),
          );
        }

        return Container(
          color: const Color(0xFFF3F5F7), // color_F3F5F7
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 顶部渐变背景区域 (作为Stack布局)
                SizedBox(
                  height: 320.h, // 稍微降低高度，避免视觉上过高
                  child: _buildTopBackground(),
                ),

                // 功能介绍卡片区域
                _buildFeatureCards(),

                // 底部流程展示区域
                _buildBottomProcess(),

                // 底部按钮
                _buildBottomButton(viewModel),

                // 底部安全区域
                SizedBox(height: 50.h),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 顶部渐变背景区域
  Widget _buildTopBackground() {
    return Stack(
      children: [
        // 渐变背景
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF23C38), // color_F23C38
                Color(0xFFFDCCC0), // color_FDCCC0
              ],
            ),
          ),
        ),

        // 标题
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

        // 副标题
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

        // 右上角图标
        Positioned(
          right: 7.w,
          top: 65.h,
          child: Image.asset(
            'assets/images/icon_packet.webp',
            width: 127.w,
            height: 119.h,
          ),
        ),
      ],
    );
  }

  /// 功能介绍卡片区域
  Widget _buildFeatureCards() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          // 轻松购物优惠多
          _buildFeatureItemFullWidth(
            'assets/images/icon_t.webp',
            '轻松购物优惠多',
            '海量立减优惠，新人专享',
          ),

          // 退款无忧有保障
          _buildFeatureItemFullWidth(
            'assets/images/icon_m_kf.webp',
            '退款无忧有保障',
            '先收货再付款，下单无压力',
          ),

          // 退货运费险
          _buildFeatureItemFullWidth(
            'assets/images/icon_yj.webp',
            '退货运费险',
            '可免退货运费',
          ),

          // 专属客服微信服务
          _buildFeatureItemFullWidth(
            'assets/images/icon_j.webp',
            '专属客服微信服务',
            '专属客服一对一',
          ),
        ],
      ),
    );
  }

  /// 全宽度功能项 (按照Android布局，每个功能项占满宽度)
  Widget _buildFeatureItemFullWidth(String iconPath, String title, String desc) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
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
      margin: EdgeInsets.only(
        left: 15.w,
        right: 15.w,
        top: 12.h, // 与功能卡片区域的间距12dp
      ),
      padding: EdgeInsets.only(
        top: 12.h,
        bottom: 30.h,
        left: 0,
        right: 0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          // 标题部分
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
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
                    color: const Color(0xFF323233), // color_323233
                  ),
                ),
                SizedBox(width: 20.w),
                Transform.rotate(
                  angle: 3.14159, // 180度
                  child: Image.asset(
                    'assets/images/icon_month_line.webp',
                    width: 40.w,
                    height: 40.h,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 7.h),

          // 三个功能项
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
              color: const Color(0xFF1A1A1A), // color_1A1A1A
            ),
          ),
        ],
      ),
    );
  }

  /// 底部按钮 (模拟UserButtonView)
  Widget _buildBottomButton(ApplyQuotaViewModel viewModel) {
    // 根据状态确定是否为选中状态
    final isSelected = viewModel.userCreditDetail?.status != 1; // 审核中状态为未选中

    return Container(
      margin: EdgeInsets.only(bottom: 30.h), // 底部间距30dp
      padding: EdgeInsets.symmetric(horizontal: 12.w), // 水平间距12dp
      child: SizedBox(
        width: double.infinity,
        height: 49.h,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFF3530) // color_FF3530 - 选中状态
                : const Color(0x4DFF3530), // color_4dFF3530 - 未选中状态
            borderRadius: BorderRadius.circular(29.w), // 圆角29dp
          ),
          child: TextButton(
            onPressed: isSelected ? () => _onApplyButtonPressed(viewModel) : null,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Text(_getButtonText(viewModel)),
          ),
        ),
      ),
    );
  }

  /// 获取按钮文本 (根据Android布局，固定显示"立即开通")
  String _getButtonText(ApplyQuotaViewModel viewModel) {
    return '立即开通';
  }

  /// 按钮点击处理
  void _onApplyButtonPressed(ApplyQuotaViewModel viewModel) {
    final status = viewModel.userCreditDetail?.status ?? 0;

    // 审核中和已通过状态不响应点击
    if (status == 1 || status == 2) {
      return;
    }

    // 根据认证状态跳转不同页面
    if (viewModel.isAuthenticated) {
      // 已认证，跳转到补充信息页面
      _navigateToSupplementMessage();
    } else {
      // 未认证，跳转到认证信息页面
      _navigateToAuthMessage();
    }
  }

  /// 跳转到补充信息页面
  void _navigateToSupplementMessage() {
    context.nav.push(RoutePaths.other.supplementMessage);
  }

  /// 跳转到认证信息页面
  void _navigateToAuthMessage() {
    context.nav.push(
      RoutePaths.other.authMessage,
      arguments: {'hasApply': true},
    );
  }
}
