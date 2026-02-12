import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_test_demo/app/widgets/error_widget.dart';
import 'package:flutter_test_demo/app/widgets/loading_widget.dart';
import 'package:flutter_test_demo/app/widgets/refresh_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/product_models.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/home/banner_widget.dart';
import '../widgets/home/menu_grid_widget.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';

/// 首页Tab视图
class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView>
    with AutomaticKeepAliveClientMixin {
  late RefreshController _refreshController;
  late HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);

    // 延迟初始化，确保Provider已经准备好
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<HomeViewModel>(context, listen: false);
      _viewModel.refresh();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // color_F7F9FC
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {

          return RefreshListWidget(
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: CustomScrollView(
              slivers: [
                // 自定义顶部（包含搜索框、Banner、分类菜单）
                SliverToBoxAdapter(
                  child: _buildHomeHeader(viewModel),
                ),

                // 商品网格列表
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.h,
                      crossAxisSpacing: 8.w,
                      mainAxisExtent: 270.h, // item 固定高度
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < viewModel.productList.length) {
                          final product = viewModel.productList[index];
                          return _buildProductItem(product);
                        }
                        return null;
                      },
                      childCount: viewModel.productList.length,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(height: 16.h),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 构建首页头部（包含搜索框、Banner、分类菜单）
  Widget _buildHomeHeader(HomeViewModel viewModel) {
    final hasBanner = viewModel.homeData?.banner != null &&
        viewModel.homeData!.banner!.isNotEmpty;
    final hasMenu = viewModel.homeData?.menuCategoryList != null &&
        viewModel.homeData!.menuCategoryList!.isNotEmpty;
    final hasHeaderData = viewModel.homeData != null && (hasBanner || hasMenu);

    return Container(
      decoration: hasHeaderData
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6.r),
                bottomRight: Radius.circular(6.r),
              ),
            )
          : null,
      child: Stack(
        children: [
          // 顶部渐变背景 (203dp高度)
          Container(
            height: 203.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFF4843), Color(0xFFFF3530)],
              ),
            ),
          ),

          Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 12.w, top: 46.h, right: 12.w),
                child: Row(
                  children: [
                    // 搜索框
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          NavigatorService.instance.push(RoutePaths.product.search);
                        },
                        child: Container(
                          height: 34.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17.r),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 12.w),
                              Image.asset(
                                'assets/images/home_search.png',
                                width: 16.w,
                                height: 16.w,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '搜索商品',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF999999),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // 消息图标
                    Image.asset(
                      'assets/images/home_message.png',
                      width: 22.w,
                      height: 22.w,
                    ),
                  ],
                ),
              ),

              // Banner (marginTop: 16dp, height: 140dp)
              if (hasBanner)
                Container(
                  margin: EdgeInsets.only(left: 12.w, top: 16.h, right: 12.w),
                  height: 140.h,
                  child: BannerWidget(
                    banners: viewModel.homeData!.banner!,
                    onTap: (banner) {
                      print('点击轮播图: ${banner.title}');
                    },
                  ),
                ),

              if (hasMenu)
                Container(
                  margin: EdgeInsets.only(top: 20.h),
                  child: MenuGridWidget(
                    menus: viewModel.homeData!.menuCategoryList!,
                    onTap: (menu) {
                      final sortId = menu.id.toString();
                      if (sortId.isEmpty) {
                        return;
                      }
                      NavigatorService.instance.push(
                        RoutePaths.product.sort,
                        arguments: {'sortId': sortId},
                      );
                    },
                  ),
                ),

              if (hasHeaderData)
                Container(
                  height: 11.h,
                  color: const Color(0xFFF7F9FC),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建商品项
  Widget _buildProductItem(ProductEntity product) {
    return GestureDetector(
      onTap: () {
        // 导航到商品详情页
        context.push(
          RoutePaths.product.detail,
          arguments: {'id': product.id},
        );
      },
      child: Container(
        width: 171.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品图片 (170dp高度)
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
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Text(
                product.name ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF333333),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // 价格和购物车
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 9.h),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '¥',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFFFF3530),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product.price?.toString() ?? '0',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFFFF3530),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/icon_shop_car.webp',
                    width: 24.w,
                    height: 24.w,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRefresh() async {
    await _viewModel.refresh();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await _viewModel.loadMore();
    if (_viewModel.hasMore) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }
}
