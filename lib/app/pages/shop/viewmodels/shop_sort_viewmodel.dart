import 'package:flutter/foundation.dart';
import '../api/shop_sort_api.dart';
import '../models/shop_detail_models.dart';
import '../models/shop_models.dart';

class ShopSortViewModel extends ChangeNotifier {
  final List<MenuEntity> _categories = <MenuEntity>[];
  final List<ShopInfoEntity> _products = <ShopInfoEntity>[];

  int _page = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _selectedCategoryId;

  List<MenuEntity> get categories => _categories;
  List<ShopInfoEntity> get products => _products;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get selectedCategoryId => _selectedCategoryId;

  Future<void> loadCategories({String? initialCategoryId}) async {
    _isLoading = true;
    notifyListeners();
    await ShopSortApi.getSortList(
      onSuccess: (data) {
        _categories
          ..clear()
          ..addAll((data?.list ?? const <MenuEntity?>[])
              .whereType<MenuEntity>()
              .map((e) => e.copyWith(isSelect: false)));

        if (_categories.isEmpty) {
          _selectedCategoryId = null;
          _products.clear();
          _hasMore = false;
          return;
        }

        final targetId = (initialCategoryId != null && initialCategoryId.isNotEmpty)
            ? initialCategoryId
            : (_categories.first.id?.toString() ?? '');
        selectCategory(targetId, silentLoad: true);
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectCategory(String? categoryId, {bool silentLoad = false}) async {
    if ((categoryId ?? '').isEmpty) return;
    _selectedCategoryId = categoryId;
    for (var index = 0; index < _categories.length; index++) {
      _categories[index] = _categories[index].copyWith(
        isSelect: _categories[index].id?.toString() == categoryId,
      );
    }
    _page = 1;
    _hasMore = true;
    _products.clear();
    notifyListeners();
    await loadProducts(loadMore: false, silent: silentLoad);
  }

  Future<void> loadProducts({required bool loadMore, bool silent = false}) async {
    final cid = _selectedCategoryId;
    if ((cid ?? '').isEmpty) return;
    if (loadMore && (!_hasMore || _isLoadingMore)) return;
    if (!loadMore && _isLoading) return;

    if (loadMore) {
      _isLoadingMore = true;
    } else if (!silent) {
      _isLoading = true;
    }
    notifyListeners();

    await ShopSortApi.getShopList(
      page: _page,
      cid: cid!,
      onSuccess: (data) {
        final list = (data?.list ?? const <ShopInfoEntity?>[]).whereType<ShopInfoEntity>().toList();
        if (!loadMore) {
          _products.clear();
        }
        _products.addAll(list);
        if (list.isNotEmpty) {
          _page += 1;
        } else {
          _hasMore = false;
        }
      },
    );

    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }
}
