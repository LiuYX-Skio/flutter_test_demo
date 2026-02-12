import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../../../widgets/shop_recommend_view.dart';
import '../models/order_models.dart';
import '../viewmodels/order_list_viewmodel.dart';
import '../widgets/order_list_item_widget.dart';
import '../api/order_api.dart';
import '../../home/models/product_models.dart';
import '../../mine/models/address_models.dart';
import '../../../widgets/refresh_list_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderListPage extends StatefulWidget {
  final int currentPage;
  final bool isSelectDeliver;

  const OrderListPage({
    super.key,
    this.currentPage = 0,
    this.isSelectDeliver = false,
  });

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  late List<OrderListTabViewModel> _tabViewModels;

  final List<String> _titles = const [
    '全部订单',
    '待付款',
    '待发货',
    '待收货',
    '待评价',
    '退货/款',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _titles.length, vsync: this);
    final currentPage =
        widget.currentPage.clamp(0, _titles.length - 1).toInt();
    _tabController.index = currentPage;
    _tabController.addListener(_onTabChanged);
    _searchController = TextEditingController();
    _tabViewModels =
        List.generate(_titles.length, (index) => OrderListTabViewModel(index));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabViewModels[currentPage].refresh(showLoading: currentPage == 0);
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
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
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          SizedBox(height: 50.h),
          _buildTopBar(),
          SizedBox(height: 10.h),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(_titles.length, (index) {
                return ChangeNotifierProvider.value(
                  value: _tabViewModels[index],
                  child: OrderListTabView(
                    orderType: index == 0 ? 0 : index,
                    isSelectDeliver: widget.isSelectDeliver,
                    onDeliverSelected: (deliverId) {
                      if (widget.isSelectDeliver) {
                        Navigator.of(context).pop(deliverId);
                      }
                    },
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
      height: 30.h,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 48.w,
              height: 30.h,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(
                    left: 11.w,
                    child: Image.asset(
                      'assets/images/icon_back.webp',
                      width: 11.w,
                      height: 18.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Container(
                height: 30.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 12.w),
                    Image.asset(
                      'assets/images/icon_search.webp',
                      width: 14.w,
                      height: 14.w,
                    ),
                    SizedBox(width: 13.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: '请输入搜索内容',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFFB6B7BB),
                          ),
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabWidth = MediaQuery.of(context).size.width / 5;
    final indicatorHorizontalInset = (tabWidth - 40.w) / 2;
    return Container(
      height: 44.h,
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFFFF3530),
        unselectedLabelColor: const Color(0xFF333333),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: const Color(0xFFFF3530),
            width: 3.h,
          ),
          insets: EdgeInsets.only(
            left: indicatorHorizontalInset,
            right: indicatorHorizontalInset,
            bottom: 2.h,
          ),
          borderRadius: BorderRadius.circular(2.h),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(fontSize: 13.sp),
        unselectedLabelStyle: TextStyle(fontSize: 13.sp),
        tabs: _titles
            .map(
              (e) => SizedBox(
                width: tabWidth,
                child: Tab(text: e),
              ),
            )
            .toList(),
      ),
    );
  }

  void _onSearchChanged(String value) {
    for (final vm in _tabViewModels) {
      vm.setKeyword(value, refreshNow: false);
    }
    _tabViewModels[_tabController.index].refresh(showLoading: false);
  }
}

class OrderListTabView extends StatefulWidget {
  final int orderType;
  final bool isSelectDeliver;
  final ValueChanged<String?>? onDeliverSelected;

  const OrderListTabView({
    super.key,
    required this.orderType,
    required this.isSelectDeliver,
    this.onDeliverSelected,
  });

  @override
  State<OrderListTabView> createState() => _OrderListTabViewState();
}

