import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../models/order_models.dart';
import '../viewmodels/order_detail_viewmodel.dart';
import '../widgets/order_detail_item_widget.dart';

class PaySuccessPage extends StatefulWidget {
  final String orderId;

  const PaySuccessPage({super.key, required this.orderId});

  @override
  State<PaySuccessPage> createState() => _PaySuccessPageState();
}

class _PaySuccessPageState extends State<PaySuccessPage> {
  String? _orderCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderDetailViewModel>(context, listen: false)
          .fetchOrderDetail(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 44.h),
          _buildTopBar(),
          Expanded(
            child: Consumer<OrderDetailViewModel>(
              builder: (context, viewModel, child) {
                final data = viewModel.detail;
                if (data == null) return const SizedBox.shrink();
                _orderCode = data.orderId;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(data),
                      SizedBox(height: 10.h),
                      _buildOrderCard(viewModel, data),
                      SizedBox(height: 20.h),
                    ],
                  ),
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
                '交易成功',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
          ),
          SizedBox(width: 11.w),
        ],
      ),
    );
  }

  Widget _buildHeader(OrderDetailEntity data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          SizedBox(width: 15.w),
          Image.asset(
            'assets/images/icon_t_order_pay_success.png',
            width: 20.w,
            height: 20.w,
          ),
          SizedBox(width: 10.w),
          Text(
            _statusText(data.status),
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFFD85E40),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            width: 1.w,
            height: 15.h,
            color: const Color(0xFFC5C5C5),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              '${data.realName ?? ''}${data.userPhone ?? ''}送至${data.userAddress ?? ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF333333),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Image.asset(
            'assets/images/icon_t_pay_success_arrow.png',
            width: 10.w,
            height: 20.h,
          ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderDetailViewModel viewModel, OrderDetailEntity data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/icon_dp.png',
                width: 18.w,
                height: 18.w,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  '商品名称',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 17.h),
          Column(
            children: (data.orderInfoList ?? [])
                .map(
                  (e) => Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: OrderDetailItemWidget(
                      data: e,
                      onAddShopCar: () {
                        if ((e.productId ?? '').isEmpty ||
                            (e.attrId ?? '').isEmpty) {
                          LoadingManager.instance.showToast('商品信息正在获取中，请稍后');
                          return;
                        }
                        viewModel.addShopCar(
                          carSum: 1,
                          productId: e.productId ?? '',
                          productAttrUnique: e.attrId ?? '',
                          onResult: (success) {
                            if (success) {
                              LoadingManager.instance.showToast('添加购物车成功');
                            }
                          },
                        );
                      },
                      onService: () {
                        context.nav.push(RoutePaths.other.chatService);
                      },
                      onTap: () {
                        if ((e.productId ?? '').isNotEmpty) {
                          context.nav.push(RoutePaths.product.detail,
                              arguments: {
                                'id': int.tryParse(e.productId ?? '0') ?? 0,
                              });
                        }
                      },
                    ),
                  ),
                )
                .toList(),
          ),
          _buildPriceLine('实付款', data.payPrice),
          _buildKeyValue('订单编号:', data.orderId, trailingAction: _copyOrder),
          _buildKeyValue('收货信息:',
              '${data.realName ?? ''},${data.userPhone ?? ''},${data.userAddress ?? ''}'),
          if ((data.payTransactionNumber ?? '').isNotEmpty)
            _buildKeyValue('支付宝交易号:', data.payTransactionNumber),
          _buildKeyValue('创建时间', data.createTime),
          _buildKeyValue('付款时间', data.payTime),
          if ((data.deliverTime ?? '').isNotEmpty)
            _buildKeyValue('发货时间', data.deliverTime),
        ],
      ),
    );
  }

  Widget _buildPriceLine(String label, String? value) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF151515),
              ),
            ),
          ),
          Text(
            '¥',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF151515),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            value ?? '0.00',
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF151515),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyValue(String label, String? value,
      {VoidCallback? trailingAction}) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF151515),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF727272),
              ),
            ),
          ),
          if (trailingAction != null) ...[
            Text(
              '|',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF727272),
              ),
            ),
            SizedBox(width: 5.w),
            GestureDetector(
              onTap: trailingAction,
              child: Text(
                '复制',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _copyOrder() {
    if ((_orderCode ?? '').isEmpty) return;
    Clipboard.setData(ClipboardData(text: _orderCode ?? ''));
    LoadingManager.instance.showToast('已将${_orderCode ?? ''}复制到剪切板');
  }

  String _statusText(int? status) {
    switch (status ?? 0) {
      case 0:
        return '待发货';
      case 1:
        return '待收货';
      case 2:
        return '待评价';
      case 3:
        return '已完成';
      default:
        return '已完成';
    }
  }
}
