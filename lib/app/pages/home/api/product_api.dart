import '../../../../network/network.dart';
import '../models/product_models.dart';

/// 商品 API 接口
class ProductApi {
  /// 获取热门商品
  static Future<void> getHotProducts({
    required int page,
    int limit = 10,
    void Function(ShopOutEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<ShopOutEntity>(
      '/api/app/product/hot',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
