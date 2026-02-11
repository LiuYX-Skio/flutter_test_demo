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
                          _buildAddress(viewModel.address),
                          SizedBox(height: 12.h),
                          _buildOrderList(),
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

  Widget _buildAddress(UserAddressEntity? address) {
    return GestureDetector(
      onTap: () async {
        final result = await NavigatorService.instance.push<UserAddressEntity>(
          RoutePaths.user.addressList,
          arguments: {'isUpdateAddress': true, 'orderId': ''},
        );
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
                    : '${address.realName ?? ''} ${address.phone ?? ''}\n'
                        '${address.province ?? ''}${address.city ?? ''}${address.district ?? ''}${address.detail ?? ''}',
                style: TextStyle(
                  fontSize: 17.sp,
                  color: const Color(0xFF1A1A1A),
                ),
                maxLines: 2,
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

  Widget _buildOrderList() {
    return Column(
      children: _detailList.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _ConfigOrderItemWidget(
            item: item,
            onAdd: () => _updateCount(index, true),
            onMinus: () => _updateCount(index, false),
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
                _buildDescRow('商品总额',
                    OrderPriceUtils.priceWithSymbol(info?.proTotalFee)),
                SizedBox(height: 15.h),
                _buildDescRow('运费',
                    OrderPriceUtils.priceWithSymbol(info?.freightFee ?? '0.00')),
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
                _buildDescRow('备注', hasCallBack ? '暂无可使用优惠' : '该商品不支持退货'),
                SizedBox(height: 17.h),
                _buildDescRow(
                  '优惠券',
                  info?.couponFee == null || info!.couponFee!.isEmpty
                      ? '暂无可使用优惠'
                      : OrderPriceUtils.priceWithSymbol(info.couponFee),
                  trailingIcon: 'assets/images/icon_config_arrow.webp',
                ),
                SizedBox(height: 17.h),
                _buildDescRow('运费优惠', '已免邮'),
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
          if (viewModel.orderOut?.orderInfoVo?.payFee != null ||
              _detailList.isNotEmpty)
            Row(
              children: [
                Text(
                  '合计:',
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

  Widget _buildDescRow(String label, String value, {String? trailingIcon}) {
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
            color: label == '商品总额'
                ? const Color(0xFFFF3530)
                : const Color(0xFF1A1A1A),
            fontWeight: label == '商品总额' ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (trailingIcon != null) ...[
          SizedBox(width: 8.w),
          Image.asset(trailingIcon, width: 7.w, height: 11.h),
        ],
      ],
    );
  }

  void _updateCount(int index, bool isAdd) {
    if (index >= _detailList.length) return;
    final item = _detailList[index];
    final current = item.payNum ?? 0;
    final next = isAdd ? current + 1 : current - 1;
    if (next <= 0) {
      setState(() {
        _detailList.removeAt(index);
      });
      return;
    }
    setState(() {
      item.payNum = next;
    });
    String? cartId;
    for (final deliver in widget.items) {
      if (deliver.attrValueId == item.attrValueId) {
        deliver.productNum = next;
        cartId = deliver.shoppingCartId;
        break;
      }
    }
    if (cartId != null && cartId.isNotEmpty) {
      OrderApi.updateShopCarSum(
        id: cartId,
        number: next,
        onSuccess: (_) {},
      );
    }
    Provider.of<ConfigOrderViewModel>(context, listen: false)
        .loadOrder(items: widget.items, preOrderType: widget.preOrderType);
  }

  void _submitOrder(ConfigOrderViewModel viewModel) {
    if (viewModel.address == null) {
      LoadingManager.instance.showToast('请添加收货地址信息');
      return;
    }
    doSubmit() {
      viewModel.createOrder(
        addressId: viewModel.address?.id,
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
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(content, style: TextStyle(fontSize: 14.sp)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  doSubmit();
                },
                child: const Text('确定'),
              ),
            ],
          );
        },
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.fromLTRB(10.w, 16.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        children: [
          Row(
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
                      Text(
                        item.productName ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF1A1A1A),
                          fontWeight: FontWeight.bold,
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
              Text(
                item.sku ?? '',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountButton(String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25.w,
        height: 25.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.sp,
            color: const Color(0xFF313234),
          ),
        ),
      ),
    );
  }
}
