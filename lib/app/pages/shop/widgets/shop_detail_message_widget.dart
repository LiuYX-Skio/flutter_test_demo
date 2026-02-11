import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/shop_detail_models.dart';
import '../../mine/models/address_models.dart';

/// 商品详情信息Widget
/// 对应 Android 的 ShopDetailMessageView
class ShopDetailMessageWidget extends StatefulWidget {
  /// 商品详情数据
  final ShopDetailEntity? shopDetail;

  /// 默认地址
  final UserAddressEntity? defaultAddress;

  /// 地址点击回调
  final VoidCallback? onAddressTap;

  /// SKU选择回调
  final Function(ProduceValueEntity?)? onSkuSelected;

  const ShopDetailMessageWidget({
    super.key,
    this.shopDetail,
    this.defaultAddress,
    this.onAddressTap,
    this.onSkuSelected,
  });

  @override
  State<ShopDetailMessageWidget> createState() => _ShopDetailMessageWidgetState();
}

class _ShopDetailMessageWidgetState extends State<ShopDetailMessageWidget> {
  double? _selectedPrice;
  List<int> _selectedIndex = [];
  List<String> _selectedAttrValues = [];

  @override
  void initState() {
    super.initState();
    _resetSelections(notifyCallback: true, setStateNow: false);
  }

