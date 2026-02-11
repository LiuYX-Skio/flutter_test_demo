import '../../../../network/network.dart';
import '../models/mine_models.dart';

/// 钱包相关 API 接口
class WalletApi {
  /// 取现用户信息
  static Future<void> getWithDrawUserInfo({
    void Function(WithDrawUserInfo? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<WithDrawUserInfo>(
      '/api/app/user/finance/extract/user',
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 取现记录
  static Future<void> getWithDrawRecord({
    void Function(WithDrawRecordShell? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<WithDrawRecordShell>(
      '/api/app/user/finance/extract/record',
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 发起取现申请
  static Future<void> withDraw({
    required String account,
    required String realName,
    required String money,
    String passWord = '',
    void Function(String? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<String>(
      '/api/app/user/finance/withdraw-apply',
      data: {
        'account': account,
        'money': money,
        'realName': realName,
        'passWord': passWord,
      },
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 备用金取用
  static Future<void> takeBackUpMoney({
    required String account,
    required String realName,
    required String money,
    String passWord = '',
    String? purpose,
    void Function(BackUpDrawEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    final data = <String, dynamic>{
      'account': account,
      'money': money,
      'realName': realName,
      'passWord': passWord,
    };
    if ((purpose ?? '').isNotEmpty) {
      data['purpose'] = purpose;
    }
    return HttpClient.instance.post<BackUpDrawEntity>(
      '/api/app/user/finance/withdraw-petty',
      data: data,
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
