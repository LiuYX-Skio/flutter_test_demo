import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 商品详情底部操作栏
/// 对应 Android 的 ShopDetailBottomView
class ShopDetailBottomWidget extends StatefulWidget {
  /// 是否已收藏
  final bool isCollected;

  /// 购物车数量
  final int cartCount;

  /// 商品ID
  final String? productId;

  /// 收藏状态改变回调
  final VoidCallback? onCollectTap;

  /// 加入购物车回调
  final VoidCallback? onAddToCartTap;

  /// 立即购买回调
  final VoidCallback? onBuyNowTap;

  /// 首页按钮回调
  final VoidCallback? onHomeTap;

  /// 客服按钮回调
  final VoidCallback? onServiceTap;

  /// 购物车按钮回调
  final VoidCallback? onCartTap;

  const ShopDetailBottomWidget({
    Key? key,
    this.isCollected = false,
    this.cartCount = 0,
    this.productId,
    this.onCollectTap,
    this.onAddToCartTap,
    this.onBuyNowTap,
    this.onHomeTap,
    this.onServiceTap,
    this.onCartTap,
  }) : super(key: key);

  @override
  State<ShopDetailBottomWidget> createState() => _ShopDetailBottomWidgetState();
}

class _ShopDetailBottomWidgetState extends State<ShopDetailBottomWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFCCCCCC),
            width: 0.5.h,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            // 首页按钮
            _buildIconButton(
              icon: 'assets/images/icon_shop_home.webp',
              label: '首页',
              onTap: widget.onHomeTap,
            ),
            SizedBox(width: 18.w),

            // 客服按钮
            _buildIconButton(
              icon: 'assets/images/icon_shop_service.webp',
              label: '客服',
              onTap: widget.onServiceTap,
            ),
            SizedBox(width: 18.w),

            // 收藏按钮
            _buildIconButton(
              icon: widget.isCollected
                  ? 'assets/images/icon_shop_collect.webp'
                  : 'assets/images/icon_shop_uncollect.webp',
              label: '收藏',
              onTap: widget.onCollectTap,
            ),
            SizedBox(width: 18.w),

            // 购物车按钮（带角标）
            _buildCartButton(),

            const Spacer(),

            // 加入购物车按钮
            _buildActionButton(
              text: '加入购物车',
              width: 95.w,
              height: 40.h,
              backgroundColor: const Color(0xFFFF6B00),
              onTap: widget.onAddToCartTap,
            ),

            SizedBox(width: 8.w),

            // 立即购买按钮
            _buildActionButton(
              text: '立即购买',
              width: 95.w,
              height: 40.h,
              backgroundColor: const Color(0xFFE65050),
              onTap: widget.onBuyNowTap,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建图标按钮
  Widget _buildIconButton({
    required String icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: 20.w,
            height: 20.w,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 20.w,
                height: 20.w,
                color: Colors.grey[300],
              );
            },
          ),
          SizedBox(height: 6.5.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Color(0xFF615F69),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建购物车按钮（带角标）
  Widget _buildCartButton() {
    return GestureDetector(
      onTap: widget.onCartTap,
      child: SizedBox(
        width: 40.w,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/icon_shop_car.webp',
                  width: 20.w,
                  height: 20.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 20.w,
                      height: 20.w,
                      color: Colors.grey[300],
                    );
                  },
                ),
                SizedBox(height: 6.5.h),
                Text(
                  '购物车',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Color(0xFF615F69),
                  ),
                ),
              ],
            ),
            // 购物车数量角标
            if (widget.cartCount > 0)
              Positioned(
                top: (-2).h,
                right: 0.w,
                child: Container(
                  width: 14.w,
                  height: 14.w,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  child: Center(
                    child: Text(
                      widget.cartCount > 99 ? '99+' : '${widget.cartCount}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 构建操作按钮（加入购物车、立即购买）
  Widget _buildActionButton({
    required String text,
    required double width,
    required double height,
    required Color backgroundColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
