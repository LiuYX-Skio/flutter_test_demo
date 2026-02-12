import '../../../../network/network.dart';
import '../../home/models/product_models.dart';
import '../../home/models/user_models.dart';
import '../../mine/models/address_models.dart';
import '../models/order_models.dart';

class OrderApi {
  static Future<void> getOrderList({
    required int page,
    required int type,
    String? keywords,
    void Function(OrderOutEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = false,
  }) {
    final query = <String, dynamic>{
      'limit': 12,
      'page': page,
      'type': type,
    };
    if (keywords != null && keywords.isNotEmpty) {
      query['keywords'] = keywords;
    }
    return HttpClient.instance.get<OrderOutEntity>(
      '/api/app/order/list',
      queryParameters: query,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
    );
  }

  static Future<void> orderRefund({
    required int id,
    required String? orderId,
    String? text,
    void Function(bool? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    final data = {
      'id': id,
      'uni': orderId ?? '',
      'text': text ?? '订单退款',
    };
    return HttpClient.instance.post<bool>(
      '/api/app/order/refund',
      data: data,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> takeOrder({
    required int id,
    void Function(bool? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<bool>(
      '/api/app/order/take',
      data: {'id': id},
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> deleteOrder({
    required int id,
    void Function(bool? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<bool>(
      '/api/app/order/del',
      data: {'id': id},
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> cancelOrder({
    required int id,
    void Function(bool? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<bool>(
      '/api/app/order/cancel',
      data: {'id': id},
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> updateOrderAddress({
    required String addressId,
    required String orderId,
    void Function(bool? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    final data = {
      'addressId': addressId,
      'orderId': orderId,
    };
    return HttpClient.instance.post<bool>(
      '/api/app/order/updateAddress',
      data: data,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> getRecommendList({
    required int page,
    void Function(ShopOutEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<ShopOutEntity>(
      '/api/app/product/hot',
      queryParameters: {
        'limit': 60,
        'page': page,
      },
      onSuccess: onSuccess,
      onError: onError,
      showLoading: false,
    );
  }

  static Future<void> getOrderDetail({
    required String orderNo,
    void Function(OrderDetailEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = true,
  }) {
    return HttpClient.instance.get<OrderDetailEntity>(
      '/api/app/order/detail/$orderNo',
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
    );
  }

  static Future<void> addShopCar({
    required int carSum,
    required String productId,
    required String productAttrUnique,
    void Function(bool? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    final data = {
      'cartNum': carSum,
      'productId': productId,
      'productAttrUnique': productAttrUnique,
    };
    return HttpClient.instance.post<bool>(
      '/api/app/cart/save',
      data: data,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> updateShopCarSum({
    required String id,
    required int number,
    void Function(String? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<String>(
      '/api/app/cart/num',
      queryParameters: {
        'id': id,
        'number': number.toString(),
      },
      onSuccess: onSuccess,
      onError: onError,
      showLoading: false,
    );
  }

  static Future<void> commentOrder({
    required String comment,
    String? pics,
    required String productId,
    required String orderNo,
    required int serviceScore,
    void Function(bool? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    final data = <String, dynamic>{
      'comment': comment,
      'productId': productId,
      'orderNo': orderNo,
      'productScore': serviceScore.toString(),
      'serviceScore': serviceScore.toString(),
    };
    if (pics != null && pics.isNotEmpty) {
      data['pics'] = pics;
    }
    return HttpClient.instance.post<bool>(
      '/api/app/order/comment',
      data: data,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> loadOrder({
    required Map<String, dynamic> data,
    void Function(ConfigOrderOutEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = true,
  }) {
    return HttpClient.instance.post<ConfigOrderOutEntity>(
      '/api/app/order/v2/load-order',
      data: data,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
    );
  }

  static Future<void> loadPreOrder({
    required String preOrderNo,
    void Function(ConfigOrderOutEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<ConfigOrderOutEntity>(
      '/api/app/order/load/pre/$preOrderNo',
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> orderPrice({
    required Map<String, dynamic> data,
    void Function(ConfigOrderPriceEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<ConfigOrderPriceEntity>(
      '/api/app/order/computed/price',
      data: data,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> createOrder({
    required Map<String, dynamic> data,
    void Function(OrderNoResultEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<OrderNoResultEntity>(
      '/api/app/order/create',
      data: data,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> defaultAddress({
    void Function(UserAddressEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<UserAddressEntity>(
      '/api/app/address/default',
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> addressDetail({
    required String addressId,
    void Function(UserAddressEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<UserAddressEntity>(
      '/api/app/address/detail/$addressId',
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }
}

class GoldApi {
  static Future<void> recycleOrder({
    required String id,
    required Map<String, dynamic> data,
    void Function(GoldRecycleEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<GoldRecycleEntity>(
      '/api/app/front/gold/recycle/complete/$id',
      data: data,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> canRecycleOrder({
    required int page,
    required String recycleType,
    void Function(GoldOutEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<GoldOutEntity>(
      '/api/app/front/gold/recycle/list',
      queryParameters: {
        'recycleType': recycleType,
        'limit': 12,
        'page': page,
      },
      onSuccess: onSuccess,
      onError: onError,
      showLoading: false,
    );
  }

  static Future<void> recycleOrderDetail({
    required String id,
    void Function(RecycleShopEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<RecycleShopEntity>(
      '/api/app/front/gold/recycle/detail/$id',
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> cancelRecycleOrder({
    required String id,
    void Function(String? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<String>(
      '/api/app/front/gold/recycle/cancel/$id',
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> phoneRecycleOrder({
    required Map<String, dynamic> data,
    void Function(PhoneRecycleEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<PhoneRecycleEntity>(
      '/api/app/front/gold/recycle/phone/submit',
      data: data,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: true,
    );
  }

  static Future<void> goldPrice({
    void Function(String? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = false,
  }) {
    return HttpClient.instance.get<String>(
      '/api/app/front/gold/recycle/gold-price',
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
    );
  }

  static Future<void> recycleOrderList({
    required int page,
    required int status,
    required String recycleType,
    void Function(RecycleShopOutEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<RecycleShopOutEntity>(
      '/api/app/front/gold/recycle/list',
      queryParameters: {
        'recycleType': recycleType,
        'status': status,
        'limit': 12,
        'page': page,
      },
      onSuccess: onSuccess,
      onError: onError,
      showLoading: false,
    );
  }

  static Future<void> userCreditDetail({
    void Function(UserCreditEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = true,
  }) {
    return HttpClient.instance.get<UserCreditEntity>(
      '/api/app/user-credit/user-credit',
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
    );
  }
}
