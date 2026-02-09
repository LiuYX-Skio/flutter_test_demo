
import 'package:flutter_test_demo/app/models/splash_models.dart';
import 'package:flutter_test_demo/network/api_exception.dart';
import 'package:flutter_test_demo/network/http_client.dart';

/// 启动页 API 接口
class SplashApi {
  /// 获取启动图片
  static Future<void> getSplashImage({
     void Function(String? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<String>(
      '/api/app/index/get-app-load',
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 检查应用更新
  static Future<void> checkAppUpdate({
    void Function(AppUpdateEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<AppUpdateEntity>(
      '/api/app/system/last-update',
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

  /// 获取 IP 地址
  static Future<void> getIpAddress({
    void Function(IpAddressEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<IpAddressEntity>(
      '/api/index?ip&type=0',
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
