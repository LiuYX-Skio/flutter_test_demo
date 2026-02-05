import '../../../../network/network.dart';
import '../models/home_models.dart';
import '../models/product_models.dart';

/// 首页 API 接口
class HomeApi {
  /// 获取首页数据
  static Future<void> getHomeData({
    void Function(HomeTitleDataEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<HomeTitleDataEntity>(
      '/api/app/index/data',
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 获取推荐商品列表
  static Future<void> getHomeRecommendList({
    required int page,
    int limit = 10,
    void Function(ShopOutEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<ShopOutEntity>(
      '/api/app/index/premiumList',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 获取排行榜列表
  static Future<void> getSortShopList({
    required int page,
    int limit = 10,
    void Function(ShopOutEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<ShopOutEntity>(
      '/api/app/index/ranking',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
