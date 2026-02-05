import '../../../../network/network.dart';
import '../models/user_models.dart';
import '../models/address_models.dart';

/// 用户 API 接口
class UserApi {
  /// 获取用户信息
  static Future<void> getUserInfo({
    void Function(UserInfoEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<UserInfoEntity>(
      '/api/app/user/user',
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 获取默认地址
  static Future<void> getDefaultAddress({
    void Function(AddressEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<AddressEntity>(
      '/api/app/address/default',
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

  /// 获取我的额度
  static Future<void> getMyCreditLimit({
    void Function(MyCreditEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<MyCreditEntity>(
      '/api/app/user-credit/my-credit',
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
