import 'package:flutter/foundation.dart';
import '../api/order_api.dart';
import '../models/order_models.dart';

class OrderListTabViewModel extends ChangeNotifier {
  final int position;
  final List<OrderListEntity> _orders = [];
  int _page = 1;
  int _totalPage = -1;
  String? _keyword;
  bool _loading = false;

  OrderListTabViewModel(this.position);

  List<OrderListEntity> get orders => List.unmodifiable(_orders);
  bool get isLoading => _loading;
  bool get hasMore => _totalPage == -1 || _page <= _totalPage;

  void setKeyword(String? keyword, {bool refreshNow = false}) {
    _keyword = keyword;
    if (refreshNow) {
      refresh(showLoading: false);
    }
  }

  Future<void> refresh({bool showLoading = true}) async {
    _page = 1;
    await _loadOrders(isRefresh: true, showLoading: showLoading);
  }

  Future<void> loadMore() async {
    if (!hasMore) {
      return;
    }
    await _loadOrders(isRefresh: false, showLoading: false);
  }

  Future<void> _loadOrders({
    required bool isRefresh,
    required bool showLoading,
  }) async {
    _loading = true;
    notifyListeners();
    final type = _mapType(position);
    await OrderApi.getOrderList(
      page: _page,
      type: type,
      keywords: _keyword,
      showLoading: showLoading,
      onSuccess: (data) {
        if (isRefresh) {
          _orders.clear();
        }
        _page += 1;
        _totalPage = data?.totalPage ?? -1;
        final list = data?.list ?? [];
        _orders.addAll(list.whereType<OrderListEntity>());
        if (list.isEmpty) {
          _page -= 1;
        }
      },
    );
    _loading = false;
    notifyListeners();
  }

  void removeAt(int index) {
    if (index >= 0 && index < _orders.length) {
      _orders.removeAt(index);
      notifyListeners();
    }
  }

  static int _mapType(int position) {
    if (position == 5) {
      return -3;
    }
    if (position == 0) {
      return 4;
    }
    return position - 1;
  }
}
