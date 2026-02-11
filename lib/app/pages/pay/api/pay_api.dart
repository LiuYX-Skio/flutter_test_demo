import '../../../../network/network.dart';
import '../../home/models/user_models.dart';
import '../../order/models/order_models.dart';
import '../models/pay_models.dart';

class PayApi {
  static Future<void> payOrder({
    required Map<String, dynamic> data,
    void Function(ShopPayEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = true,
  }) {
    return HttpClient.instance.post<ShopPayEntity>(
      '/api/app/pay/payment',
      data: data,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
    );
  }

  static Future<void> payTest({
    required Map<String, dynamic> data,
    void Function(ShopPayEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = true,
  }) {
    return HttpClient.instance.post<ShopPayEntity>(
      '/api/app/pay/test-payment',
      data: data,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
    );
  }

  static Future<void> createOrder({
    required Map<String, dynamic> data,
    void Function(OrderNoResultEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = true,
  }) {
    return HttpClient.instance.post<OrderNoResultEntity>(
      '/api/app/order/create',
      data: data,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
    );
  }

  static Future<void> recallMonthMoney({
    required Map<String, dynamic> data,
    void Function(MonthPayRecallEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = true,
  }) {
    return HttpClient.instance.post<MonthPayRecallEntity>(
      '/api/app/user-credit/repayment',
      data: data,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
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

