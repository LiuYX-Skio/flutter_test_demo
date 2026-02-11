import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/dialog/loading_manager.dart';

class MineChargePage extends StatefulWidget {
  const MineChargePage({super.key});

  @override
  State<MineChargePage> createState() => _MineChargePageState();
}

class _MineChargePageState extends State<MineChargePage> {
  final TextEditingController _moneyController = TextEditingController();

  @override
  void dispose() {
    _moneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Container(height: 12.h, color: Colors.white),
            Container(
              margin: EdgeInsets.fromLTRB(15.w, 8.h, 15.w, 0),
              padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 12.h),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('付款账户', style: TextStyle(fontSize: 15.sp, color: const Color(0xFF1A1A1A)))),
                      Image.asset('assets/images/app_with_draw_alipay.png', width: 16.w, height: 16.w),
                      SizedBox(width: 7.w),
                      Text('支付宝', style: TextStyle(fontSize: 15.sp, color: const Color(0xFF1A1A1A))),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _moneyController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '请输入充值金额',
                      hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFFAFAFAF)),
                      filled: true,
                      fillColor: const Color(0xFFF7F7F7),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.r), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(52.w, 20.h, 52.w, 0),
              width: double.infinity,
              height: 49.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3530),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
                ),
                onPressed: _onSubmit,
                child: Text('提交', style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 52.h,
      color: Colors.white,
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
          Text('充值', style: TextStyle(fontSize: 16.sp, color: const Color(0xFF1A1A1A))),
        ],
      ),
    );
  }

  void _onSubmit() {
    final money = _moneyController.text.trim();
    if (money.isEmpty) {
      LoadingManager.instance.showToast('请输入充值金额');
      return;
    }
    LoadingManager.instance.showToast('充值功能暂未开放');
  }
}
