import 'package:flutter/foundation.dart';
import '../api/shop_sort_api.dart';
import '../models/shop_detail_models.dart';

class ShopSearchViewModel extends ChangeNotifier {
  final List<ShopInfoEntity> _results = <ShopInfoEntity>[];
  bool _isLoading = false;
  String _keyword = '';

  List<ShopInfoEntity> get results => _results;
  bool get isLoading => _isLoading;
  String get keyword => _keyword;

  Future<void> search(String keyword) async {
    _keyword = keyword.trim();
    if (_keyword.isEmpty) {
      _results.clear();
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    await ShopSortApi.searchShopList(
      keyword: _keyword,
      onSuccess: (data) {
        _results
          ..clear()
          ..addAll((data?.list ?? const <ShopInfoEntity?>[]).whereType<ShopInfoEntity>());
      },
    );
    _isLoading = false;
    notifyListeners();
  }
}