  @override
  void didUpdateWidget(covariant ShopDetailMessageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shopDetail != widget.shopDetail) {
      _resetSelections(notifyCallback: true, setStateNow: true);
    }
  }

  void _resetSelections({required bool notifyCallback, required bool setStateNow}) {
    final attrs = widget.shopDetail?.productAttr ?? [];
    final newSelectedIndex = <int>[];
    final newSelectedValues = <String>[];

    for (final attr in attrs) {
      final items = attr.attrDetailList ?? [];
      if (items.isNotEmpty) {
        newSelectedIndex.add(0);
        newSelectedValues.add(items.first.attrValue ?? '');
      } else {
        newSelectedIndex.add(-1);
        newSelectedValues.add('');
      }
    }

    final matched = _findMatchedSku(newSelectedValues);
    if (setStateNow && mounted) {
      setState(() {
        _selectedIndex = newSelectedIndex;
        _selectedAttrValues = newSelectedValues;
        _selectedPrice = matched?.price;
      });
    } else {
      _selectedIndex = newSelectedIndex;
      _selectedAttrValues = newSelectedValues;
      _selectedPrice = matched?.price;
    }

    if (notifyCallback && matched != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.onSkuSelected?.call(matched);
      });
    }
  }

  ProduceValueEntity? _findMatchedSku(List<String> selectedValues) {
    final values = widget.shopDetail?.productValueList ?? [];
    if (values.isEmpty || selectedValues.isEmpty) return null;

    for (final item in values) {
      final sku = item.sku ?? '';
      bool match = true;
      for (final value in selectedValues) {
        if (value.isEmpty) continue;
        if (!sku.contains(value)) {
          match = false;
          break;
        }
      }
      if (match) return item;
    }
    return null;
  }

  void _handleSelect(int groupIndex, int itemIndex, String? attrValue) {
    if (groupIndex < 0 || groupIndex >= _selectedIndex.length) return;
    final newSelectedIndex = List<int>.from(_selectedIndex);
    final newSelectedValues = List<String>.from(_selectedAttrValues);
    newSelectedIndex[groupIndex] = itemIndex;
    newSelectedValues[groupIndex] = attrValue ?? '';

    final matched = _findMatchedSku(newSelectedValues);
    setState(() {
      _selectedIndex = newSelectedIndex;
      _selectedAttrValues = newSelectedValues;
      if (matched != null) {
        _selectedPrice = matched.price;
      }
    });

    if (matched != null) {
      widget.onSkuSelected?.call(matched);
    }
  }

  void _showImagePreview(String imageUrl) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => SizedBox(
                width: 40.w,
                height: 40.h,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.broken_image,
                color: Colors.white,
                size: 40.w,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(13.w, 16.h, 13.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 价格区域
          _buildPriceSection(),
          SizedBox(height: 12.h),

          // 商品标题
          _buildTitleSection(),

          // SKU规格列表
          _buildSkuSection(),

          SizedBox(height: 20.h),

          // 地址区域
          if (widget.defaultAddress != null) _buildAddressSection(),
        ],
      ),
    );
  }

  /// 构建价格区域
  Widget _buildPriceSection() {
    final price = _selectedPrice ?? widget.shopDetail?.productInfo?.price ?? 0.0;
    final priceStr = price.toStringAsFixed(2);
    final parts = priceStr.split('.');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '¥',
          style: TextStyle(
            fontSize: 16.sp,
            color: Color(0xFFE65050),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          parts[0],
          style: TextStyle(
            fontSize: 28.sp,
            color: Color(0xFFE65050),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '.${parts[1]}',
          style: TextStyle(
            fontSize: 16.sp,
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
      widget.shopDetail?.productInfo?.storeName ?? '',
      style: TextStyle(
        fontSize: 15.sp,
        color: Color(0xFF1A1A1A),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// 构建SKU规格区域
  Widget _buildSkuSection() {
    final attrs = widget.shopDetail?.productAttr ?? [];
    final showSku = widget.shopDetail?.productInfo?.specType ?? false;
    if (!showSku || attrs.isEmpty) {
      return const SizedBox.shrink();
    }

    final groups = <Widget>[];
    for (int i = 0; i < attrs.length; i++) {
      final attr = attrs[i];
      final items = attr.attrDetailList ?? [];
      if (items.isEmpty) continue;

      groups.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 46.w),
              child: Text(
                '${attr.attrName ?? ''} :',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected =
                      _selectedIndex.length > i && _selectedIndex[i] == index;
                  final text = item.attrValue ?? '';
                  final imageUrl = item.image ?? '';

                  final textWidget = text.isEmpty
                      ? const SizedBox.shrink()
                      : Container(
                          height: 35.h,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFE65050)
                                  : const Color(0xFFCCCCCC),
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xFF333333),
                            ),
                          ),
                        );

                  final imageWidget = imageUrl.isEmpty
                      ? const SizedBox.shrink()
                      : GestureDetector(
                          onTap: () {
                            _handleSelect(i, index, item.attrValue);
                            _showImagePreview(imageUrl);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3.r),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: 35.w,
                              height: 35.h,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 35.w,
                                height: 35.h,
                                color: const Color(0xFFF0F0F0),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 35.w,
                                height: 35.h,
                                color: const Color(0xFFF0F0F0),
                                child: Icon(
                                  Icons.image,
                                  size: 20.w,
                                  color: Color(0xFFCCCCCC),
                                ),
                              ),
                            ),
                          ),
                        );

                  return GestureDetector(
                    onTap: () => _handleSelect(i, index, item.attrValue),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 300.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (imageUrl.isNotEmpty) imageWidget,
                          if (imageUrl.isNotEmpty) SizedBox(width: 8.w),
                          if (text.isNotEmpty) textWidget,
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );

      if (i != attrs.length - 1) {
        groups.add(SizedBox(height: 10.h));
      }
    }

    if (groups.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        ...groups,
      ],
    );
  }

  /// 构建地址区域
  Widget _buildAddressSection() {
    final address = _formatAddress();

    return GestureDetector(
      onTap: widget.onAddressTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/icon_auth_location.png',
              width: 16.w,
              height: 16.h,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.location_on,
                  size: 16.w,
                  color: Color(0xFF999999),
                );
              },
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                address,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Color(0xFF333333),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.w,
              color: Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }

  /// 格式化地址
  String _formatAddress() {
    if (widget.defaultAddress == null) return '请选择收货地址';

    final buffer = StringBuffer();
    if (widget.defaultAddress!.province != null) {
      buffer.write(widget.defaultAddress!.province);
    }
    if (widget.defaultAddress!.city != null) {
      buffer.write(widget.defaultAddress!.city);
    }
    if (widget.defaultAddress!.district != null) {
      buffer.write(widget.defaultAddress!.district);
    }
    if (widget.defaultAddress!.detail != null) {
      buffer.write(widget.defaultAddress!.detail);
    }

    return buffer.toString();
  }
}
