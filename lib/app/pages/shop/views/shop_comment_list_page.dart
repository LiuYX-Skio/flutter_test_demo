import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../models/shop_detail_models.dart';
import '../viewmodels/shop_comment_viewmodel.dart';

class ShopCommentListPage extends StatefulWidget {
  final int productId;

  const ShopCommentListPage({super.key, required this.productId});

  @override
  State<ShopCommentListPage> createState() => _ShopCommentListPageState();
}

class _ShopCommentListPageState extends State<ShopCommentListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopCommentViewModel>().loadFirstPage(widget.productId);
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 80.h) {
      context.read<ShopCommentViewModel>().loadMore(widget.productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Consumer<ShopCommentViewModel>(
                builder: (_, vm, __) {
                  if (vm.isLoading && vm.list.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.separated(
                    controller: _scrollController,
                    itemCount: vm.list.length + (vm.isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (_, index) {
                      if (index >= vm.list.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      return _buildItem(vm.list[index]);
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
      height: 44.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 11.w,
            child: GestureDetector(
              onTap: () => NavigatorService.instance.pop(),
              child: Image.asset(
                'assets/images/icon_back.webp',
                width: 11.w,
                height: 18.h,
              ),
            ),
          ),
          Text(
            '商品评论列表',
            style: TextStyle(
              fontSize: 18.sp,
              color: const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(ShopCommentEntity item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedNetworkImage(
                  imageUrl: item.avatar ?? '',
                  width: 32.w,
                  height: 32.w,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 32.w,
                    height: 32.w,
                    color: const Color(0xFFCCCCCC),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 32.w,
                    height: 32.w,
                    color: const Color(0xFFCCCCCC),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  item.nickname ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            item.comment ?? '',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF333333),
              height: 1.4,
            ),
          ),
          if ((item.pics ?? const <String?>[]).isNotEmpty) ...[
            SizedBox(height: 10.h),
            SizedBox(
              height: 72.w,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  final url = item.pics![index];
                  return GestureDetector(
                    onTap: () {
                      NavigatorService.instance.push(
                        RoutePaths.product.bigPhoto,
                        arguments: {'photo': url, 'position': index.toString()},
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        width: 72.w,
                        height: 72.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemCount: item.pics!.length,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
