import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewMonthPayPage extends StatefulWidget {
  const NewMonthPayPage({super.key});

  @override
  State<NewMonthPayPage> createState() => _NewMonthPayPageState();
}

class _NewMonthPayPageState extends State<NewMonthPayPage> {
  String _payType = 'wx';
  final TextEditingController _moneyController = TextEditingController();

  @override
  void dispose() {
    _moneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F2),
      body: Column(
        children: [
          SizedBox(height: 44.h),
          _buildTopBar(),
          SizedBox(height: 40.h),
          _buildTitleRow(),
          SizedBox(height: 50.h),
          _buildPayInput(),
          SizedBox(height: 20.h),
          _buildPayOption(
            title: '微信支付',
            icon: 'assets/images/wxzficon.webp',
            selected: _payType == 'wx',
            onTap: () => setState(() => _payType = 'wx'),
          ),
          Container(
            height: 1.h,
            color: const Color(0xFFEDEDED),
            margin: EdgeInsets.symmetric(horizontal: 12.w),
          ),
          _buildPayOption(
            title: '支付宝',
            icon: 'assets/images/icon_alipay.webp',
            selected: _payType == 'alipay',
            onTap: () => setState(() => _payType = 'alipay'),
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: () {},
            child: Text(
              '消费明细',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFFFF3530),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            '月付约定日：每月1号',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFFFF3530),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          _buildPayButton(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      color: Colors.white,
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
            '月付开通',
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF1A1A1A)),
          ),
          const Spacer(),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                '月付开通',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '先享后付',
                style: TextStyle(fontSize: 14.sp, color: const Color(0xFF7B7B7B)),
              ),
            ],
          ),
        ),
        Text(
          '—',
          style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                '月付使用',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '下单消费',
                style: TextStyle(fontSize: 14.sp, color: const Color(0xFF7B7B7B)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPayInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('月付金额', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333))),
        SizedBox(width: 3.w),
        SizedBox(
          width: 80.w,
          child: TextField(
            controller: _moneyController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: '0',
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Text('元', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333))),
      ],
    );
  }

  Widget _buildPayOption({
    required String title,
    required String icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 57.h,
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          children: [
            Image.asset(icon, width: 23.w, height: 23.w),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(title, style: TextStyle(color: const Color(0xFF1A1A1A))),
            ),
            if (selected)
              Image.asset('assets/images/icon_pay_select.webp', width: 20.w, height: 20.w)
            else
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFF909090), width: 1.w),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      height: 44.h,
      decoration: BoxDecoration(
        color: const Color(0xFFFF3530),
        borderRadius: BorderRadius.circular(23.r),
      ),
      child: TextButton(
        onPressed: _onPay,
        child: Text(
          '立即支付',
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
        ),
      ),
    );
  }

  void _onPay() {
    final value = int.tryParse(_moneyController.text) ?? 0;
    if (value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('输入金额必须大于0')),
      );
      return;
    }
    Navigator.of(context).pop();
  }
}
