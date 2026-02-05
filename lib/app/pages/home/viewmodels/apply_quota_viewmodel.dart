import 'package:flutter/material.dart';
import '../models/user_models.dart';
import '../api/user_api.dart';

/// 月付申请 ViewModel
/// 管理月付申请状态、用户认证状态
class ApplyQuotaViewModel extends ChangeNotifier {
  // 用户信用详情
  UserCreditEntity? _userCreditDetail;

  // 我的额度
  MyCreditEntity? _myCreditLimit;

  // 加载状态
  bool _isLoading = false;

  // 错误信息
  String? _errorMessage;

  // Getters
  UserCreditEntity? get userCreditDetail => _userCreditDetail;
  MyCreditEntity? get myCreditLimit => _myCreditLimit;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 检查用户认证状态
  bool get isAuthenticated {
    return _userCreditDetail?.status == 2; // 2表示已通过
  }

  /// 刷新数据
  Future<void> refresh() async {
    await Future.wait([
      fetchUserCreditDetail(),
      fetchMyCreditLimit(),
    ]);
  }

  /// 获取用户信用详情
  Future<void> fetchUserCreditDetail() async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await UserApi.getUserCreditDetail();
      if (result != null) {
        _userCreditDetail = result;
        _errorMessage = null;
      }
    } catch (e) {
      _errorMessage = '获取信用详情失败';
      print('获取用户信用详情失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 获取我的额度
  Future<void> fetchMyCreditLimit() async {
    try {
      final result = await UserApi.getMyCreditLimit();
      if (result != null) {
        _myCreditLimit = result;
        _errorMessage = null;
      }
    } catch (e) {
      _errorMessage = '获取额度信息失败';
      print('获取我的额度失败: $e');
    }
  }
}
