import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/product_models.dart';

/// 排行榜列表组件
class RankingListWidget extends StatelessWidget {
  final List<ProductEntity> products;
  final Function(ProductEntity)? onTap;

  const RankingListWidget({
    Key? key,
    required this.products,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _RankingItem(
          product: product,
          rank: index + 1,
          onTap: () => onTap?.call(product),
        );
      },
    );
  }
}

/// 排行榜项组件
class _RankingItem extends StatelessWidget {
  final ProductEntity product;
  final int rank;
  final VoidCallback? onTap;

  const _RankingItem({
    Key? key,
    required this.product,
    required this.rank,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 排名
            _buildRankBadge(),
            SizedBox(width: 12.w),
            // 商品图片
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl ?? '',
                width: 80.w,
                height: 80.w,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // 商品信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? '',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '¥${product.price?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  if (product.salesCount != null)
                    Text(
                      '销量：${product.salesCount}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankBadge() {
    Color badgeColor;
    if (rank == 1) {
      badgeColor = const Color(0xFFFFD700); // 金色
    } else if (rank == 2) {
      badgeColor = const Color(0xFFC0C0C0); // 银色
    } else if (rank == 3) {
      badgeColor = const Color(0xFFCD7F32); // 铜色
    } else {
      badgeColor = Colors.grey[400]!;
    }

    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$rank',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
