import '../../../../network/network.dart';
import '../models/home_models.dart';
import '../models/product_models.dart';

/// 首页 API 接口
class HomeApi {
  /// 获取首页数据
  /// 对应 Android: GET /api/app/index/data
  static Future<HomeTitleDataEntity?> getHomeData() async {
    try {
      final result = await HttpClient.instance.get<HomeTitleDataEntity>(
        '/api/app/index/data',
      );
      return result;
    } catch (e) {
      print('获取首页数据失败: $e');
      return null;
    }
  }

  /// 获取推荐商品列表
  /// 对应 Android: GET /api/app/index/premiumList
  static Future<ShopOutEntity<ProductEntity>?> getHomeRecommendList({
    required int page,
    int limit = 10,
  }) async {
    try {
      final result = await HttpClient.instance.get<ShopOutEntity<ProductEntity>>(
        '/api/app/index/premiumList',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return result;
    } catch (e) {
      print('获取推荐商品列表失败: $e');
      return null;
    }
  }

  /// 获取排行榜列表
  /// 对应 Android: GET /api/app/index/ranking
  static Future<ShopOutEntity<ProductEntity>?> getSortShopList({
    required int page,
    int limit = 10,
  }) async {
    try {
      final result = await HttpClient.instance.get<ShopOutEntity<ProductEntity>>(
        '/api/app/index/ranking',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return result;
    } catch (e) {
      print('获取排行榜列表失败: $e');
      return null;
    }
  }
}
