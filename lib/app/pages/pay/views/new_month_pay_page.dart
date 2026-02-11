import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../viewmodels/shop_pay_viewmodel.dart';

class NewMonthPayPage extends StatefulWidget {
  const NewMonthPayPage({super.key});

  @override
  State<NewMonthPayPage> createState() => _NewMonthPayPageState();
}

class _NewMonthPayPageState extends State<NewMonthPayPage> {
  final TextEditingController _moneyController = TextEditingController();

  @override
  void dispose() {
    _moneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShopPayViewModel(),
      child: Consumer<ShopPayViewModel>(
        builder: (_, vm, __) {
          return Scaffold(
            backgroundColor: const Color(0xFFF0F1F2),
            body: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 100.h),
                    child: Column(
                      children: [
                        _buildTopBar(),
                        SizedBox(height: 40.h),
                        _buildTitle(),
                        SizedBox(height: 50.h),
                        _buildInput(),
                        SizedBox(height: 20.h),
                        _buildPayItem(
                          title: '微信支付',
                          icon: 'assets/images/wxzficon.webp',
                          selected: vm.payType == ShopPayViewModel.payTypeWx,
                          onTap: () =>
                              vm.updatePayType(ShopPayViewModel.payTypeWx),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.w),
                          height: 1.h,
                          color: const Color(0xFFEDEDED),
                        ),
                        _buildPayItem(
                          title: '支付宝支付',
                          icon: 'assets/images/icon_alipay.webp',
                          selected:
                              vm.payType == ShopPayViewModel.payTypeAliPay,
                          onTap: () =>
                              vm.updatePayType(ShopPayViewModel.payTypeAliPay),
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                            NavigatorService.instance
                                .push(RoutePaths.other.orderList);
                          },
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
                      ],
                    ),
                  ),
                  Positioned(
                    left: 12.w,
                    right: 12.w,
                    bottom: 30.h,
                    child: GestureDetector(
                      onTap: vm.isPaying ? null : () => _pay(vm),
                      child: Container(
                        height: 44.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3530),
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                        child: Text(
                          '立即支付',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      height: 52.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 5.w,
            child: GestureDetector(
              onTap: () => NavigatorService.instance.pop(),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Image.asset(
                  'assets/images/icon_back.webp',
                  width: 12.w,
                  height: 18.h,
                ),
              ),
            ),
          ),
          Text(
            '月付已开通',
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF1A1A1A)),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                '用月付消费',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '下单不扣钱',
                style:
                    TextStyle(fontSize: 14.sp, color: const Color(0xFF7B7B7B)),
              ),
            ],
          ),
        ),
        Text(
          '-->',
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
                '收货后月付约定日付款',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '微信/支付宝支付',
                style:
                    TextStyle(fontSize: 14.sp, color: const Color(0xFF7B7B7B)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('已到月付约定日去付款',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333))),
        SizedBox(width: 4.w),
        SizedBox(
          width: 60.w,
          child: TextField(
            controller: _moneyController,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '0',
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Text('元',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333))),
      ],
    );
  }

  Widget _buildPayItem({
    required String title,
    required String icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        height: 57.h,
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
              child: Text(
                title,
                style:
                    TextStyle(fontSize: 14.sp, color: const Color(0xFF1A1A1A)),
              ),
            ),
            Image.asset(
              selected
                  ? 'assets/images/icon_pay_select.webp'
                  : 'assets/images/ic_un_select.png',
              width: 20.w,
              height: 20.w,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pay(ShopPayViewModel vm) async {
    final moneyText = _moneyController.text.trim();
    final money = int.tryParse(moneyText) ?? 0;
    if (money <= 0) {
      LoadingManager.instance.showToast('输入金额必须大于0');
      return;
    }
    final success = await vm.submitTestPay(money: moneyText);
    if (success) {
      NavigatorService.instance.pop(true);
    } else {
      LoadingManager.instance.showToast(vm.errorMessage ?? '支付失败');
    }
  }
}
