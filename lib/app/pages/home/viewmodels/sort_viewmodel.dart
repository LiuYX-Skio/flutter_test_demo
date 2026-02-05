import 'package:flutter/material.dart';
import '../models/product_models.dart';
import '../api/home_api.dart';

/// 排行榜 ViewModel
/// 管理排行榜列表、下拉刷新、上拉加载
class SortViewModel extends ChangeNotifier {
  // 排行榜列表
  List<ProductEntity> _sortList = [];

  // 当前页码
  int _currentPage = 1;

  // 加载状态
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  // 错误信息
  String? _errorMessage;

  // Getters
  List<ProductEntity> get sortList => _sortList;
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  /// 刷新排行榜数据
  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    _errorMessage = null;

    await fetchSortList(1);
  }

  /// 加载更多
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      await fetchSortList(nextPage);
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// 获取排行榜列表
  Future<void> fetchSortList(int page) async {
    try {
      if (page == 1) {
        _isLoading = true;
      }
      notifyListeners();

      final result = await HomeApi.getSortShopList(page: page);
      if (result != null && result.list != null) {
        if (page == 1) {
          _sortList = result.list!;
        } else {
          _sortList.addAll(result.list!);
        }
        _currentPage = page;
        _hasMore = result.list!.isNotEmpty &&
                   (result.totalPage == null || page < result.totalPage!);
        _errorMessage = null;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage = '获取排行榜失败';
      print('获取排行榜失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
