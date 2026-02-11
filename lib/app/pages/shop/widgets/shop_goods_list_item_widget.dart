import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/shop_detail_models.dart';

class ShopGoodsListItemWidget extends StatelessWidget {
  final ShopInfoEntity item;
  final VoidCallback? onTap;

  const ShopGoodsListItemWidget({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: CachedNetworkImage(
                imageUrl: item.flatPattern ?? '',
                width: 88.w,
                height: 88.w,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 88.w,
                  height: 88.w,
                  color: const Color(0xFFCCCCCC),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 88.w,
                  height: 88.w,
                  color: const Color(0xFFCCCCCC),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SizedBox(
                height: 88.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.storeName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '¥',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFFFF3530),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _price(item.price),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: const Color(0xFFFF3530),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          'assets/images/icon_hot_car.webp',
                          width: 24.w,
                          height: 24.w,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _price(double? value) {
    if (value == null) return '0.00';
    return value.toStringAsFixed(2);
  }
}

