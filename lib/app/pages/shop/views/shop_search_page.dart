import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../viewmodels/shop_search_viewmodel.dart';
import '../widgets/shop_goods_list_item_widget.dart';

class ShopSearchPage extends StatefulWidget {
  const ShopSearchPage({super.key});

  @override
  State<ShopSearchPage> createState() => _ShopSearchPageState();
}

class _ShopSearchPageState extends State<ShopSearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              child: Consumer<ShopSearchViewModel>(
                builder: (_, vm, __) {
                  if (vm.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: vm.results.length,
                    itemBuilder: (_, index) {
                      final item = vm.results[index];
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
            child: Container(
              height: 34.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17.r),
                border: Border.all(color: const Color(0xFFEDEDED)),
              ),
              padding: EdgeInsets.only(left: 12.w, right: 10.w),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/icon_shop_search.webp',
                    width: 14.w,
                    height: 14.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        hintText: '输入商品名称',
                      ),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF333333),
                      ),
                      onSubmitted: (_) => _search(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: _search,
            child: Text(
              '搜索',
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFFFF0141),
              ),
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }

  void _search() {
    context.read<ShopSearchViewModel>().search(_controller.text);
  }
}

