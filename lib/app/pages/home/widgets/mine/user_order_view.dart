import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_demo/navigation/core/navigator_service.dart';
import 'package:flutter_test_demo/navigation/core/route_paths.dart';
import 'package:flutter_test_demo/app/provider/user_provider.dart';

/// 用户订单视图
class UserOrderView extends StatelessWidget {
  const UserOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        children: [
          // 查看全部订单行
          _buildAllOrdersRow(),

          // 分割线
          Container(
            height: 1.h,
            color: const Color(0xFFEDEFF2), // color_EDEFF2
          ),

          // 订单状态行
          _buildOrderStatusRow(),
          SizedBox(height: 16.h,)
        ],
      ),
    );
  }

  /// 查看全部订单行
  Widget _buildAllOrdersRow() {
    return GestureDetector(
      onTap: _onAllOrdersTap,
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '我的订单',
                style: TextStyle(
                  fontSize: 17.sp,
                  color: const Color(0xFF1A1A1A), // color_1A1A1A
                ),
              ),
            ),
            Text(
              '查看全部',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF888888), // color_888888
              ),
            ),
            SizedBox(width: 9.w),
            Image.asset(
              'assets/images/icon_right_arrow.png',
              width: 6.w,
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }

  /// 订单状态行
  Widget _buildOrderStatusRow() {
    return Container(
      padding: EdgeInsets.only(top: 16.h),
      child: Row(
        children: [
          _buildOrderStatusItem(
            'assets/images/icon_dfk.png',
            '待付款', // mine_pay
            0,
          ),
          _buildOrderStatusItem(
            'assets/images/icon_dfh.png',
            '待发货', // mine_send
            1,
          ),
          _buildOrderStatusItem(
            'assets/images/icon_dhh.png',
            '待收货', // mine_receive
            2,
          ),
          _buildOrderStatusItem(
            'assets/images/icon_dpj.png',
            '待评价', // mine_comment
            3,
          ),
          _buildOrderStatusItem(
            'assets/images/icon_tk.png',
            '退货/款', // mine_recall
            4,
          ),
        ],
      ),
    );
  }

  /// 订单状态项
  Widget _buildOrderStatusItem(String iconPath, String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onOrderStatusTap(index),
        child: Column(
          children: [
            Image.asset(
              iconPath,
              width: 32.w,
              height: 32.h,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF333333), // color_333333
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 查看全部订单点击
  void _onAllOrdersTap() {
    if (UserProvider.isLogin()) {
      NavigatorService.instance.push(RoutePaths.other.orderList);
    } else {
      NavigatorService.instance.push(RoutePaths.auth.login);
    }
  }

  /// 订单状态点击
  void _onOrderStatusTap(int index) {
    if (UserProvider.isLogin()) {
      final currentPage = index + 1;
      NavigatorService.instance.push(RoutePaths.other.orderList, arguments: {
        'currentPage': currentPage,
      });
    } else {
      NavigatorService.instance.push(RoutePaths.auth.login);
    }
  }
}
