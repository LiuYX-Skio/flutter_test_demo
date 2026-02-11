import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../home/api/user_api.dart';
import '../api/order_api.dart';
import '../models/order_models.dart';

class OrderDetailViewModel extends ChangeNotifier {
  OrderDetailEntity? _detail;
  bool _loading = false;

  OrderDetailEntity? get detail => _detail;
  bool get isLoading => _loading;

  Future<void> fetchOrderDetail(String orderNo, {bool showLoading = true}) async {
    _loading = true;
    notifyListeners();
    await OrderApi.getOrderDetail(
      orderNo: orderNo,
      showLoading: showLoading,
      onSuccess: (data) {
        _detail = data;
      },
    );
    _loading = false;
    notifyListeners();
  }

  Future<void> addShopCar({
    required int carSum,
    required String productId,
    required String productAttrUnique,
    void Function(bool success)? onResult,
  }) async {
    await OrderApi.addShopCar(
      carSum: carSum,
      productId: productId,
      productAttrUnique: productAttrUnique,
      onSuccess: (data) => onResult?.call(data == true),
    );
  }

  Future<void> commentOrder({
    required String comment,
    String? pics,
    required String productId,
    required String orderNo,
    required int serviceScore,
    void Function(bool success)? onResult,
  }) async {
    await OrderApi.commentOrder(
      comment: comment,
      pics: pics,
      productId: productId,
      orderNo: orderNo,
      serviceScore: serviceScore,
      onSuccess: (data) => onResult?.call(data == true),
    );
  }

  Future<void> uploadImage({
    required File file,
    void Function(String? url)? onResult,
  }) async {
    await UserApi.uploadImage(
      filePath: file.path,
      onSuccess: (data) => onResult?.call(data?.url),
    );
  }
}
