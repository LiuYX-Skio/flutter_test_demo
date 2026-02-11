import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_demo/app/dialog/loading_manager.dart';
import 'package:flutter_test_demo/navigation/core/navigator_service.dart';
import 'package:flutter_test_demo/navigation/core/route_paths.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';

import '../home/widgets/mine/shop_recommend_view.dart';
import '../order/models/order_models.dart';
import '../mine/models/address_models.dart';
import 'viewmodels/shop_detail_viewmodel.dart';
import 'widgets/shop_detail_bottom_widget.dart';
import 'widgets/shop_detail_message_widget.dart';
import 'widgets/shop_detail_comment_widget.dart';

/// 商品详情页面
/// 对应 Android 的 ShopDetailActivity
class ShopDetailPage extends StatefulWidget {
  /// 商品ID
  final int productId;

  const ShopDetailPage({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  late ShopDetailViewModel _viewModel;
  int _currentBannerIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = ShopDetailViewModel();
    _loadData();
  }

  /// 加载数据
  Future<void> _loadData() async {
    try {
      LoadingManager.instance.show();
      await _viewModel.fetchShopDetail(widget.productId);
      await Future.wait([
        _viewModel.fetchCommentList(widget.productId),
        _viewModel.fetchDefaultAddress(),
        _viewModel.fetchRecommendList(),
      ]);
    } catch (e) {
      debugPrint("加载数据失败: $e");
    } finally {
      // 确保加载弹窗关闭
      LoadingManager.instance.dismiss();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        body: Consumer<ShopDetailViewModel>(
          builder: (context, viewModel, child) {
            return Stack(
              children: [
                // 主内容区域
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Banner轮播图
                    _buildBannerSection(viewModel),

                    // 商品信息
                    SliverToBoxAdapter(
                      child: ShopDetailMessageWidget(
                        shopDetail: viewModel.shopDetail,
                        defaultAddress: viewModel.defaultAddress,
                        onAddressTap: () {
                          _handleSelectAddress(viewModel);
                        },
                        onSkuSelected: (sku) {
                          if (sku != null) {
                            viewModel.updateSelectedAttr(
                              sku.id?.toString() ?? '',
                              sku.sku,
                            );
                          }
                        },
                      ),
                    ),

                    // 不支持退货提示
                    if (viewModel.shopDetail?.productInfo?.hasCallback == false)
                      SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.only(left: 13, top: 20),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE5E5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '该商品不支持退货',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFE65050),
                            ),
                          ),
                        ),
                      ),

                    // 商品详情标题
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.only(left: 13, top: 18),
                        child: const Text(
                          '商品详情',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    // 商品详情富文本
                    _buildRichTextSection(viewModel),

                    // 分隔线
                    if (viewModel.commentList != null &&
                        viewModel.commentList!.list != null &&
                        viewModel.commentList!.list!.isNotEmpty)
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 8),
                      ),

                    // 评论区域
                    SliverToBoxAdapter(
                      child: ShopDetailCommentWidget(
                        commentData: viewModel.commentList,
                        onViewAllTap: () {
                          _handleViewAllComments();
                        },
                      ),
                    ),

                    // 推荐商品
                    _buildRecommendSection(viewModel),

                    // 底部占位
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 65),
                    ),
                  ],
                ),

                // 返回按钮
                _buildBackButton(),

                // Banner位置指示器
                _buildBannerIndicator(viewModel),

                // 底部操作栏
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ShopDetailBottomWidget(
                    isCollected: viewModel.shopDetail?.userCollect ?? false,
                    cartCount: viewModel.cartCount,
                    productId: viewModel.shopDetail?.productInfo?.id?.toString(),
                    onCollectTap: () => _handleCollect(viewModel),
                    onAddToCartTap: () => _handleAddToCart(viewModel),
                    onBuyNowTap: () => _handleBuyNow(viewModel),
                    onHomeTap: () => Navigator.of(context).pop(),
                    onServiceTap: () {
                      // 原生为客服入口；此处保持占位（具体跳转依赖业务接入）
                    },
                    onCartTap: () {
                      NavigatorService.instance.push(RoutePaths.product.cart);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 构建Banner轮播图
  Widget _buildBannerSection(ShopDetailViewModel viewModel) {
    final images = viewModel.shopDetail?.productInfo?.sliderImageList ?? [];

    if (images.isEmpty) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 362,
          child: Center(child: Text('暂无图片')),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 362,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 362,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
          ),
          items: images.map((imageUrl) {
            return CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 50, color: Colors.white),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 构建富文本详情区域
  Widget _buildRichTextSection(ShopDetailViewModel viewModel) {
    final content = viewModel.shopDetail?.productInfo?.content;

    if (content == null || content.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 16),
        color: Colors.white,
        child: _buildHtmlContent(content),
      ),
    );
  }

  /// 构建HTML内容显示
  Widget _buildHtmlContent(String htmlContent) {
    if (htmlContent.isEmpty) {
      return const SizedBox.shrink();
    }

    return Html(
      data: htmlContent,
      style: {
        "body": Style(
          fontSize: FontSize(14),
          color: const Color(0xFF333333),
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        "p": Style(
          margin: Margins.only(bottom: 8),
        ),
        "img": Style(
          width: Width(375.w, Unit.px),
          display: Display.block,
        ),
      },
    );
  }

  /// 构建推荐商品区域
  Widget _buildRecommendSection(ShopDetailViewModel viewModel) {
    final products = viewModel.recommendList?.list;

    if (products == null || products.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        color: const Color(0xFFF7F9FC),
        child: ShopRecommendView(products: products),
      ),
    );
  }

  /// 构建返回按钮
  Widget _buildBackButton() {
    return Positioned(
      left: 12.w,
      top: 46.h,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Image.asset(
          'assets/images/icon_shop_detail_back.webp',
          width: 30.w,
          height: 30.w,
        ),
      ),
    );
  }

  /// 构建Banner位置指示器
  Widget _buildBannerIndicator(ShopDetailViewModel viewModel) {
    final images = viewModel.shopDetail?.productInfo?.sliderImageList ?? [];

    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      right: 12,
      top: 307,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '${_currentBannerIndex + 1}/${images.length}',
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// 处理收藏
  Future<void> _handleCollect(ShopDetailViewModel viewModel) async {
    final productId = viewModel.shopDetail?.productInfo?.id?.toString();
    if (productId == null) return;

    final isCollected = viewModel.shopDetail?.userCollect ?? false;
    bool success;

    if (isCollected) {
      success = await viewModel.unCollectShop(productId);
    } else {
      success = await viewModel.collectShop(productId);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isCollected ? '取消收藏成功' : '收藏成功'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  /// 处理加入购物车
  Future<void> _handleAddToCart(ShopDetailViewModel viewModel) async {
    final productId = viewModel.shopDetail?.productInfo?.id?.toString();
    if (productId == null) return;

    final success = await viewModel.addToCart(
      cartNum: 1,
      productId: productId,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('加入购物车成功'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  /// 处理立即购买
  Future<void> _handleBuyNow(ShopDetailViewModel viewModel) async {
    final productId = viewModel.shopDetail?.productInfo?.id?.toString();
    if (productId == null || productId.isEmpty) return;

    final cartId = await viewModel.ensureCartIdForBuyNow(productId: productId);
    if ((cartId ?? '').isEmpty) {
      if (mounted) {
        LoadingManager.instance.showToast('加入购物车失败，请稍后重试');
      }
      return;
    }

    final item = ConfigOrderDeliveryEntity(
      attrValueId: viewModel.selectedAttrId,
      productId: productId,
      sku: viewModel.selectedSku,
      productNum: 1,
      shoppingCartId: cartId,
    );

    final addressId = viewModel.defaultAddress?.id;
    await NavigatorService.instance.push(
      RoutePaths.other.configOrder,
      arguments: {
        'items': [item],
        'addressId': addressId,
        'preOrderType': 'buyNow',
      },
    );
  }

  Future<void> _handleSelectAddress(ShopDetailViewModel viewModel) async {
    final result = await NavigatorService.instance.push<UserAddressEntity>(
      RoutePaths.user.addressList,
      arguments: {'isUpdateAddress': true, 'orderId': ''},
    );
    if (result.success && result.data != null) {
      viewModel.updateAddress(result.data);
    }
  }

  void _handleViewAllComments() {
    final id = widget.productId;
    NavigatorService.instance.push(
      RoutePaths.product.commentList,
      arguments: {'id': id},
    );
  }
}
