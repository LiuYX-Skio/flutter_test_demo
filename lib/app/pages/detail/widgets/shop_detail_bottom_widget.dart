import 'package:flutter/material.dart';

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
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFCCCCCC),
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            // 首页按钮
            _buildIconButton(
              icon: 'assets/images/icon_shop_home.webp',
              label: '首页',
              onTap: widget.onHomeTap,
            ),
            const SizedBox(width: 18),

            // 客服按钮
            _buildIconButton(
              icon: 'assets/images/icon_shop_service.webp',
              label: '客服',
              onTap: widget.onServiceTap,
            ),
            const SizedBox(width: 18),

            // 收藏按钮
            _buildIconButton(
              icon: widget.isCollected
                  ? 'assets/images/icon_shop_collect.webp'
                  : 'assets/images/icon_shop_uncollect.webp',
              label: '收藏',
              onTap: widget.onCollectTap,
            ),
            const SizedBox(width: 18),

            // 购物车按钮（带角标）
            _buildCartButton(),

            const Spacer(),

            // 加入购物车按钮
            _buildActionButton(
              text: '加入购物车',
              width: 95,
              height: 40,
              backgroundColor: const Color(0xFFFF6B00),
              onTap: widget.onAddToCartTap,
            ),

            const SizedBox(width: 8),

            // 立即购买按钮
            _buildActionButton(
              text: '立即购买',
              width: 95,
              height: 40,
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
            width: 20,
            height: 20,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 20,
                height: 20,
                color: Colors.grey[300],
              );
            },
          ),
          const SizedBox(height: 6.5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
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
        width: 40,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/icon_shop_car.webp',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 20,
                      height: 20,
                      color: Colors.grey[300],
                    );
                  },
                ),
                const SizedBox(height: 6.5),
                const Text(
                  '购物车',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF615F69),
                  ),
                ),
              ],
            ),
            // 购物车数量角标
            if (widget.cartCount > 0)
              Positioned(
                top: -2,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text(
                      widget.cartCount > 99 ? '99+' : '${widget.cartCount}',
                      style: const TextStyle(
                        fontSize: 10,
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
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
