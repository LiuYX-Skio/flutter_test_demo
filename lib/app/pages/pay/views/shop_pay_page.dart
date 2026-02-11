import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../viewmodels/shop_pay_viewmodel.dart';
import '../widgets/alipay_hb_stage_item_widget.dart';

class ShopPayPage extends StatefulWidget {
  final String? orderNo;
  final String? orderId;
  final String? payMoney;
  final bool hasMonthCredit;
  final int viewType;

  const ShopPayPage({
    super.key,
    this.orderNo,
    this.orderId,
    this.payMoney,
    this.hasMonthCredit = true,
    this.viewType = 0,
  });

  @override
  State<ShopPayPage> createState() => _ShopPayPageState();
}

class _ShopPayPageState extends State<ShopPayPage> {
  final List<int> _stageNum = const [3, 6, 12];
  final List<double> _stageRate = const [0.023, 0.045, 0.075];
  final bool _showAliPayHb = false;
  final bool _showWalletPay = false;
  int _stagePosition = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShopPayViewModel(),
      child: Consumer<ShopPayViewModel>(
        builder: (_, vm, __) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F9FC),
            body: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Column(
                    children: [
                      _buildTopBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: 84.h),
                          child: Column(
                            children: [
                              SizedBox(height: 42.h),
                              Text(
                                '实付金额',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                              SizedBox(height: 46.h),
                              _buildMoney(widget.payMoney),
                              SizedBox(height: 50.h),
                              _buildPayTypeList(vm),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 12.w,
                    right: 12.w,
                    bottom: 30.h,
                    child: _buildSubmit(vm),
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
            '宝鱼商城收银台',
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF1A1A1A)),
          ),
        ],
      ),
    );
  }

  Widget _buildMoney(String? money) {
    final value = double.tryParse(money ?? '0') ?? 0;
    final text = value.toStringAsFixed(2);
    final parts = text.split('.');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '￥',
          style: TextStyle(
            fontSize: 30.sp,
            color: const Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          parts[0],
          style: TextStyle(
            fontSize: 44.sp,
            color: const Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '.${parts[1]}',
          style: TextStyle(
            fontSize: 31.sp,
            color: const Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPayTypeList(ShopPayViewModel vm) {
    final showRecall = widget.viewType == ShopPayViewModel.viewTypeRecallPay;
    return Column(
      children: [
        _payTypeItem(
          icon: 'assets/images/wxzficon.webp',
          title: '微信支付',
          selected: vm.payType == ShopPayViewModel.payTypeWx,
          onTap: () => vm.updatePayType(ShopPayViewModel.payTypeWx),
        ),
        if (!showRecall && _showAliPayHb) ...[
          _payTypeItem(
            icon: 'assets/images/icon_alipay.webp',
            title: '花呗分期支付',
            selected: vm.payType == ShopPayViewModel.payTypeAliPayHb,
            label: '分期付 更轻松',
            onTap: () => vm.updatePayType(ShopPayViewModel.payTypeAliPayHb),
          ),
          if (vm.payType == ShopPayViewModel.payTypeAliPayHb)
            ...List.generate(_stageNum.length, (index) {
              final amount = double.tryParse(widget.payMoney ?? '0') ?? 0.0;
              return AlipayHbStageItemWidget(
                selected: _stagePosition == index,
                stageNum: _stageNum[index],
                stageRate: _stageRate[index],
                totalMoney: amount,
                showLine: index != _stageNum.length - 1,
                onTap: () => setState(() => _stagePosition = index),
              );
            }),
        ],
        _payTypeItem(
          icon: 'assets/images/icon_alipay.webp',
          title: '支付宝支付',
          selected: vm.payType == ShopPayViewModel.payTypeAliPay,
          onTap: () => vm.updatePayType(ShopPayViewModel.payTypeAliPay),
        ),
        if (!showRecall) ...[
          if (_showWalletPay)
            _payTypeItem(
              icon: 'assets/images/app_logo.webp',
              title: '零钱支付',
              selected: vm.payType == ShopPayViewModel.payTypeBalance,
              onTap: () => vm.updatePayType(ShopPayViewModel.payTypeBalance),
            ),
          _payTypeItem(
            icon: 'assets/images/app_logo.webp',
            title: widget.hasMonthCredit ? '月付支付' : '月付支付(部分商品不支持月付)',
            selected: vm.payType == ShopPayViewModel.payTypeMonthPay,
            enabled: widget.hasMonthCredit,
            onTap: () => vm.updatePayType(ShopPayViewModel.payTypeMonthPay),
          ),
        ],
      ],
    );
  }

  Widget _payTypeItem({
    required String icon,
    required String title,
    String? label,
    required bool selected,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        height: 57.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Opacity(
          opacity: enabled ? 1.0 : 0.6,
          child: Row(
            children: [
              Image.asset(icon, width: 23.w, height: 23.w),
              SizedBox(width: 14.w),
              Text(
                title,
                style:
                    TextStyle(fontSize: 14.sp, color: const Color(0xFF1A1A1A)),
              ),
              if ((label ?? '').isNotEmpty) ...[
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.r),
                    border:
                        Border.all(color: const Color(0xFFFF3530), width: 1.w),
                  ),
                  child: Text(
                    label!,
                    style: TextStyle(
                        fontSize: 10.sp, color: const Color(0xFFFF3530)),
                  ),
                ),
              ],
              const Spacer(),
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
      ),
    );
  }

  Widget _buildSubmit(ShopPayViewModel vm) {
    final money = widget.payMoney ?? '0.00';
    return GestureDetector(
      onTap: vm.isPaying ? null : () => _submit(vm),
      child: Container(
        height: 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFF3530),
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Text(
          '立即支付 ￥$money',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _submit(ShopPayViewModel vm) async {
    bool success = false;
    if (widget.viewType == ShopPayViewModel.viewTypeRecallPay) {
      final billMonthItem = widget.orderNo ?? '';
      if (billMonthItem.isEmpty) {
        LoadingManager.instance.showToast('订单信息缺失');
        return;
      }
      success = await vm.submitRecallPay(
        billMonthItem: billMonthItem,
        money: widget.payMoney ?? '0',
      );
    } else {
      if (vm.payType == ShopPayViewModel.payTypeMonthPay) {
        await vm.userCreditDetail();
        final detail = vm.userCreditEntity;
        if (detail?.hasApply == true) {
          if (detail?.status == 1) {
            NavigatorService.instance.push(RoutePaths.other.examineIng);
            return;
          }
          if (detail?.status == 3) {
            NavigatorService.instance.push(
              RoutePaths.other.examineFail,
              arguments: {'nextApplyTIme': detail?.nextApplyTime},
            );
            return;
          }
          if (detail?.status != 2) {
            NavigatorService.instance
                .push(RoutePaths.other.applyQuota, arguments: {
              'hasApply': true,
              'isNeedClose': true,
            });
            return;
          }
        } else {
          NavigatorService.instance
              .push(RoutePaths.other.applyQuota, arguments: {
            'hasApply': false,
            'isNeedClose': true,
          });
          return;
        }
      }
      final orderNo = widget.orderNo ?? '';
      if (orderNo.isEmpty) {
        LoadingManager.instance.showToast('订单信息缺失');
        return;
      }
      success = await vm.submitOrderPay(
        orderNo: orderNo,
        orderId: widget.orderId,
        stageNum: _stageNum[_stagePosition],
      );
    }

    if (success) {
      if (widget.viewType != ShopPayViewModel.viewTypeOrderPay) {
        NavigatorService.instance.push(
          RoutePaths.other.orderList,
          arguments: {'currentPage': 2},
        );
      } else {
        NavigatorService.instance.pop(true);
      }
      return;
    }

    final msg = vm.errorMessage ?? '支付失败';
    LoadingManager.instance.showToast(msg);
    if (msg.contains('SDK尚未接入')) {
      LoadingManager.instance.showToast('支付请求已发起，待支付SDK接入后可完成支付');
    }
  }
}
