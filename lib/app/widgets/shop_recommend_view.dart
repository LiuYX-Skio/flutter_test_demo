import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_demo/navigation/core/navigator_service.dart';
import 'package:flutter_test_demo/navigation/core/route_paths.dart';
import '../pages/home/models/product_models.dart';

/// 商品推荐视图 - 完全按照Android ShopRecommendView实现
class ShopRecommendView extends StatelessWidget {
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity>? onItemTap;

  const ShopRecommendView({
    super.key,
    required this.products,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 标题行
        _buildTitleRow(),

        // 商品网格
        _buildProductGrid(),
      ],
    );
  }

  /// 标题行
  Widget _buildTitleRow() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10.h, 0, 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/icon_mine_line.png',
            width: 34.w,
            height: 3.h,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12.w),
          Text(
            '精品展示', // common_recommend
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF333333), // color_333333
            ),
          ),
          SizedBox(width: 12.w),
          Transform.rotate(
            angle: 3.14159, // 180度
            child: Image.asset(
              'assets/images/icon_mine_line.png',
              width: 34.w,
              height: 3.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  /// 商品网格
  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        mainAxisExtent: 270.h, // 根据Android布局比例计算
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductItem(context, products[index]);
      },
    );
  }

  /// 商品项
  Widget _buildProductItem(BuildContext context, ProductEntity product) {
    return GestureDetector(
      onTap: () => _onProductTap(context, product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品图片
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.r),
                topRight: Radius.circular(6.r),
              ),
              child: (product.imageUrl ?? '').isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: product.imageUrl!,
                      width: double.infinity,
                      height: 170.h,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: double.infinity,
                        height: 170.h,
                        color: const Color(0xFFCCCCCC),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 170.h,
                      color: const Color(0xFFCCCCCC),
                    ),
            ),

            // 商品标题
            Padding(
              padding: EdgeInsets.only(
                left: 10.w,
                right: 10.w,
                top: 10.h,
              ),
              child: Text(
                product.name ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF1A1A1A), // color_1A1A1A
                  height: 1.2,
                ),
              ),
            ),

            // 商品描述（如果有的话）
            if (product.description != null && product.description!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 10.w,
                  top: 7.h,
                ),
                child: Text(
                  product.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF888888), // color_888888
                  ),
                ),
              ),

            // 价格和购物车图标
            Padding(
              padding: EdgeInsets.only(
                left: 10.w,
                right: 10.w,
                top: 9.h,
                bottom: 9.h,
              ),
              child: Row(
                children: [
                  // 价格
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '¥',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFFFF3530), // color_FF3530
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product.price?.toStringAsFixed(2) ?? '0.00',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: const Color(0xFFFF3530), // color_FF3530
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 购物车图标
                  Image.asset(
                    'assets/images/icon_shop_car.webp',
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 商品点击事件
  void _onProductTap(BuildContext context, ProductEntity product) {
    if (onItemTap != null) {
      onItemTap!(product);
      return;
    }
    if (product.id != null && product.id! > 0) {
      // 跳转到商品详情页
      final routePath = RoutePaths.product.detail;
      context.nav.push(routePath, arguments: {'id': product.id});
    }
  }
}
