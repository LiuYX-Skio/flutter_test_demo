import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../../mine/models/address_models.dart';
import '../api/order_api.dart';
import '../models/order_models.dart';
import '../viewmodels/config_order_viewmodel.dart';
import '../widgets/order_utils.dart';

class ConfigOrderPage extends StatefulWidget {
  final List<ConfigOrderDeliveryEntity> items;
  final String? addressId;
  final String? preOrderType;

  const ConfigOrderPage({
    super.key,
    required this.items,
    this.addressId,
    this.preOrderType,
  });

  @override
  State<ConfigOrderPage> createState() => _ConfigOrderPageState();
}

class _ConfigOrderPageState extends State<ConfigOrderPage> {
  List<ConfigOrderInfoEntity> _detailList = [];
  int _noCallbackCount = 0;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConfigOrderViewModel>(context, listen: false).loadOrderDetail(
        items: widget.items,
        addressId: widget.addressId,
        preOrderType: widget.preOrderType,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          SizedBox(height: 44.h),
          _buildTopBar(),
          Expanded(
            child: Consumer<ConfigOrderViewModel>(
              builder: (context, viewModel, child) {
                final orderInfo = viewModel.orderOut?.orderInfoVo;
                _detailList = (orderInfo?.orderDetailList ?? [])
                    .whereType<ConfigOrderInfoEntity>()
                    .toList();
                _noCallbackCount = 0;
                _totalCount = _detailList.length;
                for (final item in _detailList) {
                  if (item.hasCallback == false) {
                    _noCallbackCount++;
                  }
                }
                return Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 62.h),
                      child: Column(
                        children: [
                          SizedBox(height: 12.h),
                          _buildAddress(viewModel),
                          SizedBox(height: 12.h),
                          _buildOrderList(viewModel),
                          SizedBox(height: 12.h),
                          _buildDesc(orderInfo),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildBottom(viewModel),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 11.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.asset(
              'assets/images/icon_back.webp',
              width: 11.w,
              height: 18.h,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '确认订单',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 11.w),
        ],
      ),
    );
  }

  Widget _buildAddress(ConfigOrderViewModel viewModel) {
    final address = viewModel.address;
    return GestureDetector(
      onTap: () async {
        if (viewModel.orderOut == null) {
          LoadingManager.instance.showToast('正在获取订单数据，请稍后');
          return;
        }
        final result = await NavigatorService.instance.push<UserAddressEntity>(
          RoutePaths.user.addressList,
          arguments: {'isUpdateAddress': true, 'orderId': ''},
        );
        if (!mounted) return;
        if (result.success && result.data != null) {
          Provider.of<ConfigOrderViewModel>(context, listen: false)
              .setAddress(result.data);
        }
      },
      child: Container(
        height: 84.h,
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/icon_address.webp',
              width: 44.w,
              height: 44.w,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                address == null
                    ? '请添加收货地址信息'
                    : '${address.province ?? ''}${address.city ?? ''}${address.district ?? ''}${address.detail ?? ''}',
                style: TextStyle(
                  fontSize: 17.sp,
                  color: const Color(0xFF1A1A1A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Image.asset(
              'assets/images/icon_config_arrow.webp',
              width: 7.w,
              height: 11.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(ConfigOrderViewModel viewModel) {
    return Column(
      children: _detailList.asMap().entries.map((entry) {
        final item = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _ConfigOrderItemWidget(
            item: item,
            onAdd: () => _updateCount(viewModel, item, true),
            onMinus: () => _updateCount(viewModel, item, false),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDesc(ConfigOrderInfoOutEntity? info) {
    final hasCallBack =
        _detailList.isNotEmpty ? (_detailList.first.hasCallback ?? true) : true;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Column(
              children: [
                _buildDescRow(
                  '商品总额',
                  OrderPriceUtils.priceWithSymbol(info?.proTotalFee),
                  valueColor: const Color(0xFFFF3530),
                  valueBold: true,
                ),
                SizedBox(height: 15.h),
                _buildDescRow(
                  '运费',
                  OrderPriceUtils.priceWithSymbol(info?.freightFee ?? '0.00'),
                  valueColor: const Color(0xFF1A1A1A),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Column(
              children: [
                _buildDescRow(
                  '备注',
                  hasCallBack ? '暂无可使用优惠' : '该商品不支持退货',
                  valueColor: const Color(0xFF999999),
                ),
                SizedBox(height: 17.h),
                _buildDescRow(
                  '优惠券',
                  info?.couponFee == null || info!.couponFee!.isEmpty
                      ? '暂无可使用优惠'
                      : OrderPriceUtils.priceWithSymbol(info.couponFee),
                  valueColor: const Color(0xFF999999),
                  trailingIcon: 'assets/images/icon_config_arrow.webp',
                ),
                SizedBox(height: 17.h),
                _buildDescRow(
                  '运费优惠',
                  '已免邮',
                  valueColor: const Color(0xFF999999),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildBottom(ConfigOrderViewModel viewModel) {
    return Container(
      height: 62.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFCCCCCC), width: 0.5.h),
        ),
      ),
      child: Row(
        children: [
          const Spacer(),
          if (viewModel.orderOut?.orderInfoVo?.payFee != null)
            Row(
              children: [
                Text(
                  '合计',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  OrderPriceUtils.priceWithSymbol(
                      viewModel.orderOut?.orderInfoVo?.payFee ?? _calcSum()),
                  style: TextStyle(
                    fontSize: 19.sp,
                    color: const Color(0xFFFF3530),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () => _submitOrder(viewModel),
            child: Container(
              width: 125.w,
              height: 40.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFF3530),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '提交订单',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescRow(
    String label,
    String value, {
    String? trailingIcon,
    required Color valueColor,
    bool valueBold = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF999999),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: valueColor,
            fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (trailingIcon != null) ...[
          SizedBox(width: 8.w),
          Image.asset(trailingIcon, width: 7.w, height: 11.h),
        ],
      ],
    );
  }

  Future<void> _updateCount(
    ConfigOrderViewModel viewModel,
    ConfigOrderInfoEntity item,
    bool isAdd,
  ) async {
    if (viewModel.orderOut == null) {
      LoadingManager.instance.showToast('正在获取订单数据，请稍后');
      return;
    }
    int? next;
    var shouldSyncCart = false;
    String? cartId;
    for (final deliver in widget.items) {
      if (deliver.attrValueId == item.attrValueId) {
        if (!isAdd && deliver.productNum <= 1) {
          next = deliver.productNum;
          break;
        }
        deliver.productNum = isAdd ? (deliver.productNum + 1) : (deliver.productNum - 1);
        next = deliver.productNum;
        shouldSyncCart = true;
        cartId = deliver.shoppingCartId;
        break;
      }
    }
    if (next != null && shouldSyncCart && cartId != null && cartId.isNotEmpty) {
      await OrderApi.updateShopCarSum(
        id: cartId,
        number: next,
        onSuccess: (_) {},
      );
    }
    await viewModel.loadOrder(items: widget.items, preOrderType: widget.preOrderType);
  }

  void _submitOrder(ConfigOrderViewModel viewModel) {
    if (viewModel.orderOut == null) {
      LoadingManager.instance.showToast('正在获取订单数据，请稍后');
      return;
    }
    if (viewModel.address == null) {
      LoadingManager.instance.showToast('请添加收货地址');
      return;
    }
    doSubmit() {
      viewModel.createOrder(
        addressId: viewModel.address?.id,
        couponId: viewModel.orderOut?.orderInfoVo?.userCouponId,
        preOrderNo: viewModel.orderOut?.preOrderNo,
        preOrderType: widget.preOrderType,
        payChannel: 'weixinAppAndroid',
        payType: 'yue',
        phone: viewModel.address?.phone,
        realName: viewModel.address?.realName,
        items: widget.items,
        onSuccess: (data) {
          if ((data?.orderNo ?? '').isNotEmpty) {
            final hasMonthCredit = _detailList.isNotEmpty
                ? _detailList.every((item) => item.hasMonthCredit != false)
                : (viewModel.orderOut?.orderInfoVo?.hasMonthCredit ?? true);
            NavigatorService.instance.push(
              RoutePaths.other.shopPay,
              arguments: {
                'orderNo': data?.orderNo,
                'payMoney': viewModel.orderOut?.orderInfoVo?.payFee ?? _calcSum(),
                'hasMonthCredit': hasMonthCredit,
              },
            );
            Navigator.of(context).pop();
          }
        },
      );
    }
    if (_noCallbackCount > 0) {
      final content = _noCallbackCount > 1
          ? '$_noCallbackCount/$_totalCount个商品不支持是否退货，是否下单？'
          : '该产品不支持七天无理由退货\n确定下单购买？';
      _showBackTipsDialog(
        context: context,
        content: content,
        onConfirm: doSubmit,
      );
    } else {
      doSubmit();
    }
  }

  String _calcSum() {
    double total = 0.0;
    for (final item in _detailList) {
      final price = double.tryParse(item.price ?? '0') ?? 0;
      total += (item.payNum ?? 0) * price;
    }
    return total.toStringAsFixed(2);
  }

  void _showBackTipsDialog({
    required BuildContext context,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30.w),
            padding: EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xFF323232),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(dialogContext).pop(),
                          child: Container(
                            height: 40.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF3530),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              '取消',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(dialogContext).pop();
                            onConfirm();
                          },
                          child: Container(
                            height: 40.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF3530),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              '确定',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ConfigOrderItemWidget extends StatelessWidget {
  final ConfigOrderInfoEntity item;
  final VoidCallback? onAdd;
  final VoidCallback? onMinus;

  const _ConfigOrderItemWidget({
    required this.item,
    this.onAdd,
    this.onMinus,
  });

  @override
  Widget build(BuildContext context) {
    final sku = item.sku ?? '';
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.fromLTRB(10.w, 16.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: CachedNetworkImage(
                    imageUrl: item.image ?? '',
                    width: 94.w,
                    height: 94.w,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 94.w,
                      height: 94.w,
                      color: const Color(0xFFCCCCCC),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 94.w,
                      height: 94.w,
                      color: const Color(0xFFCCCCCC),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: SizedBox(
                    height: 94.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 4.h, right: 25.w),
                          child: Text(
                            item.productName ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF1A1A1A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Text(
                              '¥',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFFFF3530),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              OrderPriceUtils.priceInt(item.price),
                              style: TextStyle(
                                fontSize: 17.sp,
                                color: const Color(0xFFFF3530),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              OrderPriceUtils.priceDecimal(item.price),
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFFFF3530),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            _buildCountButton('-', onMinus),
                            SizedBox(width: 1.w),
                            Container(
                              width: 25.w,
                              height: 25.w,
                              alignment: Alignment.center,
                              color: const Color(0xFFF0F1F2),
                              child: Text(
                                '${item.payNum ?? 0}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            SizedBox(width: 1.w),
                            _buildCountButton('+', onAdd),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (sku.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Row(
              children: [
                Text(
                  '商品规格',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF333333),
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: Text(
                    sku,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCountButton(String text, VoidCallback? onTap) {
    final bool isAdd = text == '+';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25.w,
        height: 25.w,
        alignment: Alignment.center,
        color: isAdd ? const Color(0xFFEDF0F2) : const Color(0xFFF0F1F2),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.sp,
            color: isAdd ? const Color(0xFF313234) : const Color(0xFF9B9C9E),
          ),
        ),
      ),
    );
  }
}
