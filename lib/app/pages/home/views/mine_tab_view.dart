import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../viewmodels/mine_viewmodel.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/common/refresh_list_widget.dart';
import '../widgets/mine/user_header_widget.dart';
import '../widgets/mine/feature_grid_widget.dart';
import '../widgets/mine/mine_product_list.dart';

/// 我的Tab视图
class MineTabView extends StatefulWidget {
  const MineTabView({Key? key}) : super(key: key);

  @override
  State<MineTabView> createState() => _MineTabViewState();
}

class _MineTabViewState extends State<MineTabView>
    with AutomaticKeepAliveClientMixin {
  late RefreshController _refreshController;
  late MineViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);

    // 延迟初始化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<MineViewModel>(context, listen: false);
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
      body: Consumer<MineViewModel>(
        builder: (context, viewModel, child) {
          // 首次加载
          if (viewModel.isLoading && viewModel.userInfo == null) {
            return const LoadingWidget(message: '加载中...');
          }

          // 加载失败
          if (viewModel.errorMessage != null && viewModel.userInfo == null) {
            return ErrorStateWidget(
              message: viewModel.errorMessage,
              onRetry: () => viewModel.refresh(),
            );
          }

          return RefreshListWidget(
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            enablePullUp: viewModel.hasMore,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 用户信息头部
                  UserHeaderWidget(
                    userInfo: viewModel.userInfo,
                    onTap: () {
                      print('点击用户信息');
                    },
                  ),

                  SizedBox(height: 16.h),

                  // 功能入口网格
                  FeatureGridWidget(
                    features: _buildFeatures(),
                  ),

                  SizedBox(height: 16.h),

                  // 推荐商品列表
                  MineProductList(
                    products: viewModel.productList,
                    onTap: (product) {
                      print('点击推荐商品: ${product.name}');
                    },
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<FeatureItem> _buildFeatures() {
    return [
      FeatureItem(
        title: '我的订单',
        icon: Icons.shopping_bag_outlined,
        onTap: () => print('我的订单'),
      ),
      FeatureItem(
        title: '我的收藏',
        icon: Icons.favorite_border,
        onTap: () => print('我的收藏'),
      ),
      FeatureItem(
        title: '收货地址',
        icon: Icons.location_on_outlined,
        onTap: () => print('收货地址'),
      ),
      FeatureItem(
        title: '客服中心',
        icon: Icons.headset_mic_outlined,
        onTap: () => print('客服中心'),
      ),
      FeatureItem(
        title: '优惠券',
        icon: Icons.card_giftcard_outlined,
        onTap: () => print('优惠券'),
      ),
      FeatureItem(
        title: '积分商城',
        icon: Icons.stars_outlined,
        onTap: () => print('积分商城'),
      ),
      FeatureItem(
        title: '设置',
        icon: Icons.settings_outlined,
        onTap: () => print('设置'),
      ),
      FeatureItem(
        title: '关于',
        icon: Icons.info_outline,
        onTap: () => print('关于'),
      ),
    ];
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
