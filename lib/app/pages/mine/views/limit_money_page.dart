import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_demo/navigation/core/navigator_service.dart';
import 'package:provider/provider.dart';
import '../../../../navigation/core/route_paths.dart';
import '../models/mine_models.dart';
import '../viewmodels/month_pay_viewmodel.dart';

class LimitMoneyPage extends StatefulWidget {
  const LimitMoneyPage({super.key});

  @override
  State<LimitMoneyPage> createState() => _LimitMoneyPageState();
}

class _LimitMoneyPageState extends State<LimitMoneyPage> {
  late MonthPayViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<MonthPayViewModel>(context, listen: false);
      _viewModel.fetchMineCredit(showLoading: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F5),
      body: Consumer<MonthPayViewModel>(
        builder: (context, viewModel, child) {
          final data = viewModel.mineCredit;

          return SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: 312.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF23C38),
                        Color(0xFFFDCCC0),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 44.h),
                    _buildTopBar(),
                    SizedBox(height: 18.h),
                    _buildMainCard(data),
                    SizedBox(height: 15.h),
                    if (data?.hasPetty == true) _buildAdvertCard(),
                    SizedBox(height: 10.h),
                    _buildOpenTitle('您已开通以下权益'),
                    _buildServiceRow(),
                    SizedBox(height: 10.h),
                    _buildOpenTitle('平台月付问答'),
                    _buildQaSection(),
                    SizedBox(height: 30.h),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.asset(
              'assets/images/icon_back.webp',
              width: 20.w,
              height: 20.w,
            ),
          ),
          const Spacer(),
          Text(
            '月付已开通',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _onServiceTap,
            child: Image.asset(
              'assets/images/icon_recall_desc_service.png',
              width: 25.w,
              height: 25.w,
            ),
          ),
          SizedBox(width: 15.w),
          Image.asset(
            'assets/images/icon_recall_setting.png',
            width: 25.w,
            height: 25.w,
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard(MineCreditEntity? data) {
    final dateText = _buildBillDateText(data);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.only(top: 44.h, bottom: 35.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            dateText,
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF1A1A1A)),
          ),
          SizedBox(height: 15.h),
          GestureDetector(
            onTap: () => _onRecallTap(data),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatMoney(data?.lastBill?.totalMoney),
                  style: TextStyle(
                    fontSize: 35.sp,
                    color: const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                Image.asset(
                  'assets/images/icon_limit_arrow.png',
                  width: 9.w,
                  height: 15.h,
                ),
                if ((data?.exceedDay ?? 0) > 0) ...[
                  SizedBox(width: 10.w),
                  Text(
                    '已逾期${data?.exceedDay ?? 0}天',
                    style: TextStyle(fontSize: 14.sp, color: const Color(0xFFFF1D1D)),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 56.h),
          Row(
            children: [
              _buildInfoItem('还款日', '每月${data?.repaymentDate ?? ''}日'),
              _buildInfoItem('总计额度', '${_formatMoney(data?.creditAmount)}元'),
              _buildInfoItem('剩余额度', '${_formatMoney(data?.usableCreditAmount)}元',
                  showHint: data?.hasPetty == true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, {bool showHint = false}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15.sp, color: const Color(0xFF1A1A1A)),
          ),
          SizedBox(height: 22.h),
          if (showHint)
            Text(
              '【可信用取现】',
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFFF6741D)),
            ),
          Text(
            value,
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvertCard() {
    return GestureDetector(
      onTap: _onBackupMoneyTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        child: Image.asset(
          'assets/images/limit_money_advert.webp',
          height: 90.h,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _buildOpenTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/icon_recall_line.png',
          width: 45.w,
          height: 6.5.h,
        ),
        SizedBox(width: 11.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 11.w),
        Transform.rotate(
          angle: 3.1416,
          child: Image.asset(
            'assets/images/icon_recall_line.png',
            width: 45.w,
            height: 6.5.h,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceRow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: _buildServiceItem(
              icon: 'assets/images/icon_t.webp',
              title: '轻松购物优惠多',
              desc: '海量立减优惠，新人专享',
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: _buildServiceItem(
              icon: 'assets/images/icon_m_kf.webp',
              title: '退款无忧有保障',
              desc: '先收货再付款，下单无压力',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem({required String icon, required String title, required String desc}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 19.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Image.asset(icon, width: 38.w, height: 38.w),
          SizedBox(width: 9.5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF999999),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQaSection() {
    final qa = [
      '问：如何提升月付额度？',
      '答：当月付首次还款成功后，无须申请,平台将自动提升月付额度，根据个人守信情况最高达20000元',
      '问：为什么初始月付额度这么低?',
      '答：平台根据个人资质，贷款记录，账户活跃度等综合评估得出的初始额度',
      '问：月付额度如何使用?',
      '答：商城购商品，可进行闲置商品回收（我的页面）',
      '问：关于月付,购物的其他问题如何咨询?',
      '答：月付开通页面以及我的页面-右上角可咨询在线客服',
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 11.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: qa.map((text) {
          final isQuestion = text.startsWith('问');
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: isQuestion ? const Color(0xFF3A3A3A) : const Color(0xFF1A1A1A),
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _buildBillDateText(MineCreditEntity? data) {
    final billMonth = data?.lastBill?.billMonth;
    final exceedDay = data?.exceedDay ?? 0;
    final now = DateTime.now();
    var currentYear = now.year;
    var currentMonth = now.month;

    if (billMonth == null || billMonth.isEmpty) {
      final nextMonth = currentMonth == 12 ? 1 : currentMonth + 1;
      final nextYear = currentMonth == 12 ? currentYear + 1 : currentYear;
      return '$nextYear-$nextMonth月账单累计中';
    }

    int billYear;
    int billMonthInt;
    if (billMonth.contains('-')) {
      final parts = billMonth.split('-');
      billYear = int.tryParse(parts[0]) ?? currentYear;
      billMonthInt = int.tryParse(parts[1]) ?? currentMonth;
    } else {
      billYear = currentYear;
      billMonthInt = int.tryParse(billMonth) ?? currentMonth;
    }

    if (currentMonth == billMonthInt && exceedDay >= 0) {
      final nextMonth = billMonthInt == 12 ? 1 : billMonthInt + 1;
      final nextYear = billMonthInt == 12 ? billYear + 1 : billYear;
      return '$nextYear-$nextMonth月账单累计中';
    }

    return '$billYear-$billMonthInt月应还(元)';
  }

  String _formatMoney(dynamic value) {
    if (value == null) return '0';
    if (value is String) return value;
    if (value is num) {
      final v = value.toDouble();
      if (v == v.roundToDouble()) return v.toInt().toString();
      return v.toStringAsFixed(2);
    }
    return value.toString();
  }

  void _onRecallTap(MineCreditEntity? data) {
    if (data == null) return;
    context.nav.push(
      RoutePaths.other.recallMoney,
      arguments: {
        'minimumRepayment': data.minimumRepayment ?? 0.0,
        'billMonthItem': data.lastBill?.billMonthItem,
        'billMonth': data.lastBill?.billMonth,
        'overdueRepaymentRate': data.overdueRepaymentRate,
        'exceedDay': data.exceedDay ?? 0,
        'totalMoney': data.lastBill?.totalMoney ?? 0.0,
      },
    );
  }

  void _onBackupMoneyTap() {
    context.nav.push(RoutePaths.other.backUpMoney);
  }

  void _onServiceTap() {
    context.nav.push(RoutePaths.other.chatService);
  }
}
