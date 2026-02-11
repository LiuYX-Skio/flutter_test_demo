import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/order_models.dart';
import 'order_message_widget.dart';
import 'order_utils.dart';

class OrderListItemWidget extends StatelessWidget {
  final OrderListEntity data;
  final int orderType;
  final VoidCallback? onPayBuy;
  final VoidCallback? onUpdateAddress;
  final VoidCallback? onDeleteOrder;
  final VoidCallback? onLogistics;
  final VoidCallback? onService;
  final VoidCallback? onTap;

  const OrderListItemWidget({
    super.key,
    required this.data,
    required this.orderType,
    this.onPayBuy,
    this.onUpdateAddress,
    this.onDeleteOrder,
    this.onLogistics,
    this.onService,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasCallBack =
        (data.orderInfoList?.isNotEmpty ?? false) ? (data.orderInfoList?.first.hasCallback ?? true) : true;
    final statusText = _statusText();
    final showRecallReason = orderType == 5 && (data.refundReason?.isNotEmpty ?? false);
    final showNoSupport = !hasCallBack;
    final showDelete = orderType == 1;
    final showLogistics = orderType == 3 || orderType == 4 || orderType == 0;
    final showTick = orderType == 3 || orderType == 4 || orderType == 0;
    final showUpdateAddress = _showUpdateAddress(hasCallBack);
    final showBuy = _showBuyButton(hasCallBack);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/icon_dp.png',
                  width: 18.w,
                  height: 18.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    data.deliveryName ?? '商品名称',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF1A1A1A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF888888),
                  ),
                ),
              ],
            ),
            SizedBox(height: 17.h),
            _buildOrderMessages(),
            SizedBox(height: 20.h),
            _buildServiceRow('全程价保', '（服务生效）'),
            SizedBox(height: 14.h),
            _buildServiceRow('运费险', '（退换货自动赔）'),
            SizedBox(height: 14.h),
            if (showTick)
              GestureDetector(
                onTap: onService,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '发票',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    Text(
                      '咨询客服',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Image.asset(
                      'assets/images/icon_right_arrow.png',
                      width: 6.w,
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            if (showNoSupport) ...[
              SizedBox(height: 10.h),
              Text(
                '该商品不支持退货',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFFE65050),
                ),
              ),
            ],
            if (showRecallReason) ...[
              SizedBox(height: 14.h),
              Text(
                '退款原因：${data.refundReason}',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFFFF4843),
                ),
              ),
            ],
            SizedBox(height: 15.h),
            _buildPriceRow(),
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '更多',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                if (showDelete)
                  _buildButton(
                    text: '删除订单',
                    onTap: onDeleteOrder,
                    borderColor: const Color(0xFFCCCCCC),
                    textColor: const Color(0xFF1A1A1A),
                  ),
                if (showLogistics) ...[
                  SizedBox(width: 8.w),
                  _buildButton(
                    text: '查看物流',
                    onTap: onLogistics,
                    borderColor: const Color(0xFFCCCCCC),
                    textColor: const Color(0xFF1A1A1A),
                  ),
                ],
                if (showUpdateAddress) ...[
                  SizedBox(width: 8.w),
                  _buildButton(
                    text: _updateAddressText(),
                    onTap: onUpdateAddress,
                    borderColor: const Color(0xFFCCCCCC),
                    textColor: const Color(0xFF1A1A1A),
                  ),
                ],
                if (showBuy) ...[
                  SizedBox(width: 8.w),
                  _buildButton(
                    text: _buyText(),
                    onTap: onPayBuy,
                    borderColor: const Color(0xFFFF3530),
                    textColor: const Color(0xFFFF3530),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderMessages() {
    final list = data.orderInfoList ?? [];
    if (list.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: List.generate(list.length, (index) {
        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : 10.h),
          child: OrderMessageWidget(data: list[index]),
        );
      }),
    );
  }

  Widget _buildServiceRow(String left, String right) {
    return Row(
      children: [
        Text(
          left,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        Text(
          right,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF999999),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow() {
    final price = data.payPrice ?? '0.00';
    return Row(
      children: [
        Text(
          '优惠',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF888888),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 3.w),
        Text(
          '¥',
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF888888),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '0',
          style: TextStyle(
            fontSize: 19.sp,
            color: const Color(0xFF888888),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '.00',
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF888888),
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          '实付款',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 3.w),
        Text(
          '¥',
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          OrderPriceUtils.priceInt(price),
          style: TextStyle(
            fontSize: 19.sp,
            color: const Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          OrderPriceUtils.priceDecimal(price),
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    VoidCallback? onTap,
    required Color borderColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 81.w,
        height: 32.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            color: textColor,
          ),
        ),
      ),
    );
  }

  String _statusText() {
    if (orderType == 1) {
      return '等待买家付款';
    }
    if (orderType == 5) {
      switch (data.refundStatus ?? 0) {
        case 0:
          return '未退款';
        case 1:
          return '申请中';
        case 2:
          return '已退款';
        case 3:
          return '退款中';
        case 4:
          return '同意退款';
        case 5:
          return '拒绝退单';
        default:
          return '退款中';
      }
    }
    switch (data.status ?? 0) {
      case 0:
        return '待发货';
      case 1:
        return '待收货';
      case 2:
        return '待评价';
      case 3:
        return '已完成';
      default:
        return '';
    }
  }

  String _buyText() {
    switch (orderType) {
      case 1:
        return '付款';
      case 2:
        return '申请退单';
      case 3:
        return '申请退单';
      case 4:
        return '立即评价';
      case 0:
        return '立即评价';
      case 5:
        return '立即评价';
      default:
        return '付款';
    }
  }

  String _updateAddressText() {
    switch (orderType) {
      case 3:
        return '确认收货';
      case 4:
        return '申请退单';
      case 0:
        return '申请退单';
      default:
        return '修改地址';
    }
  }

  bool _showUpdateAddress(bool hasCallBack) {
    if (orderType == 2) {
      return false;
    }
    if (orderType == 5) {
      return false;
    }
    if ((orderType == 4 || orderType == 0) && !hasCallBack) {
      return false;
    }
    return true;
  }

  bool _showBuyButton(bool hasCallBack) {
    if (orderType == 3) {
      return false;
    }
    if (orderType == 0) {
      return false;
    }
    if (orderType == 2 && !hasCallBack) {
      return false;
    }
    return true;
  }
}
