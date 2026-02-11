import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/order_models.dart';
import 'order_utils.dart';

class OrderMessageWidget extends StatelessWidget {
  final OrderInfoListEntity data;

  const OrderMessageWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                data.storeName ?? '',
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
                _formatSku(data.sku),
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
                  OrderPriceUtils.priceInt(data.price),
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  OrderPriceUtils.priceDecimal(data.price),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 9.h),
            Text(
              '共${data.cartNum ?? 0}件',
              style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xFF999999),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (data.image == null || data.image!.isEmpty) {
      return Container(
        width: 94.w,
        height: 94.w,
        color: const Color(0xFFCCCCCC),
      );
    }
    return CachedNetworkImage(
      imageUrl: data.image!,
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
