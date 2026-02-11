import 'package:flutter/material.dart';
import '../../../provider/user_provider.dart';
import '../api/wallet_api.dart';
import '../models/mine_models.dart';

/// 钱包相关 ViewModel
class WalletViewModel extends ChangeNotifier {
  WithDrawUserInfo? _withDrawUserInfo;
  List<WithDrawRecord> _records = [];
  bool _isLoading = false;
  String? _errorMessage;

  WithDrawUserInfo? get withDrawUserInfo => _withDrawUserInfo;
  List<WithDrawRecord> get records => _records;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 获取取现用户信息
  Future<void> fetchWithDrawUserInfo({bool showLoading = true}) async {
    _isLoading = showLoading;
    notifyListeners();

    await WalletApi.getWithDrawUserInfo(
      onSuccess: (data) {
        _withDrawUserInfo = data;
        if (data?.nowMoney != null) {
          UserProvider.setUserMoney(data!.nowMoney);
        }
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
      },
      onError: (exception) {
        _errorMessage = '获取取现信息失败';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// 获取取现记录
  Future<void> fetchWithDrawRecord({bool showLoading = true}) async {
    _isLoading = showLoading;
    notifyListeners();

    await WalletApi.getWithDrawRecord(
      onSuccess: (data) {
        _records = data?.list ?? [];
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
      },
      onError: (exception) {
        _errorMessage = '获取取现记录失败';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// 提交取现
  Future<void> submitWithDraw({
    required String account,
    required String realName,
    required String money,
    String passWord = '',
    required VoidCallback onSuccess,
  }) async {
    await WalletApi.withDraw(
      account: account,
      realName: realName,
      money: money,
      passWord: passWord,
      onSuccess: (_) {
        onSuccess();
      },
      onError: (exception) {
        _errorMessage = '取现申请失败';
        notifyListeners();
      },
    );
  }

  /// 备用金取用
  Future<BackUpDrawEntity?> submitBackUpMoney({
    required String account,
    required String realName,
    required String money,
    String passWord = '',
    String? purpose,
  }) async {
    BackUpDrawEntity? result;
    await WalletApi.takeBackUpMoney(
      account: account,
      realName: realName,
      money: money,
      passWord: passWord,
      purpose: purpose,
      onSuccess: (data) {
        result = data;
      },
      onError: (exception) {
        _errorMessage = '备用金申请失败';
        notifyListeners();
      },
    );
    return result;
  }
}
