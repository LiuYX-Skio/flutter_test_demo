import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/product_models.dart';

/// 排行榜商品项组件
/// 对应Android的item_home_sort.xml
class HomeSortItemWidget extends StatelessWidget {
  final ProductEntity product;
  final String title;
  final VoidCallback? onTap;

  const HomeSortItemWidget({
    Key? key,
    required this.product,
    this.title = 'IPones',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 171.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleBar(),
            _buildProductImage(),
            _buildPrice(),
          ],
        ),
      ),
    );
  }

  /// 构建商品图片（高度115dp）
  Widget _buildProductImage() {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 8.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: CachedNetworkImage(
          imageUrl: product.imageUrl ?? '',
          width: double.infinity,
          height: 115.h,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: const Color(0xFFCCCCCC),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: const Color(0xFFCCCCCC),
          ),
        ),
      ),
    );
  }

  /// 构建价格
  Widget _buildPrice() {
    return Container(
      margin: EdgeInsets.only(left: 10.w, top: 13.h, bottom: 14.h),
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
            product.price?.toString() ?? '0.00',
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFFFF3530),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建标题栏（高度40dp）
  Widget _buildTitleBar() {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/home_sort_title.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.r),
          topRight: Radius.circular(6.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.w, top: 4.h),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
          ),
          Text(
            'more',
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF909396),
            ),
          ),
          SizedBox(width: 8.w),
          Image.asset(
            'assets/images/icon_jt.png',
            width: 12.w,
            height: 12.w,
          ),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }
}
