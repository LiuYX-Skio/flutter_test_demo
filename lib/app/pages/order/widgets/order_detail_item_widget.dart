import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/order_models.dart';
import 'order_utils.dart';

class OrderDetailItemWidget extends StatelessWidget {
  final OrderInfoListEntity data;
  final VoidCallback? onAddShopCar;
  final VoidCallback? onService;
  final VoidCallback? onTap;

  const OrderDetailItemWidget({
    super.key,
    required this.data,
    this.onAddShopCar,
    this.onService,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasCallBack = data.hasCallback ?? true;
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
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
                        ),
                        SizedBox(width: 10.w),
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
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _formatSku(data.sku),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF888888),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        _buildTag(
                          hasCallBack ? '7天无理由退货' : '不支持退货',
                        ),
                        const Spacer(),
                        Text(
                          'x${data.cartNum ?? 0}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            const Spacer(),
            _buildActionButton(
              text: '申请售后',
              onTap: onService,
              background: Colors.white,
              borderColor: const Color(0xFFCCCCCC),
              textColor: const Color(0xFF1A1A1A),
            ),
            SizedBox(width: 8.w),
            _buildActionButton(
              text: '加入购物车',
              onTap: onAddShopCar,
              background: Colors.white,
              borderColor: const Color(0xFFD85E40),
              textColor: const Color(0xFFD85E40),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    VoidCallback? onTap,
    required Color background,
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
          color: background,
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

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD85E40)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          color: const Color(0xFFD85E40),
        ),
      ),
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
