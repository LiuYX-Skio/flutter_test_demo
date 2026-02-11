import '../../../../network/network.dart';
import '../models/mine_models.dart';

/// 我的模块 API
class MineApi {
  /// 获取我的额度
  static Future<void> getMineCredit({
    void Function(MineCreditEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<MineCreditEntity>(
      '/api/app/user-credit/my-credit',
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 月付纪录
  static Future<void> getUserMonthPayList({
    required String year,
    required String month,
    void Function(UserMonthPayEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<UserMonthPayEntity>(
      '/api/app/user/user-credit-list',
      queryParameters: {
        'year': year,
        'month': month,
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
