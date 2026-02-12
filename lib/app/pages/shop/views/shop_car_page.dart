import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../../home/models/product_models.dart';
import '../../../widgets/shop_recommend_view.dart';
import '../../mine/models/address_models.dart';
import '../api/shop_detail_api.dart';
import '../models/shop_models.dart';
import '../viewmodels/shop_car_viewmodel.dart';

class ShopCarPage extends StatefulWidget {
  const ShopCarPage({super.key});

  @override
  State<ShopCarPage> createState() => _ShopCarPageState();
}

class _ShopCarPageState extends State<ShopCarPage> {
  UserAddressEntity? _address;
  List<ProductEntity> _recommendList = <ProductEntity>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopCarViewModel>().loadCart();
      _loadAddress();
      _loadRecommend();
    });
  }

  Future<void> _loadAddress() async {
    await ShopDetailApi.getDefaultAddress(
      onSuccess: (data) {
        if (!mounted) return;
        setState(() {
          _address = data;
        });
      },
    );
  }

  Future<void> _loadRecommend() async {
    await ShopDetailApi.getRecommendList(
      onSuccess: (data) {
        if (!mounted) return;
        setState(() {
          _recommendList = (data?.list ?? const <ProductEntity?>[]).whereType<ProductEntity>().toList();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Consumer<ShopCarViewModel>(
                builder: (_, vm, __) {
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 62.h),
                        child: Column(
                          children: [
                            Container(
                              color: const Color(0xFFF7F9FC),
                              padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                              child: Column(
                                children: [
                                  ...List.generate(vm.cartList.length, (index) {
                                    final item = vm.cartList[index];
                                    return _buildCartItem(vm, item, index);
                                  }),
                                ],
                              ),
                            ),
                            if (_recommendList.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(top: 20.h),
                                child: ShopRecommendView(
                                  products: _recommendList,
                                  onItemTap: (_) => NavigatorService.instance.pop(),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildBottom(vm),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SizedBox(
      height: 54.h,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => NavigatorService.instance.pop(),
            child: Container(
              height: 54.h,
              padding: EdgeInsets.only(left: 11.w),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/icon_back.webp',
                    width: 11.w,
                    height: 18.h,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    '购物车',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Image.asset(
            'assets/images/icon_position.png',
            width: 12.w,
            height: 13.h,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: GestureDetector(
              onTap: _selectAddress,
              child: Text(
                _address?.fullAddress.isNotEmpty == true ? _address!.fullAddress : '请添加收货地址',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF999999),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _selectAddress,
            child: Text(
              '管理',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }

  Widget _buildCartItem(ShopCarViewModel vm, ShopCarEntity item, int index) {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.h),
      padding: EdgeInsets.fromLTRB(9.5.w, 16.h, 12.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              final ok = vm.toggleItemSelect(index);
              if (!ok) {
                LoadingManager.instance.showToast('只能选择同类型的可回收商品');
              }
            },
            child: Image.asset(
              item.isSelect ? 'assets/images/ic_select.png' : 'assets/images/ic_un_select.png',
              width: 17.w,
              height: 17.w,
            ),
          ),
          SizedBox(width: 9.5.w),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: CachedNetworkImage(
              imageUrl: item.image ?? '',
              width: 94.w,
              height: 94.w,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 94.w,
                height: 94.w,
                color: const Color(0xFFCCCCCC),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 94.w,
                height: 94.w,
                color: const Color(0xFFCCCCCC),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: SizedBox(
              height: 94.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 25.w),
                    child: Text(
                      item.storeName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF1A1A1A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.suk ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF9B9C9E),
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
                                fontSize: 11.sp,
                                color: const Color(0xFFFF3530),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _priceInt(item.price),
                              style: TextStyle(
                                fontSize: 17.sp,
                                color: const Color(0xFFFF3530),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _priceDecimal(item.price),
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFFFF3530),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildCountButton('-', () => vm.decrease(index)),
                      SizedBox(width: 1.w),
                      Container(
                        width: 25.w,
                        height: 25.w,
                        color: const Color(0xFFF0F1F2),
                        alignment: Alignment.center,
                        child: Text(
                          '${item.cartNum}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      SizedBox(width: 1.w),
                      _buildCountButton('+', () => vm.increase(index)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountButton(String text, VoidCallback onTap) {
    final bool isAdd = text == '+';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25.w,
        height: 25.w,
        alignment: Alignment.center,
        color: isAdd ? const Color(0xFFEDF0F2) : const Color(0xFFF0F1F2),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.sp,
            color: isAdd ? const Color(0xFF313234) : const Color(0xFF9B9C9E),
          ),
        ),
      ),
    );
  }

  Widget _buildBottom(ShopCarViewModel vm) {
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
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              final ok = vm.toggleSelectAll(!vm.isSelectAll);
              if (!ok) {
                LoadingManager.instance.showToast('只能选择同类型的可回收商品');
              }
            },
            child: Image.asset(
              vm.isSelectAll ? 'assets/images/ic_select.png' : 'assets/images/ic_un_select.png',
              width: 17.w,
              height: 17.w,
            ),
          ),
          SizedBox(width: 5.5.w),
          Text(
            '全选',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF999999),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '合计',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      '￥${vm.selectedTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 19.sp,
                        color: const Color(0xFFFF3530),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '明细',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFFFF3530),
                      ),
                    ),
                    SizedBox(width: 6.5.w),
                    Image.asset(
                      'assets/images/icon_up_arrow.webp',
                      width: 8.5.w,
                      height: 5.5.h,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () => _buyNow(vm),
            child: Container(
              width: 125.w,
              height: 40.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFF3530),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '立即购买',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectAddress() async {
    final result = await NavigatorService.instance.push<UserAddressEntity>(
      RoutePaths.user.addressList,
      arguments: {'isUpdateAddress': true, 'orderId': ''},
    );
    if (result.success && result.data != null && mounted) {
      setState(() {
        _address = result.data;
      });
    }
  }

  void _buyNow(ShopCarViewModel vm) {
    if (!vm.hasSelected) {
      LoadingManager.instance.showToast('请选择要购买的商品');
      return;
    }
    final items = vm.buildConfigOrderItems();
    NavigatorService.instance.push(
      RoutePaths.other.configOrder,
      arguments: {
        'items': items,
        'addressId': _address?.id,
        'preOrderType': 'shoppingCart',
      },
    );
  }

  String _priceInt(String? price) {
    final value = double.tryParse(price ?? '0') ?? 0;
    return value.toStringAsFixed(2).split('.').first;
  }

  String _priceDecimal(String? price) {
    final value = double.tryParse(price ?? '0') ?? 0;
    return '.${value.toStringAsFixed(2).split('.').last}';
  }
}
