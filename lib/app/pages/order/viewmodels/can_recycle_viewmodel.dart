import 'package:flutter/foundation.dart';
import '../api/order_api.dart';
import '../models/order_models.dart';

class CanRecycleOrderViewModel extends ChangeNotifier {
  final String recycleType;
  final List<GoldEntity> _orders = [];
  int _page = 1;
  int _totalPage = -1;
  bool _loading = false;

  CanRecycleOrderViewModel({required this.recycleType});

  List<GoldEntity> get orders => List.unmodifiable(_orders);
  bool get isLoading => _loading;

  Future<void> refresh({bool showLoading = false}) async {
    _page = 1;
    await _loadOrders(isRefresh: true, showLoading: showLoading);
  }

  Future<void> loadMore() async {
    if (_totalPage != -1 && _page > _totalPage) {
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
    await GoldApi.canRecycleOrder(
      page: _page,
      recycleType: recycleType,
      onSuccess: (data) {
        if (isRefresh) {
          _orders.clear();
        }
        _page += 1;
        _totalPage = data?.totalPage ?? -1;
        final list = data?.list ?? [];
        _orders.addAll(list.whereType<GoldEntity>());
        if (list.isEmpty) {
          _page -= 1;
        }
      },
    );
    _loading = false;
    notifyListeners();
  }
}
