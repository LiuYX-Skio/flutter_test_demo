import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/order_models.dart';
import 'order_utils.dart';

class RecycleShopItemWidget extends StatelessWidget {
  final RecycleShopEntity data;
  final String statusText;
  final VoidCallback? onTap;

  const RecycleShopItemWidget({
    super.key,
    required this.data,
    required this.statusText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  'assets/images/icon_recyle_order.webp',
                  width: 18.w,
                  height: 18.w,
                  fit: BoxFit.fill,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '回购订单 ${data.orderNo ?? ''}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF1A1A1A),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: _buildImage(),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.orderInfoResponse?.storeName ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF1A1A1A),
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 11.h),
                      Text(
                        _formatSku(data.orderInfoResponse?.sku),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '¥',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF1A1A1A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          OrderPriceUtils.priceInt(data.recyclePrice),
                          style: TextStyle(
                            fontSize: 17.sp,
                            color: const Color(0xFF1A1A1A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          OrderPriceUtils.priceDecimal(data.recyclePrice),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF1A1A1A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = data.orderInfoResponse?.image ?? '';
    if (imageUrl.isEmpty) {
      return Container(
        width: 94.w,
        height: 94.w,
        color: const Color(0xFFCCCCCC),
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
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
    );
  }

  String _formatSku(String? sku) {
    if (sku == null || sku.isEmpty) return '';
    if (!sku.contains(',')) return sku;
    return sku.split(',').join();
  }
}
