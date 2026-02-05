import '../../network/network.dart';
import '../models/splash_models.dart';

/// 启动页 API 接口
class SplashApi {
  /// 获取启动图片
  /// 对应 Android: GET /api/app/index/get-app-load
  /// 网络框架自动提取 data 字段并转换为 String
  static Future<String?> getSplashImage() async {
    try {
      final result = await HttpClient.instance.get<String>(
        '/api/app/index/get-app-load',
      );
      return result;
    } catch (e) {
      print('获取启动图片失败: $e');
      return null;
    }
  }

  /// 检查应用更新
  /// 对应 Android: GET /api/app/system/last-update
  /// 网络框架自动提取 data 字段并转换为 AppUpdateEntity
  static Future<AppUpdateEntity?> checkAppUpdate() async {
    try {
      final result = await HttpClient.instance.get<AppUpdateEntity>(
        '/api/app/system/last-update',
      );
      return result;
    } catch (e) {
      print('检查应用更新失败: $e');
      return null;
    }
  }

  /// 获取用户信用详情
  /// 对应 Android: GET /api/app/user-credit/user-credit
  /// 网络框架自动提取 data 字段并转换为 UserCreditEntity
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

  /// 获取 IP 地址
  /// 对应 Android: GET /api/index?ip&type=0
  /// 网络框架自动转换为 IpAddressEntity
  static Future<IpAddressEntity?> getIpAddress() async {
    try {
      final result = await HttpClient.instance.get<IpAddressEntity>(
        '/api/index?ip&type=0',
      );
      return result;
    } catch (e) {
      print('获取 IP 地址失败: $e');
      return null;
    }
  }
}
