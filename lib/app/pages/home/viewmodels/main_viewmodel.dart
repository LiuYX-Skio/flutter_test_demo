import 'package:flutter/material.dart';
import '../models/user_models.dart';
import '../models/address_models.dart';
import '../api/user_api.dart';

/// 主页面 ViewModel
/// 管理底部导航tab索引、全局用户信息、页面生命周期
class MainViewModel extends ChangeNotifier {
  // 当前选中的tab索引
  int _currentTabIndex = 0;

  // 用户信息
  UserInfoEntity? _userInfo;

  // 默认地址
  AddressEntity? _defaultAddress;

  // 用户信用详情
  UserCreditEntity? _userCreditDetail;

  // 加载状态
  bool _isLoading = false;

  // Getters
  int get currentTabIndex => _currentTabIndex;
  UserInfoEntity? get userInfo => _userInfo;
  AddressEntity? get defaultAddress => _defaultAddress;
  UserCreditEntity? get userCreditDetail => _userCreditDetail;
  bool get isLoading => _isLoading;

  /// 切换tab
  void changeTab(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  /// 初始化（对应Android的initActivity）
  Future<void> init() async {
    await Future.wait([
      fetchUserInfo(),
      fetchDefaultAddress(),
      fetchUserCreditDetail(),
    ]);
  }

  /// 恢复（对应Android的onResume）
  Future<void> resume() async {
    // 刷新用户信息
    await fetchUserInfo();
  }

  /// 获取用户信息
  Future<void> fetchUserInfo() async {
    try {
      final result = await UserApi.getUserInfo();
      if (result != null) {
        _userInfo = result;
        notifyListeners();
      }
    } catch (e) {
      print('获取用户信息失败: $e');
    }
  }

  /// 获取默认地址
  Future<void> fetchDefaultAddress() async {
    try {
      final result = await UserApi.getDefaultAddress();
      if (result != null) {
        _defaultAddress = result;
        notifyListeners();
      }
    } catch (e) {
      print('获取默认地址失败: $e');
    }
  }

  /// 获取用户信用详情
  Future<void> fetchUserCreditDetail() async {
    try {
      final result = await UserApi.getUserCreditDetail();
      if (result != null) {
        _userCreditDetail = result;
        notifyListeners();
      }
    } catch (e) {
      print('获取用户信用详情失败: $e');
    }
  }

  /// 设置加载状态
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
