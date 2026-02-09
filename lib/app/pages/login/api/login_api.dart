import 'package:flutter_test_demo/app/constants/app_constants.dart';
import 'package:flutter_test_demo/app/models/splash_models.dart';
import 'package:flutter_test_demo/app/provider/user_provider.dart';
import 'package:flutter_test_demo/network/http_client.dart';

import '../../../../network/api_exception.dart';
import '../models/login_models.dart';

/// 登录API接口 - 参照 splash_api.dart 的实现方式
class LoginApi {
  /// 发送短信验证码
  static Future<void> sendSmsCode({
    required String phone,
    void Function(String? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<String>(
      '/api/app/user/sendCode',
      queryParameters: {
        'phone': phone,
      },
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 手机号登录
  static Future<void> phoneLogin({
    required String phone,
    required String code,
    void Function(UserInfo? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<UserInfo>(
      '/api/app/user/login/mobile',
      data: {
        'phone': phone,
        'captcha': code,
        'channel': AppConstants.channelCode,
        'deviceModel': UserProvider.getDeviceModel(),
        'lastLoginIp': UserProvider.getLastIp(),
        'oaid': UserProvider.getOaid(),
        'invitationCode': UserProvider.getInviteCode(),
      },
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 获取用户信用详情
  static Future<void> getUserCreditDetail({
    void Function(UserCreditEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<UserCreditEntity>(
      '/api/app/user-credit/user-credit',
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
