import 'package:flutter/foundation.dart';
import '../api/shop_detail_api.dart';
import '../models/shop_detail_models.dart';

class ShopCommentViewModel extends ChangeNotifier {
  final List<ShopCommentEntity> _list = <ShopCommentEntity>[];
  int _page = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  List<ShopCommentEntity> get list => _list;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  Future<void> loadFirstPage(int productId) async {
    _page = 1;
    _hasMore = true;
    _list.clear();
    _isLoading = true;
    notifyListeners();
    await _load(productId, loadMore: false);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore(int productId) async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();
    await _load(productId, loadMore: true);
    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> _load(int productId, {required bool loadMore}) async {
    await ShopDetailApi.getShopCommentList(
      id: productId,
      page: _page,
      onSuccess: (data) {
        final pageList = (data?.list ?? const <ShopCommentEntity?>[]).whereType<ShopCommentEntity>().toList();
        _list.addAll(pageList);
        if (pageList.isNotEmpty) {
          _page += 1;
        } else {
          _hasMore = false;
        }
      },
    );
  }
}

