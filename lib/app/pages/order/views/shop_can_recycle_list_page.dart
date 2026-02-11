import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../widgets/refresh_list_widget.dart';
import '../viewmodels/can_recycle_viewmodel.dart';
import '../widgets/can_recycle_item_widget.dart';

class ShopCanRecycleListPage extends StatefulWidget {
  final String recycleType;

  const ShopCanRecycleListPage({
    super.key,
    required this.recycleType,
  });

  @override
  State<ShopCanRecycleListPage> createState() => _ShopCanRecycleListPageState();
}

class _ShopCanRecycleListPageState extends State<ShopCanRecycleListPage> {
  late final CanRecycleOrderViewModel _viewModel;
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _viewModel = CanRecycleOrderViewModel(recycleType: widget.recycleType);
    _refreshController = RefreshController(initialRefresh: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.refresh(showLoading: false);
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        body: Column(
          children: [
            SizedBox(height: 44.h),
            _buildTopBar(),
            Expanded(
              child: Consumer<CanRecycleOrderViewModel>(
                builder: (context, viewModel, child) {
                  final list = viewModel.orders;
                  return RefreshListWidget(
                    controller: _refreshController,
                    onRefresh: () async {
                      await viewModel.refresh(showLoading: false);
                      _refreshController.refreshCompleted();
                    },
                    onLoading: () async {
                      await viewModel.loadMore();
                      _refreshController.loadComplete();
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return CanRecycleItemWidget(
                          data: item,
                          onTap: () => context.nav.pop(item),
                        );
                      },
                    ),
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
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 11.w),
              child: Image.asset(
                'assets/images/icon_back.webp',
                width: 11.w,
                height: 18.h,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '商品回收',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
          ),
          SizedBox(width: 36.w),
        ],
      ),
    );
  }
}