class _OrderListTabViewState extends State<OrderListTabView>
    with AutomaticKeepAliveClientMixin {
  late RefreshController _refreshController;
  List<ProductEntity> _recommendList = [];
  bool _recommendLoading = false;

  @override
  bool get wantKeepAlive => true;

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
    super.build(context);
    return Consumer<OrderListTabViewModel>(
      builder: (context, viewModel, child) {
        final list = viewModel.orders;
        if (list.isEmpty) {
          return _buildRecommend(viewModel);
        }
        return RefreshListWidget(
          controller: _refreshController,
          enablePullUp: viewModel.hasMore,
          onRefresh: () async {
            await viewModel.refresh(showLoading: false);
            _refreshController.resetNoData();
            _refreshController.refreshCompleted();
          },
          onLoading: () async {
            if (!viewModel.hasMore) {
              _refreshController.loadNoData();
              return;
            }
            await viewModel.loadMore();
            if (viewModel.hasMore) {
              _refreshController.loadComplete();
            } else {
              _refreshController.loadNoData();
            }
          },
          child: ListView.separated(
            padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
            itemCount: list.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final item = list[index];
              return OrderListItemWidget(
                data: item,
                orderType: widget.orderType,
                onPayBuy: () => _onPayBuy(item),
                onUpdateAddress: () => _onUpdateAddress(item, index),
                onDeleteOrder: () => _onDeleteOrder(item, index),
                onLogistics: () => _onLogistics(item),
                onService: _onService,
                onTap: () => _onItemTap(item),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRecommend(OrderListTabViewModel viewModel) {
    if (_recommendList.length < 3 && !_recommendLoading) {
      _recommendLoading = true;
      OrderApi.getRecommendList(
        page: 0,
        onSuccess: (data) {
          final list = data?.list ?? [];
          if (mounted && list.isNotEmpty) {
            setState(() {
              _recommendList = list;
            });
          }
          _recommendLoading = false;
        },
        onError: (_) {
          _recommendLoading = false;
        },
      );
    }
    return RefreshListWidget(
      controller: _refreshController,
      enablePullUp: viewModel.hasMore,
      onRefresh: () async {
        await viewModel.refresh(showLoading: false);
        _refreshController.resetNoData();
        _refreshController.refreshCompleted();
      },
      onLoading: () async {
        if (!viewModel.hasMore) {
          _refreshController.loadNoData();
          return;
        }
        await viewModel.loadMore();
        if (viewModel.hasMore) {
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      },
      child: _recommendList.isEmpty
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              child: ShopRecommendView(products: _recommendList),
            ),
    );
  }

  void _onPayBuy(OrderListEntity item) {
    if (widget.orderType == 1) {
      context.nav.push(RoutePaths.other.shopPay, arguments: {
        'orderNo': item.orderId,
        'orderId': item.id?.toString(),
        'payMoney': item.payPrice,
        'viewType': 1,
      });
      return;
    }
    if (widget.orderType == 2) {
      OrderApi.orderRefund(
        id: item.id ?? 0,
        orderId: item.orderId,
        onSuccess: (data) {
          LoadingManager.instance.showToast('您的退款申请已提交');
          Provider.of<OrderListTabViewModel>(context, listen: false)
              .refresh(showLoading: false);
        },
      );
      return;
    }
    if (widget.orderType == 4 || widget.orderType == 0 || widget.orderType == 5) {
      final info = item.orderInfoList?.isNotEmpty == true
          ? item.orderInfoList!.first
          : null;
      context.nav.push(RoutePaths.other.orderComment, arguments: {
        'productId': info?.productId,
        'orderNo': item.orderId,
        'storeName': info?.storeName,
        'image': info?.image,
      });
    }
  }

  void _onUpdateAddress(OrderListEntity item, int index) {
    if (widget.orderType == 3) {
      OrderApi.takeOrder(
        id: item.id ?? 0,
        onSuccess: (data) {
          LoadingManager.instance.showToast('提交成功');
          Provider.of<OrderListTabViewModel>(context, listen: false)
              .refresh(showLoading: false);
        },
      );
      return;
    }
    if (widget.orderType == 4 || widget.orderType == 0) {
      OrderApi.orderRefund(
        id: item.id ?? 0,
        orderId: item.orderId,
        onSuccess: (data) {
          LoadingManager.instance.showToast('您的退款申请已提交');
          Provider.of<OrderListTabViewModel>(context, listen: false)
              .refresh(showLoading: false);
        },
      );
      return;
    }
    context.nav.push<UserAddressEntity>(RoutePaths.user.addressList,
        arguments: {
          'isUpdateAddress': true,
          'orderId': item.orderId,
        }).then((result) {
      if (result.success && result.data != null && item.orderId != null) {
        OrderApi.updateOrderAddress(
          addressId: result.data!.id ?? '',
          orderId: item.orderId ?? '',
          onSuccess: (data) {
            LoadingManager.instance.showToast('地址修改成功');
            Provider.of<OrderListTabViewModel>(context, listen: false)
                .refresh(showLoading: false);
          },
        );
      }
    });
  }

  void _onDeleteOrder(OrderListEntity item, int index) {
    OrderApi.cancelOrder(
      id: item.id ?? 0,
      onSuccess: (data) {
        final viewModel = Provider.of<OrderListTabViewModel>(context, listen: false);
        viewModel.removeAt(index);
      },
    );
  }

  void _onLogistics(OrderListEntity item) {
    if (widget.orderType == 3 ||
        widget.orderType == 4 ||
        widget.orderType == 0) {
      context.nav.push(RoutePaths.other.orderDetail, arguments: {
        'orderId': item.orderId,
      });
    }
  }

  void _onService() {
    context.nav.push(RoutePaths.other.chatService);
  }

  void _onItemTap(OrderListEntity item) {
    if (widget.isSelectDeliver) {
      if ((item.deliveryId ?? '').isEmpty) {
        LoadingManager.instance.showToast('快递单号获取失败');
        return;
      }
      widget.onDeliverSelected?.call(item.deliveryId);
      return;
    }
    if (widget.orderType == 1) {
      final info = item.orderInfoList?.isNotEmpty == true
          ? item.orderInfoList!.first
          : null;
      if (info?.productId != null) {
        context.nav.push(RoutePaths.product.detail, arguments: {
          'id': int.tryParse(info!.productId ?? '0') ?? 0,
        });
      }
    } else {
      context.nav.push(RoutePaths.other.orderPaySuccess, arguments: {
        'orderId': item.orderId,
      });
    }
  }
}
