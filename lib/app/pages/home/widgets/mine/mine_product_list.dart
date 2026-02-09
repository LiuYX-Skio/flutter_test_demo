import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/product_models.dart';
import '../home/product_list_widget.dart';

/// 我的页面推荐商品列表组件
class MineProductList extends StatelessWidget {
  final List<ProductEntity> products;
  final Function(ProductEntity)? onTap;

  const MineProductList({
    super.key,
    required this.products,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Text(
            '为你推荐',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ProductListWidget(
          products: products,
          onTap: onTap,
        ),
      ],
    );
  }
}
