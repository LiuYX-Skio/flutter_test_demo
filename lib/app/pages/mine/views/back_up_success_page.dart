import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackUpSuccessPage extends StatelessWidget {
  final String? alipayCode;
  final String? money;
  final String? extractPrice;
  final String? handlingFee;
  final String? purpose;
  final String? name;

  const BackUpSuccessPage({
    super.key,
    this.alipayCode,
    this.money,
    this.extractPrice,
    this.handlingFee,
    this.purpose,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            SizedBox(height: 48.h),
            Image.asset(
              'assets/images/icon_back_up_success.png',
              width: 51.w,
              height: 51.w,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 25.h),
            Text(
              '取现成功',
              style: TextStyle(fontSize: 20.sp, color: const Color(0xFF1A1A1A), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24.h),
            Text('预计3个工作日到账', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999))),
            SizedBox(height: 30.h),
            Text('取现详情', style: TextStyle(fontSize: 15.sp, color: const Color(0xFF1A1A1A))),
            Container(
              margin: EdgeInsets.fromLTRB(14.w, 45.h, 14.w, 0),
              height: 1.h,
              color: const Color(0xFFF3F4F5),
            ),
            SizedBox(height: 30.h),
            _item('收款账户', '${alipayCode ?? ''}(${name ?? ''})'),
            _item('取现金额', '${money ?? '0'}元'),
            _item('取现费用', '${handlingFee ?? '0'}元'),
            _item('实际到账', '${extractPrice ?? '0'}元'),
            _item('资金用途', purpose ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SizedBox(
      height: 52.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 5.w,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Image.asset('assets/images/icon_back.webp', width: 12.w, height: 18.h),
              ),
            ),
          ),
          Text('取现结果', style: TextStyle(fontSize: 16.sp, color: const Color(0xFF1A1A1A))),
        ],
      ),
    );
  }

  Widget _item(String title, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 15.h),
      child: Row(
        children: [
          SizedBox(
            width: 110.w,
            child: Text(title, style: TextStyle(fontSize: 15.sp, color: const Color(0xFF999999))),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 15.sp, color: const Color(0xFF1A1A1A))),
          ),
        ],
      ),
    );
  }
}
