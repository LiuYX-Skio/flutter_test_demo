import 'package:flutter/material.dart';
import '../models/home_models.dart';
import '../models/product_models.dart';
import '../api/home_api.dart';

/// 首页 ViewModel
/// 管理首页顶部数据、商品列表、下拉刷新、上拉加载
class HomeViewModel extends ChangeNotifier {
  // 首页顶部数据
  HomeTitleDataEntity? _homeData;

  // 商品列表
  List<ProductEntity> _productList = [];

  // 当前页码
  int _currentPage = 1;

  // 加载状态
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  // 错误信息
  String? _errorMessage;

  // Getters
  HomeTitleDataEntity? get homeData => _homeData;
  List<ProductEntity> get productList => _productList;
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  /// 刷新首页数据
  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    _errorMessage = null;

    await Future.wait([
      fetchHomeData(),
      fetchProductList(1),
    ]);
  }

  /// 加载更多商品
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      await fetchProductList(nextPage);
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// 获取首页顶部数据
  Future<void> fetchHomeData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await HomeApi.getHomeData();
      if (result != null) {
        _homeData = result;
        _errorMessage = null;
      }
    } catch (e) {
      _errorMessage = '获取首页数据失败';
      print('获取首页数据失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 获取商品列表
  Future<void> fetchProductList(int page) async {
    try {
      final result = await HomeApi.getHomeRecommendList(page: page);
      if (result != null && result.list != null) {
        if (page == 1) {
          _productList = result.list!;
        } else {
          _productList.addAll(result.list!);
        }
        _currentPage = page;
        _hasMore = result.list!.isNotEmpty &&
                   (result.totalPage == null || page < result.totalPage!);
        _errorMessage = null;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage = '获取商品列表失败';
      print('获取商品列表失败: $e');
    }
  }
}
