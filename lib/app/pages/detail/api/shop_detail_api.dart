import '../../../../network/network.dart';
import '../models/shop_detail_models.dart';
import '../../home/models/product_models.dart';
import '../../home/models/address_models.dart';

/// 商品详情 API 接口
class ShopDetailApi {
  /// 获取商品详情
  static Future<void> getShopDetail({
    required int id,
    void Function(ShopDetailEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<ShopDetailEntity>(
      '/api/app/product/detail/$id',
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 获取商品评论列表
  static Future<void> getShopCommentList({
    required int id,
    int page = 1,
    int limit = 10,
    void Function(ShopCommentOutEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<ShopCommentOutEntity>(
      '/api/app/reply/list/$id',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
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

  /// 添加购物车
  static Future<void> addShopCart({
    required int cartNum,
    required String productId,
    required String productAttrUnique,
    void Function(Map<String, dynamic>? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<Map<String, dynamic>>(
      '/api/app/cart/add',
      data: {
        'cartNum': cartNum.toString(),
        'productId': productId,
        'productAttrUnique': productAttrUnique,
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 收藏商品
  static Future<void> collectShop({
    required String category,
    required String id,
    void Function(String? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<String>(
      '/api/app/collect/add',
      data: {
        'category': category,
        'id': id,
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 取消收藏商品
  static Future<void> unCollectShop({
    required String productId,
    void Function(String? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<String>(
      '/api/app/collect/del',
      data: {
        'productId': productId,
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 获取购物车数量
  static Future<void> getShopCartSum({
    void Function(ShopCarSumEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<ShopCarSumEntity>(
      '/api/app/cart/count',
      queryParameters: {
        'numType': 'true',
        'type': 'sum',
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 获取推荐商品列表
  static Future<void> getRecommendList({
    int page = 1,
    int limit = 10,
    void Function(ShopOutEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<ShopOutEntity>(
      '/api/app/product/list',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
