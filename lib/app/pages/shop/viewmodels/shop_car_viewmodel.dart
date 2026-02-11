import 'package:flutter/foundation.dart';
import '../../order/models/order_models.dart';
import '../api/shop_detail_api.dart';
import '../models/shop_models.dart';

class ShopCarViewModel extends ChangeNotifier {
  final List<ShopCarEntity> _cartList = <ShopCarEntity>[];
  bool _isLoading = false;
  int? _selectedRecycleType;

  List<ShopCarEntity> get cartList => _cartList;
  bool get isLoading => _isLoading;

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();
    await ShopDetailApi.getShopCartList(
      onSuccess: (data) {
        _cartList
          ..clear()
          ..addAll((data?.list ?? const <ShopCarEntity?>[]).whereType<ShopCarEntity>());
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  bool get hasSelected => _cartList.any((item) => item.isSelect);

  double get selectedTotal {
    var sum = 0.0;
    for (final item in _cartList) {
      if (!item.isSelect) continue;
      final price = double.tryParse(item.price ?? '0') ?? 0.0;
      sum += price * item.cartNum;
    }
    return sum;
  }

  bool get isSelectAll => _cartList.isNotEmpty && _cartList.every((item) => item.isSelect);

  void toggleSelectAll(bool selected) {
    _selectedRecycleType = selected ? _selectedRecycleType : null;
    for (var index = 0; index < _cartList.length; index++) {
      _cartList[index] = _cartList[index].copyWith(isSelect: selected);
    }
    if (!selected) {
      _selectedRecycleType = null;
    }
    notifyListeners();
  }

  bool toggleItemSelect(int index) {
    if (index < 0 || index >= _cartList.length) return false;
    final item = _cartList[index];
    final currentType = item.recycleType ?? 3;
    if (!item.isSelect && _selectedRecycleType != null && _selectedRecycleType != currentType) {
      return false;
    }
    final next = !item.isSelect;
    _cartList[index] = item.copyWith(isSelect: next);
    if (next) {
      _selectedRecycleType = currentType;
    } else if (_cartList.where((element) => element.isSelect).isEmpty) {
      _selectedRecycleType = null;
    }
    notifyListeners();
    return true;
  }

  Future<void> increase(int index) async {
    if (index < 0 || index >= _cartList.length) return;
    final item = _cartList[index];
    final next = item.cartNum + 1;
    final id = item.id;
    if ((id ?? '').isEmpty) return;
    await ShopDetailApi.updateShopCartNum(id: id!, number: next);
    _cartList[index] = item.copyWith(cartNum: next);
    notifyListeners();
  }

  Future<void> decrease(int index) async {
    if (index < 0 || index >= _cartList.length) return;
    final item = _cartList[index];
    final id = item.id;
    if ((id ?? '').isEmpty) return;
    final next = item.cartNum - 1;
    if (next <= 0) {
      await ShopDetailApi.deleteShopCart(id: id!);
      _cartList.removeAt(index);
    } else {
      await ShopDetailApi.updateShopCartNum(id: id!, number: next);
      _cartList[index] = item.copyWith(cartNum: next);
    }
    if (_cartList.where((element) => element.isSelect).isEmpty) {
      _selectedRecycleType = null;
    }
    notifyListeners();
  }

  List<ConfigOrderDeliveryEntity> buildConfigOrderItems() {
    return _cartList
        .where((item) => item.isSelect)
        .map(
          (item) => ConfigOrderDeliveryEntity(
            attrValueId: item.attrId,
            productId: item.productId,
            productNum: item.cartNum,
            shoppingCartId: item.id,
          ),
        )
        .toList();
  }

  int get totalCount {
    var count = 0;
    for (final item in _cartList) {
      count += item.cartNum;
    }
    return count;
  }
}

