import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../app/dialog/loading_manager.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../../home/api/user_api.dart';
import '../../home/models/user_models.dart';
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
  final ShopPayViewModel _viewModel = ShopPayViewModel();

  int _stagePosition = 0;

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShopPayViewModel>.value(
      value: _viewModel,
      child: Consumer<ShopPayViewModel>(
        builder: (_, vm, __) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F9FC),
            body: Column(
              children: [
                Container(
                  height: 44.h,
                  color: Colors.white,
                ),
                _buildTopBar(),
                Container(height: 8.h, color: Colors.white),
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 95.h),
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
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildBottom(vm),
                      ),
                    ],
                  ),
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
      color: Colors.white,
      height: 44.h,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: 5.w),
              child: GestureDetector(
                onTap: () => NavigatorService.instance.pop(),
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
          ),
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 56.w),
                child: Text(
                  '宝鱼商城收银台',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.sp, color: const Color(0xFF1A1A1A)),
                ),
              ),
            ),
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
        Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Text(
            '￥',
            style: TextStyle(
              fontSize: 30.sp,
              color: const Color(0xFF1A1A1A),
              fontWeight: FontWeight.bold,
            ),
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
    final amount = double.tryParse(widget.payMoney ?? '0') ?? 0.0;
    return Column(
      children: [
        _payTypeItem(
          icon: 'assets/images/wxzficon.webp',
          title: '微信支付',
          selected: vm.payType == ShopPayViewModel.payTypeWx,
          onTap: () => vm.updatePayType(ShopPayViewModel.payTypeWx),
        ),
        _buildSectionLine(),
        if (!showRecall && _showAliPayHb) ...[
          _payTypeItem(
            icon: 'assets/images/icon_alipay.webp',
            title: '花呗分期支付',
            selected: vm.payType == ShopPayViewModel.payTypeAliPayHb,
            label: '分期付 更轻松',
            onTap: () => vm.updatePayType(ShopPayViewModel.payTypeAliPayHb),
          ),
          _buildSectionLine(),
          if (vm.payType == ShopPayViewModel.payTypeAliPayHb) ...[
            ...List.generate(_stageNum.length, (index) {
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
        ],
        _buildSectionLine(),
        _payTypeItem(
          icon: 'assets/images/icon_alipay.webp',
          title: '支付宝支付',
          selected: vm.payType == ShopPayViewModel.payTypeAliPay,
          onTap: () => vm.updatePayType(ShopPayViewModel.payTypeAliPay),
        ),
        if (!showRecall) ...[
          _buildSectionLine(),
          _payTypeItem(
            icon: 'assets/images/app_logo.webp',
            title: widget.hasMonthCredit ? '月付支付' : '月付支付(部分商品不支持月付)',
            selected: vm.payType == ShopPayViewModel.payTypeMonthPay,
            enabled: widget.hasMonthCredit,
            onTap: () => vm.updatePayType(ShopPayViewModel.payTypeMonthPay),
          ),
          _buildSectionLine(),
          if (_showWalletPay)
            _payTypeItem(
              icon: 'assets/images/app_logo.webp',
              title: '零钱支付',
              selected: vm.payType == ShopPayViewModel.payTypeBalance,
              onTap: () => vm.updatePayType(ShopPayViewModel.payTypeBalance),
            ),
        ],
      ],
    );
  }

  Widget _buildSectionLine() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      height: 1.h,
      color: const Color(0xFFEDEDED),
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
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              if ((label ?? '').isNotEmpty) ...[
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.r),
                    border: Border.all(color: const Color(0xFFFF3530), width: 1.w),
                  ),
                  child: Text(
                    label!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFFFF3530),
                    ),
                  ),
                ),
              ],
              const Spacer(),
              _buildSelectView(selected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectView(bool selected) {
    if (selected) {
      return Image.asset(
        'assets/images/icon_pay_select.webp',
        width: 20.w,
        height: 20.w,
      );
    }
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF909090),
          width: 1.w,
        ),
      ),
    );
  }

  Widget _buildBottom(ShopPayViewModel vm) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 1.h, color: const Color(0xFFCCCCCC)),
          GestureDetector(
            onTap: vm.isPaying ? null : () => _submit(vm),
            child: Container(
              margin: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 30.h),
              height: 44.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFF3530),
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '立即支付 ￥',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _submitMoneyText(widget.payMoney),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _submitMoneyText(String? money) {
    final value = double.tryParse(money ?? '0') ?? 0.0;
    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
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
          if (detail?.status == 2) {
          } else if (detail?.status == 1) {
            NavigatorService.instance.push(RoutePaths.other.examineIng);
            return;
          } else if (detail?.status == 3) {
            NavigatorService.instance.push(
              RoutePaths.other.examineFail,
              arguments: {'nextApplyTIme': detail?.nextApplyTime},
            );
            return;
          } else {
            final hasAuth = await _hasAuthentication();
            if (hasAuth) {
              NavigatorService.instance.push(RoutePaths.other.supplementMessage);
            } else {
              NavigatorService.instance.push(
                RoutePaths.other.applyQuota,
                arguments: {
                  'hasApply': true,
                  'isNeedClose': true,
                  'showBackButton': true,
                },
              );
            }
            return;
          }
        } else {
          NavigatorService.instance.push(
            RoutePaths.other.applyQuota,
            arguments: {
              'hasApply': false,
              'isNeedClose': true,
              'showBackButton': true,
            },
          );
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
