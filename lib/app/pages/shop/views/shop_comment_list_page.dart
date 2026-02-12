import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test_demo/app/constants/app_constants.dart';
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
            SizedBox(height: 6.h),
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
      width: double.infinity,
      height: 44.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 6.w,
            child: SizedBox(
              width: 44.w,
              height: 44.h,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => NavigatorService.instance.pop(),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Image.asset(
                      'assets/images/icon_back.webp',
                      width: 11.w,
                      height: 18.h,
                    ),
                  ),
                ),
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
    final imageUrls = _normalizeImageUrls(item.pics);
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
                  imageUrl: _resolveImageUrl(item.avatar ?? ''),
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
          if (imageUrls.isNotEmpty) ...[
            SizedBox(height: 10.h),
            SizedBox(
              height: 72.w,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  final url = imageUrls[index];
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
                        placeholder: (_, __) => Container(
                          width: 72.w,
                          height: 72.w,
                          color: const Color(0xFFF0F0F0),
                        ),
                        errorWidget: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemCount: imageUrls.length,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<String> _normalizeImageUrls(List<String?>? pics) {
    if (pics == null || pics.isEmpty) {
      return const <String>[];
    }
    return pics
        .whereType<String>()
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map(_resolveImageUrl)
        .toList();
  }

  String _resolveImageUrl(String url) {
    final value = url.trim();
    if (value.isEmpty) {
      return '';
    }
    final uri = Uri.tryParse(value);
    if (uri != null && uri.hasScheme) {
      return value;
    }
    final baseUri = Uri.parse(AppConstants.baseUrl);
    return baseUri.resolve(value).toString();
  }
}
