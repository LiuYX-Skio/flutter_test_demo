import 'package:flutter/material.dart';
import 'package:flutter_test_demo/app/widgets/empty_widget.dart';
import 'package:flutter_test_demo/app/widgets/error_widget.dart';
import 'package:flutter_test_demo/app/widgets/loading_widget.dart';
import 'package:flutter_test_demo/app/widgets/refresh_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../viewmodels/sort_viewmodel.dart';
import '../widgets/sort/ranking_list_widget.dart';

/// 排行榜Tab视图
class SortTabView extends StatefulWidget {
  const SortTabView({Key? key}) : super(key: key);

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
      appBar: AppBar(
        title: const Text('排行榜'),
        centerTitle: true,
      ),
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

          return RefreshListWidget(
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            enablePullUp: viewModel.hasMore,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  RankingListWidget(
                    products: viewModel.sortList,
                    onTap: (product) {
                      print('点击排行榜商品: ${product.name}');
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
