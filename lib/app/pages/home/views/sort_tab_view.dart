import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_test_demo/app/widgets/empty_widget.dart';
import 'package:flutter_test_demo/app/widgets/error_widget.dart';
import 'package:flutter_test_demo/app/widgets/loading_widget.dart';
import 'package:flutter_test_demo/app/widgets/refresh_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../viewmodels/sort_viewmodel.dart';
import '../models/product_models.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';

/// 排行榜Tab视图
class SortTabView extends StatefulWidget {
  const SortTabView({super.key});

  @override
  State<SortTabView> createState() => _SortTabViewState();
}

class _SortTabViewState extends State<SortTabView>
    with AutomaticKeepAliveClientMixin {
  late RefreshController _refreshController;
  late SortViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);

    // 延迟初始化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<SortViewModel>(context, listen: false);
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
      backgroundColor: const Color(0xFFF0F0F0),
      body: Consumer<SortViewModel>(
        builder: (context, viewModel, child) {
          // 首次加载
          if (viewModel.isLoading && viewModel.sortList.isEmpty) {
            return const LoadingWidget(message: '加载中...');
          }
          // 加载失败
          if (viewModel.errorMessage != null && viewModel.sortList.isEmpty) {
            return ErrorStateWidget(
              message: viewModel.errorMessage,
              onRetry: () => viewModel.refresh(),
            );
          }
          // 空状态
          if (viewModel.sortList.isEmpty) {
            return const EmptyWidget(message: '暂无排行榜数据');
          }

          return Container(
            color: const Color(0xFFF0F0F0),
            child: RefreshListWidget(
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              enablePullUp: viewModel.hasMore,
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 16.h),
                itemCount: viewModel.sortList.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (_, index) {
                  final product = viewModel.sortList[index];
                  if (index == 0) {
                    return _buildTopWithFirstItem(product);
                  }
                  return _buildSortItem(product, index);
                },
              ),
            ),
          );
        },
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

  Widget _buildTopHeader() {
    return SizedBox(
      height: 208.h,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              width: double.infinity,
              'assets/images/home_sort_title.webp',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: 23.w,
            top: 76.h,
            child: Text(
              '排行榜',
              style: TextStyle(
                fontSize: 38.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopWithFirstItem(ProductEntity product) {
    return SizedBox(
      height: 307.h,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: _buildTopHeader(),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 172.h,
            child: _buildSortItem(product, 0),
          ),
        ],
      ),
    );
  }

  Widget _buildSortItem(ProductEntity product, int index) {
    final rankAsset = _getRankAsset(index);
    final productId = product.id;
    return GestureDetector(
      onTap: productId == null
          ? null
          : () {
              NavigatorService.instance.push(
                RoutePaths.product.detail,
                arguments: {'id': productId},
              );
            },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.only(
          left: 10.w,
          right: 12.w,
          top: 10.h,
          bottom: 10.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 115.w,
              height: 115.w,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.r),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl ?? '',
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: const Color(0xFFCCCCCC),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: const Color(0xFFCCCCCC),
                        ),
                      ),
                    ),
                  ),
                  if (rankAsset != null)
                    Positioned(
                      left: 5.w,
                      top: 0,
                      child: Image.asset(
                        rankAsset,
                        width: 21.w,
                        height: 28.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SizedBox(
                height: 115.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 7.h),
                      child: Text(
                        product.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          product.description ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF888888),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '￥',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xFFFF3530),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _formatPrice(product.price),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: const Color(0xFFFF3530),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 48.w,
                            padding: EdgeInsets.only(top: 4.h, bottom: 6.h),
                            decoration: BoxDecoration(
                              color: const Color(0x19E31010),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '加入',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFFFF3530),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _getRankAsset(int index) {
    switch (index) {
      case 0:
        return 'assets/images/sort_one.webp';
      case 1:
        return 'assets/images/sort_two.webp';
      case 2:
        return 'assets/images/sort_three.webp';
      case 3:
        return 'assets/images/sort_four.webp';
      default:
        return null;
    }
  }

  String _formatPrice(double? price) {
    if (price == null) {
      return '0.00';
    }
    return price.toStringAsFixed(2);
  }
}
