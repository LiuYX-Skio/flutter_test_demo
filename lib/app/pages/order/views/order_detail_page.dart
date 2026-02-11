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
import '../widgets/order_utils.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  String? _expressCode;
  String? _orderCode;
  String? _expressPhone;

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
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          SizedBox(height: 44.h),
          _buildTopBar(),
          Expanded(
            child: Consumer<OrderDetailViewModel>(
              builder: (context, viewModel, child) {
                final data = viewModel.detail;
                if (data == null) {
                  return const SizedBox.shrink();
                }
                _expressCode = data.deliveryId;
                _orderCode = data.orderId;
                _expressPhone = data.courierPhone;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildExpressInfo(data),
                      _buildOrderDetailCard(viewModel, data),
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
                '订单详情',
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

  Widget _buildExpressInfo(OrderDetailEntity data) {
    final firstLogistics = data.express?.list?.isNotEmpty == true
        ? data.express!.list!.first
        : null;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      padding: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Row(
              children: [
                Text(
                  '${data.deliveryName ?? ''}${data.deliveryId ?? ''}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF727272),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _copyExpress,
                  child: Text(
                    '复制',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF727272),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  '|',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF727272),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: _callExpress,
                  child: Text(
                    '打电话',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF727272),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD85E40),
                        borderRadius: BorderRadius.circular(7.5.r),
                      ),
                    ),
                    Container(
                      width: 1.w,
                      height: 40.h,
                      color: const Color(0xFFEAE5E5),
                    ),
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFEAE5E5)),
                        borderRadius: BorderRadius.circular(7.5.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _orderStatusText(data.status),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: const Color(0xFFD85E40),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            firstLogistics?.time ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFFD85E40),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => _showLogisticsDetail(data.express?.list),
                            child: Row(
                              children: [
                                Text(
                                  '详细信息',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color(0xFFCE7040),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Image.asset(
                                  'assets/images/icon_t_order_detail_arrow.png',
                                  width: 12.w,
                                  height: 15.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        firstLogistics?.status ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF727272),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        '送至${data.userAddress ?? ''}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${data.realName ?? ''}${data.userPhone ?? ''}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF727272),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFD85E40)),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              '号码保护中',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFFD85E40),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetailCard(
      OrderDetailViewModel viewModel, OrderDetailEntity data) {
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
          _buildPriceLine('商品总价', data.proTotalPrice),
          _buildPriceLine('运费', data.freightPrice),
          _buildPriceLine('运费险', '0.00'),
          _buildPriceLine('商品优惠', '0.00', highlight: true),
          _buildPriceLine('实付款', data.payPrice, highlight: true),
          Divider(height: 24.h, color: const Color(0xFFEAEAEA)),
          _buildKeyValue('收货信息:', data.realName != null
              ? '${data.realName},${data.userPhone},${data.userAddress}'
              : ''),
          if ((data.payTransactionNumber ?? '').isNotEmpty)
            _buildKeyValue('支付宝交易号:', data.payTransactionNumber),
          _buildKeyValue('付款时间', data.payTime),
          if ((data.deliverTime ?? '').isNotEmpty)
            _buildKeyValue('发货时间', data.deliverTime),
          _buildKeyValue('订单编号:', data.orderId, trailingAction: _copyOrder),
        ],
      ),
    );
  }

  Widget _buildPriceLine(String label, String? value,
      {bool highlight = false}) {
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
              color: highlight ? const Color(0xFFEA5816) : const Color(0xFF151515),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            value ?? '0.00',
            style: TextStyle(
              fontSize: 16.sp,
              color: highlight ? const Color(0xFFEA5816) : const Color(0xFF151515),
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

  void _copyExpress() {
    if ((_expressCode ?? '').isEmpty) return;
    Clipboard.setData(ClipboardData(text: _expressCode ?? ''));
    LoadingManager.instance
        .showToast('已将${_expressCode ?? ''}复制到剪切板');
  }

  void _copyOrder() {
    if ((_orderCode ?? '').isEmpty) return;
    Clipboard.setData(ClipboardData(text: _orderCode ?? ''));
    LoadingManager.instance.showToast('已将${_orderCode ?? ''}复制到剪切板');
  }

  void _callExpress() {
    if ((_expressPhone ?? '').isEmpty) {
      LoadingManager.instance.showToast('暂未获取到快递员电话');
      return;
    }
  }

  void _showLogisticsDetail(List<LogisticsEntity>? list) {
    if (list == null || list.isEmpty) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      ),
      builder: (context) {
        return SizedBox(
          height: 500.h,
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              final isLast = index == list.length - 1;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD85E40),
                            borderRadius: BorderRadius.circular(7.5.r),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 1.w,
                            height: 40.h,
                            color: const Color(0xFFE3E7ED),
                          ),
                      ],
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.status ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            item.time ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF989AA1),
                            ),
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
      },
    );
  }

  String _orderStatusText(int? status) {
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
