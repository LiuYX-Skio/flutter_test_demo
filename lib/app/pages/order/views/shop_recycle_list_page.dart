import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../../../widgets/refresh_list_widget.dart';
import '../models/order_models.dart';
import '../viewmodels/recycle_order_viewmodel.dart';
import '../widgets/recycle_shop_item_widget.dart';

class ShopRecycleListPage extends StatefulWidget {
  final String recycleType;
  final int currentPage;

  const ShopRecycleListPage({
    super.key,
    required this.recycleType,
    this.currentPage = 0,
  });

  @override
  State<ShopRecycleListPage> createState() => _ShopRecycleListPageState();
}

class _ShopRecycleListPageState extends State<ShopRecycleListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<RecycleOrderTabViewModel> _tabViewModels;

  final List<String> _titles = const [
    '待回购',
    '检测中',
    '待确认',
    '已打款',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _titles.length, vsync: this);
    _tabController.index = widget.currentPage;
    _tabController.addListener(_onTabChanged);
    _tabViewModels = List.generate(
      _titles.length,
      (index) => RecycleOrderTabViewModel(
        recycleType: widget.recycleType,
        status: _statusByIndex(index),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabViewModels[widget.currentPage].refresh(showLoading: true);
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    for (final vm in _tabViewModels) {
      vm.dispose();
    }
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final vm = _tabViewModels[_tabController.index];
    if (vm.orders.isEmpty && !vm.isLoading) {
      vm.refresh(showLoading: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 44.h),
          _buildTopBar(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(_titles.length, (index) {
                return ChangeNotifierProvider.value(
                  value: _tabViewModels[index],
                  child: RecycleOrderTabView(
                    statusText: _titles[index],
                    canCancel: index == 0,
                  ),
                );
              }),
            ),
          ),
        ],
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
                '回收订单',
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

  Widget _buildTabBar() {
    return SizedBox(
      height: 40.h,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFFFF3530),
        unselectedLabelColor: const Color(0xFF333333),
        indicatorColor: const Color(0xFFFF3530),
        indicatorWeight: 2.h,
        labelStyle: TextStyle(fontSize: 14.sp),
        unselectedLabelStyle: TextStyle(fontSize: 14.sp),
        tabs: _titles.map((e) => Tab(text: e)).toList(),
      ),
    );
  }

  int _statusByIndex(int index) {
    switch (index) {
      case 0:
        return 1;
      case 1:
        return 2;
      case 2:
        return 3;
      case 3:
        return 4;
    }
    return 1;
  }
}

class RecycleOrderTabView extends StatefulWidget {
  final String statusText;
  final bool canCancel;

  const RecycleOrderTabView({
    super.key,
    required this.statusText,
    required this.canCancel,
  });

  @override
  State<RecycleOrderTabView> createState() => _RecycleOrderTabViewState();
}

class _RecycleOrderTabViewState extends State<RecycleOrderTabView> {
  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecycleOrderTabViewModel>(
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
          child: Container(
            color: const Color(0xFFF7F9FC),
            child: ListView.separated(
              padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
              itemCount: list.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final item = list[index];
                return RecycleShopItemWidget(
                  data: item,
                  statusText: widget.statusText,
                  onTap: () => _onItemTap(item),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _onItemTap(RecycleShopEntity item) {
    context.nav.push(
      RoutePaths.other.shopRecycleDetail,
      arguments: {
        'id': item.id ?? '',
        'isCanCancelOrder': widget.canCancel,
      },
    );
  }
}
