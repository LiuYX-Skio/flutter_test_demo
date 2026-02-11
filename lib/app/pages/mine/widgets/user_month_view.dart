import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../home/models/user_models.dart';

class UserMonthView extends StatelessWidget {
  final MonthPayEntity? monthPayInfo;
  final VoidCallback? onMonthApply;
  final VoidCallback? onMonthBill;

  const UserMonthView({
    super.key,
    this.monthPayInfo,
    this.onMonthApply,
    this.onMonthBill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Container(height: 1.h, color: const Color(0xFFEDEFF2)),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      alignment: Alignment.centerLeft,
      child: Text(
        '宝鱼月付（购买商品后可回收返现）',
        style: TextStyle(
          fontSize: 17.sp,
          color: const Color(0xFF1A1A1A),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      height: 96.h,
      padding: EdgeInsets.only(top: 16.h),
      child: Row(
        children: [
          _buildItem(
            title: '可用额度',
            value: _formatValue(monthPayInfo?.creditAmountResult),
            onTap: onMonthApply,
          ),
          _buildItem(
            title: '上月未还',
            value: _formatValue(monthPayInfo?.upMonthUnpaidAmount),
          ),
          _buildItem(
            title: '还款日',
            value: _formatDay(monthPayInfo?.repaymentDate),
          ),
          _buildRecordItem(),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF888888),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF333333),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordItem() {
    return Expanded(
      child: GestureDetector(
        onTap: onMonthBill,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '月付账单',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF888888),
              ),
            ),
            SizedBox(height: 10.h),
            Image.asset(
              'assets/images/mine_month_pay.webp',
              width: 26.w,
              height: 32.h,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }

  String _formatValue(String? value) {
    if (value == null || value.isEmpty) return '--';
    return value;
  }

  String _formatDay(int? day) {
    if (day == null || day == 0) return '--';
    return '${day}日';
  }
}
