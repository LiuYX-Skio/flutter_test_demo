import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test_demo/app/dialog/loading_manager.dart';
import 'package:flutter_test_demo/app/provider/user_provider.dart';
import '../../../../network/api_exception.dart';
import '../api/login_api.dart';
import '../models/login_models.dart';

/// 登录页面 ViewModel - 完全按照Android LoginViewModel实现
class LoginViewModel extends ChangeNotifier {
  // 表单数据
  String _phone = '';
  String _code = '';
  bool _isProtocolAgreed = false;

  // 状态管理
  bool _isLoading = false;
  String? _errorMessage;

  // 验证码倒计时
  int _codeCountdown = 0;
  Timer? _countdownTimer;

  // Getters
  String get phone => _phone;

  String get code => _code;

  bool get isProtocolAgreed => _isProtocolAgreed;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // 计算属性
  bool get canLogin =>
      _phone.isNotEmpty && _code.isNotEmpty && _isProtocolAgreed;

  bool get canSendCode => _codeCountdown == 0;

  String get sendCodeButtonText {
    if (_codeCountdown > 0) {
      return '${_codeCountdown}s后重新获取';
    }
    return '获取验证码';
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  /// 更新手机号
  void updatePhone(String phone) {
    _phone = phone;
    _clearError();
    notifyListeners();
  }

  /// 更新验证码
  void updateCode(String code) {
    _code = code;
    _clearError();
    notifyListeners();
  }

  /// 切换协议同意状态
  void toggleProtocolAgreement() {
    _isProtocolAgreed = !_isProtocolAgreed;
    _clearError();
    notifyListeners();
  }

  /// 验证手机号格式
  bool isValidPhoneNumber(String phone) {
    // 简单验证手机号格式（11位数字）
    final RegExp phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    return phoneRegex.hasMatch(phone);
  }

  /// 发送短信验证码
  Future<bool> sendSmsCode(String phone) async {
    _isLoading = true;
    _clearError();
    bool isSuccess = false;
    return LoginApi.sendSmsCode(
      phone: phone,
      onSuccess: (String? data) {
        _isLoading = false;
        isSuccess = true;
        notifyListeners();
      },
      onError: (ApiException exception) {
        _isLoading = false;
        isSuccess = false;
        _setError(exception.message);
        notifyListeners();
      },
    ).then((_) => isSuccess).catchError((_) => false);
  }

  /// 手机号登录
  Future<bool> phoneLogin({
    required String phone,
    required String code,
  }) async {
    _isLoading = true;
    bool isSuccess = false;
    _clearError();
    notifyListeners();

    return LoginApi.phoneLogin(
      phone: phone,
      code: code,
      onSuccess: (UserInfo? data) {
        _isLoading = false;
        if (data != null) {
          isSuccess = true;
          UserProvider.setUserToken(data.token);
          notifyListeners();
        } else {
          isSuccess = false;
          _setError('登录失败，请检查手机号和验证码');
          notifyListeners();
        }
      },
      onError: (ApiException exception) {
        _isLoading = false;
        isSuccess = false;
        _setError(exception.message);
        notifyListeners();
      },
    ).then((_) => isSuccess).catchError((_) => false);
  }

  /// 启动验证码倒计时
  void startCodeTimer() {
    _codeCountdown = 60; // DELAY_TIME_SUM = 60
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _codeCountdown--;
      if (_codeCountdown <= 0) {
        _codeCountdown = 0;
        timer.cancel();
      }
      notifyListeners();
    });

    notifyListeners();
  }

  /// 设置错误信息
  void setError(String message) {
    _setError(message);
  }

  /// 清除错误信息
  void clearError() {
    _clearError();
  }

  void _setError(String message) {
    _errorMessage = message;
    LoadingManager.instance.showToast(message);
  }

  void _clearError() {
    _errorMessage = null;
  }
}
