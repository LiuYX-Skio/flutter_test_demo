import '../../../../network/network.dart';
import '../models/product_models.dart';

/// 商品 API 接口
class ProductApi {
  /// 获取热门商品
  /// 对应 Android: GET /api/app/product/hot
  static Future<ShopOutEntity<ProductEntity>?> getHotProducts({
    required int page,
    int limit = 10,
  }) async {
    try {
      final result = await HttpClient.instance.get<ShopOutEntity<ProductEntity>>(
        '/api/app/product/hot',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return result;
    } catch (e) {
      print('获取热门商品失败: $e');
      return null;
    }
  }
}
