import 'package:flutter/material.dart';
import '../models/user_models.dart';
import '../../../provider/user_provider.dart';
import '../models/product_models.dart';
import '../api/user_api.dart';
import '../api/product_api.dart';

/// 我的页面 ViewModel
/// 管理用户信息、推荐商品列表、登录状态等
/// 完全按照Android MineFragment逻辑实现
class MineViewModel extends ChangeNotifier {
  // 用户信息
  UserInfoEntity? _userInfo;
  // 月付申请详情
  UserCreditEntity? _userCreditDetail;

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
  UserCreditEntity? get userCreditDetail => _userCreditDetail;
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
    if (_isLogin) {
      final name = UserProvider.getUserNickName();
      if (name.isNotEmpty) return name;
      if (_userInfo?.nickname != null) return _userInfo!.nickname!;
    }
    return '立即登录'; // app_login string
  }

  // 计算属性 - 用户头像
  String? get userAvatar {
    if (_isLogin) {
      final avatar = UserProvider.getUserAvatar();
      if (avatar.isNotEmpty) return avatar;
    }
    return _userInfo?.avatar;
  }

  // 计算属性 - 用户手机号
  String get userPhone {
    if (_isLogin) {
      final rawPhone = UserProvider.getUserPhone();
      final phone = rawPhone.isNotEmpty ? rawPhone : (_userInfo?.phone ?? '');
      if (phone.length >= 7) {
        return '${phone.substring(0, 3)}****${phone.substring(7)}';
      }
      return phone;
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
      fetchUserCreditDetail(),
      fetchProductList(1),
    ]);

    // 更新用户状态
    updateUserState();
  }

  /// 更新用户状态 (对应Android的updateUser和updateTestAccount方法)
  void updateUserState() {
    _isLogin = UserProvider.isLogin();
    if (!_isLogin) {
      _userInfo = null;
      _userCreditDetail = null;
      _isTestAccount = false;
      _isMonthPayOpen = false;
      _hasUserInfo = false;
      notifyListeners();
      return;
    }
    _isTestAccount = _userInfo?.hasTestAccount ?? false;
    _isMonthPayOpen =
        (_userCreditDetail?.hasApply == true && _userCreditDetail?.status == 2);
    _hasUserInfo = _userInfo != null;

    notifyListeners();
  }

  /// 从外部页面返回后同步用户态（如设置页退出登录后）
  Future<void> syncUserStateAfterRouteBack() async {
    if (!UserProvider.isLogin()) {
      updateUserState();
      return;
    }
    await fetchUserInfo();
    await fetchUserCreditDetail();
    updateUserState();
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
          UserProvider.setUserNickName(result.nickname);
          UserProvider.setUserPhone(result.phone);
          UserProvider.setUserAvatar(result.avatar);
          UserProvider.setUserMoney(result.nowMoney?.toString());
        }
        _isLoading = false;
        updateUserState();
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

  /// 获取用户信用详情 (月付申请详情)
  Future<void> fetchUserCreditDetail() async {
    await UserApi.getUserCreditDetail(
      onSuccess: (result) {
        _userCreditDetail = result;
        _errorMessage = null;
        updateUserState();
      },
      onError: (exception) {
        _errorMessage = '获取信用详情失败';
        print('获取用户信用详情失败: $exception');
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

  /// 退出登录
  Future<void> loginOut({
    required VoidCallback onSuccess,
  }) async {
    await UserApi.loginOut(
      onSuccess: (_) async {
        await UserProvider.clearUserInfo();
        updateUserState();
        onSuccess();
      },
      onError: (exception) {
        _errorMessage = '退出登录失败';
        debugPrint('退出登录失败: ${exception.message}');
      },
    );
  }

  /// 注销账号
  Future<void> cancelAccount({
    required VoidCallback onSuccess,
  }) async {
    await UserApi.cancelAccount(
      onSuccess: (_) async {
        await UserProvider.clearUserInfo();
        updateUserState();
        onSuccess();
      },
      onError: (exception) {
        _errorMessage = '注销账号失败';
        debugPrint('注销账号失败: ${exception.message}');
      },
    );
  }
}
