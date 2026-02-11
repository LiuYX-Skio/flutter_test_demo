import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../viewmodels/shop_sort_viewmodel.dart';
import '../widgets/shop_goods_list_item_widget.dart';

class ShopSortPage extends StatefulWidget {
  final String? sortId;

  const ShopSortPage({super.key, this.sortId});

  @override
  State<ShopSortPage> createState() => _ShopSortPageState();
}

class _ShopSortPageState extends State<ShopSortPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopSortViewModel>().loadCategories(
            initialCategoryId: widget.sortId,
          );
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final vm = context.read<ShopSortViewModel>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100.h) {
      vm.loadProducts(loadMore: true);
    }
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
              child: Consumer<ShopSortViewModel>(
                builder: (_, vm, __) {
                  return Row(
                    children: [
                      _buildCategoryList(vm),
                      Expanded(
                        child: vm.isLoading && vm.products.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount:
                                    vm.products.length + (vm.isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index >= vm.products.length) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16.h),
                                      child: const Center(
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    );
                                  }
                                  final item = vm.products[index];
                                  return ShopGoodsListItemWidget(
                                    item: item,
                                    onTap: () {
                                      NavigatorService.instance.push(
                                        RoutePaths.product.detail,
                                        arguments: {'id': item.id},
                                      );
                                    },
                                  );
                                },
                              ),
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
          SizedBox(width: 11.w),
          GestureDetector(
            onTap: () => NavigatorService.instance.pop(),
            child: Image.asset(
              'assets/images/icon_search_back.webp',
              width: 11.w,
              height: 18.h,
            ),
          ),
          SizedBox(width: 25.w),
          Expanded(
            child: GestureDetector(
              onTap: () => NavigatorService.instance.push(RoutePaths.product.search),
              child: Container(
                height: 34.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17.r),
                  border: Border.all(color: const Color(0xFFEDEDED)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/icon_shop_search.webp',
                      width: 14.w,
                      height: 14.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '输入商品名称',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFFB6B7BB),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 15.w),
          GestureDetector(
            onTap: () => NavigatorService.instance.push(RoutePaths.product.cart),
            child: Image.asset(
              'assets/images/icon_shop_car.webp',
              width: 20.w,
              height: 20.w,
            ),
          ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }

  Widget _buildCategoryList(ShopSortViewModel vm) {
    return Container(
      width: 87.w,
      color: const Color(0xFFF9F8F6),
      child: ListView.builder(
        itemCount: vm.categories.length,
        itemBuilder: (_, index) {
          final item = vm.categories[index];
          final selected = item.isSelect;
          return GestureDetector(
            onTap: () => vm.selectCategory(item.id?.toString()),
            child: Container(
              height: 52.h,
              color: selected ? Colors.white : const Color(0xFFF9F8F6),
              child: Row(
                children: [
                  Visibility(
                    visible: selected,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    child: Container(
                      width: 4.w,
                      height: 25.h,
                      color: const Color(0xFFFF3530),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.name ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
