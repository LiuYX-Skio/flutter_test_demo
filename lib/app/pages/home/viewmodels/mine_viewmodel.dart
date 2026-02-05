import 'package:flutter/material.dart';
import '../models/user_models.dart';
import '../models/product_models.dart';
import '../api/user_api.dart';
import '../api/product_api.dart';

/// 我的页面 ViewModel
/// 管理用户信息、推荐商品列表
class MineViewModel extends ChangeNotifier {
  // 用户信息
  UserInfoEntity? _userInfo;

  // 推荐商品列表
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
  UserInfoEntity? get userInfo => _userInfo;
  List<ProductEntity> get productList => _productList;
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  /// 刷新数据
  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    _errorMessage = null;

    await Future.wait([
      fetchUserInfo(),
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

  /// 获取用户信息
  Future<void> fetchUserInfo() async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await UserApi.getUserInfo();
      if (result != null) {
        _userInfo = result;
        _errorMessage = null;
      }
    } catch (e) {
      _errorMessage = '获取用户信息失败';
      print('获取用户信息失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 获取推荐商品列表
  Future<void> fetchProductList(int page) async {
    try {
      final result = await ProductApi.getHotProducts(page: page);
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
      _errorMessage = '获取推荐商品失败';
      print('获取推荐商品失败: $e');
    }
  }
}
