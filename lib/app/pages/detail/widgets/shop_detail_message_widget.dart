import 'package:flutter/material.dart';
import '../models/shop_detail_models.dart';
import '../../home/models/address_models.dart';

/// 商品详情信息Widget
/// 对应 Android 的 ShopDetailMessageView
class ShopDetailMessageWidget extends StatelessWidget {
  /// 商品详情数据
  final ShopDetailEntity? shopDetail;

  /// 默认地址
  final AddressEntity? defaultAddress;

  /// 地址点击回调
  final VoidCallback? onAddressTap;

  /// SKU选择回调
  final Function(ProduceValueEntity?)? onSkuSelected;

  const ShopDetailMessageWidget({
    Key? key,
    this.shopDetail,
    this.defaultAddress,
    this.onAddressTap,
    this.onSkuSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(13, 16, 13, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 价格区域
          _buildPriceSection(),
          const SizedBox(height: 12),

          // 商品标题
          _buildTitleSection(),
          const SizedBox(height: 20),

          // 地址区域
          if (defaultAddress != null) _buildAddressSection(),
        ],
      ),
    );
  }

  /// 构建价格区域
  Widget _buildPriceSection() {
    final price = shopDetail?.productInfo?.price ?? 0.0;
    final priceStr = price.toStringAsFixed(2);
    final parts = priceStr.split('.');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        const Text(
          '¥',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFE65050),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          parts[0],
          style: const TextStyle(
            fontSize: 28,
            color: Color(0xFFE65050),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '.${parts[1]}',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFFE65050),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// 构建标题区域
  Widget _buildTitleSection() {
    return Text(
      shopDetail?.productInfo?.storeName ?? '',
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF1A1A1A),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// 构建地址区域
  Widget _buildAddressSection() {
    final address = _formatAddress();

    return GestureDetector(
      onTap: onAddressTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/icon_auth_location.png',
              width: 16,
              height: 16,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.location_on,
                  size: 16,
                  color: Color(0xFF999999),
                );
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                address,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF333333),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }

  /// 格式化地址
  String _formatAddress() {
    if (defaultAddress == null) return '请选择收货地址';

    final buffer = StringBuffer();
    if (defaultAddress!.province != null) {
      buffer.write(defaultAddress!.province);
    }
    if (defaultAddress!.city != null) {
      buffer.write(defaultAddress!.city);
    }
    if (defaultAddress!.district != null) {
      buffer.write(defaultAddress!.district);
    }
    if (defaultAddress!.detail != null) {
      buffer.write(defaultAddress!.detail);
    }

    return buffer.toString();
  }
}
