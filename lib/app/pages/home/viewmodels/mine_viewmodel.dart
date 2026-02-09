import 'package:flutter/material.dart';
import '../models/user_models.dart';
import '../models/product_models.dart';
import '../api/user_api.dart';
import '../api/product_api.dart';

/// 我的页面 ViewModel
/// 管理用户信息、推荐商品列表、登录状态等
/// 完全按照Android MineFragment逻辑实现
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

  // 用户状态相关
  bool _isLogin = false; // 是否登录
  bool _isTestAccount = false; // 是否测试账号
  bool _isMonthPayOpen = false; // 月付是否开通
  bool _hasUserInfo = false; // 是否有用户信息

  // Getters
  UserInfoEntity? get userInfo => _userInfo;
  List<ProductEntity> get productList => _productList;
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  // 用户状态
  bool get isLogin => _isLogin;
  bool get isTestAccount => _isTestAccount;
  bool get isMonthPayOpen => _isMonthPayOpen;

  // 计算属性 - 用户名
  String get userName {
    if (_isLogin && _userInfo?.nickname != null) {
      return _userInfo!.nickname!;
    }
    return '立即登录'; // app_login string
  }

  // 计算属性 - 用户头像
  String? get userAvatar => _userInfo?.avatar;

  // 计算属性 - 用户手机号
  String get userPhone {
    if (_isLogin && _userInfo?.phone != null && _userInfo!.phone!.length >= 7) {
      // 手机号格式化：138****1234
      final phone = _userInfo!.phone!;
      return '${phone.substring(0, 3)}****${phone.substring(7)}';
    }
    return '登录后享受更多服务'; // app_login_desc string
  }

  /// 刷新数据
  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    _errorMessage = null;

    await Future.wait([
      fetchUserInfo(),
      fetchProductList(1),
    ]);

    // 更新用户状态
    updateUserState();
  }

  /// 更新用户状态 (对应Android的updateUser和updateTestAccount方法)
  void updateUserState() {
    // 这里应该从某种状态管理或SharedPreferences中获取用户状态
    // 暂时使用模拟数据
    _isLogin = _userInfo != null;
    _isTestAccount = false; // 暂时设为false
    _isMonthPayOpen = true; // 暂时设为true
    _hasUserInfo = _userInfo != null;

    notifyListeners();
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
    _isLoading = true;
    notifyListeners();

    await UserApi.getUserInfo(
      onSuccess: (result) {
        if (result != null) {
          _userInfo = result;
          _errorMessage = null;
        }
        _isLoading = false;
        notifyListeners();
      },
      onError: (exception) {
        _errorMessage = '获取用户信息失败';
        print('获取用户信息失败: $exception');
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// 获取推荐商品列表 (对应Android的recommendList方法)
  Future<void> recommendList(bool isShowProgress, int page, int limit) async {
    if (isShowProgress) {
      _isLoading = true;
      notifyListeners();
    }

    await ProductApi.getHotProducts(
      page: page,
      onSuccess: (result) {
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

        if (isShowProgress) {
          _isLoading = false;
        }
        notifyListeners();
      },
      onError: (exception) {
        _errorMessage = '获取推荐商品失败';
        print('获取推荐商品失败: $exception');

        if (isShowProgress) {
          _isLoading = false;
        }
        notifyListeners();
      },
    );
  }

  /// 获取推荐商品列表 (原有方法，保持兼容)
  Future<void> fetchProductList(int page) async {
    await recommendList(page == 1, page, 20); // 默认limit为20
  }
}
