import '../../../../network/network.dart';
import '../models/shop_models.dart';

/// 商品分类/列表 API
class ShopSortApi {
  /// 分页分类列表
  static Future<void> getSortList({
    void Function(ShopSortEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<ShopSortEntity>(
      '/api/app/category/list',
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 商品列表（分类）
  static Future<void> getShopList({
    required int page,
    required String cid,
    int limit = 10,
    void Function(ShopSortShopEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<ShopSortShopEntity>(
      '/api/app/products',
      queryParameters: {
        'cid': cid,
        'limit': limit.toString(),
        'page': page.toString(),
        'type': '111',
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 商品列表（搜索）
  static Future<void> searchShopList({
    required String keyword,
    int page = 1,
    int limit = 1000,
    void Function(ShopSortShopEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<ShopSortShopEntity>(
      '/api/app/products',
      queryParameters: {
        'keyword': keyword,
        'limit': limit.toString(),
        'page': page.toString(),
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}

