import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/common/empty_widget.dart';
import '../widgets/common/refresh_list_widget.dart';
import '../widgets/home/banner_widget.dart';
import '../widgets/home/menu_grid_widget.dart';
import '../widgets/home/product_list_widget.dart';

/// 首页Tab视图
class HomeTabView extends StatefulWidget {
  const HomeTabView({Key? key}) : super(key: key);

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
      appBar: AppBar(
        title: const Text('首页'),
        centerTitle: true,
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          // 首次加载
          if (viewModel.isLoading && viewModel.homeData == null) {
            return const LoadingWidget(message: '加载中...');
          }

          // 加载失败
          if (viewModel.errorMessage != null && viewModel.homeData == null) {
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
                  // 轮播图
                  if (viewModel.homeData?.banner != null &&
                      viewModel.homeData!.banner!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: BannerWidget(
                        banners: viewModel.homeData!.banner!,
                        onTap: (banner) {
                          print('点击轮播图: ${banner.title}');
                        },
                      ),
                    ),

                  // 菜单网格
                  if (viewModel.homeData?.menuCategoryList != null &&
                      viewModel.homeData!.menuCategoryList!.isNotEmpty)
                    MenuGridWidget(
                      menus: viewModel.homeData!.menuCategoryList!,
                      onTap: (menu) {
                        print('点击菜单: ${menu.name}');
                      },
                    ),

                  // 公告
                  if (viewModel.homeData?.noticeContent != null)
                    _buildNotice(viewModel.homeData!.noticeContent!),

                  // 商品列表标题
                  _buildSectionTitle('推荐商品'),

                  // 商品列表
                  if (viewModel.productList.isEmpty)
                    const EmptyWidget(message: '暂无商品')
                  else
                    ProductListWidget(
                      products: viewModel.productList,
                      onTap: (product) {
                        print('点击商品: ${product.name}');
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

  Widget _buildNotice(String notice) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.campaign,
            color: Colors.orange,
            size: 20.w,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              notice,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.orange[800],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
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
