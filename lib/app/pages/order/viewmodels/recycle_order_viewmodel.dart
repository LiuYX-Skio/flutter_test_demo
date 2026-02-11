import 'package:flutter/foundation.dart';
import '../api/order_api.dart';
import '../models/order_models.dart';

class RecycleOrderTabViewModel extends ChangeNotifier {
  final String recycleType;
  final int status;

  final List<RecycleShopEntity> _orders = [];
  int _page = 1;
  int _totalPage = -1;
  bool _loading = false;

  RecycleOrderTabViewModel({
    required this.recycleType,
    required this.status,
  });

  List<RecycleShopEntity> get orders => List.unmodifiable(_orders);
  bool get isLoading => _loading;

  Future<void> refresh({bool showLoading = true}) async {
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
    await GoldApi.recycleOrderList(
      page: _page,
      status: status,
      recycleType: recycleType,
      onSuccess: (data) {
        if (isRefresh) {
          _orders.clear();
        }
        _page += 1;
        _totalPage = data?.totalPage ?? -1;
        final list = data?.list ?? [];
        _orders.addAll(list.whereType<RecycleShopEntity>());
        if (list.isEmpty) {
          _page -= 1;
        }
      },
    );
    _loading = false;
    notifyListeners();
  }
}
