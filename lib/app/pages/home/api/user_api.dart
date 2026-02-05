import '../../../../network/network.dart';
import '../models/user_models.dart';
import '../models/address_models.dart';

/// 用户 API 接口
class UserApi {
  /// 获取用户信息
  /// 对应 Android: GET /api/app/user/user
  static Future<UserInfoEntity?> getUserInfo() async {
    try {
      final result = await HttpClient.instance.get<UserInfoEntity>(
        '/api/app/user/user',
      );
      return result;
    } catch (e) {
      print('获取用户信息失败: $e');
      return null;
    }
  }

  /// 获取默认地址
  /// 对应 Android: GET /api/app/address/default
  static Future<AddressEntity?> getDefaultAddress() async {
    try {
      final result = await HttpClient.instance.get<AddressEntity>(
        '/api/app/address/default',
      );
      return result;
    } catch (e) {
      print('获取默认地址失败: $e');
      return null;
    }
  }

  /// 获取用户信用详情
  /// 对应 Android: GET /api/app/user-credit/user-credit
  static Future<UserCreditEntity?> getUserCreditDetail() async {
    try {
      final result = await HttpClient.instance.get<UserCreditEntity>(
        '/api/app/user-credit/user-credit',
      );
      return result;
    } catch (e) {
      print('获取用户信用详情失败: $e');
      return null;
    }
  }

  /// 获取我的额度
  /// 对应 Android: GET /api/app/user-credit/my-credit
  static Future<MyCreditEntity?> getMyCreditLimit() async {
    try {
      final result = await HttpClient.instance.get<MyCreditEntity>(
        '/api/app/user-credit/my-credit',
      );
      return result;
    } catch (e) {
      print('获取我的额度失败: $e');
      return null;
    }
  }
}
