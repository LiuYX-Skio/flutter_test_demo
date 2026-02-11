import 'package:flutter/foundation.dart';
import '../../mine/models/address_models.dart';
import '../api/order_api.dart';
import '../models/order_models.dart';

class ConfigOrderViewModel extends ChangeNotifier {
  ConfigOrderOutEntity? _orderOut;
  UserAddressEntity? _address;
  ConfigOrderPriceEntity? _price;
  bool _loading = false;

  ConfigOrderOutEntity? get orderOut => _orderOut;
  UserAddressEntity? get address => _address;
  ConfigOrderPriceEntity? get price => _price;
  bool get isLoading => _loading;

  void setAddress(UserAddressEntity? address) {
    _address = address;
    notifyListeners();
  }

  Future<void> loadOrderDetail({
    required List<ConfigOrderDeliveryEntity> items,
    String? addressId,
    String? preOrderType,
  }) async {
    _loading = true;
    notifyListeners();
    final orderData = _buildLoadOrderPayload(items, preOrderType);
    await OrderApi.loadOrder(
      data: orderData,
      onSuccess: (data) {
        _orderOut = data;
      },
    );
    if (addressId == null || addressId.isEmpty) {
      await OrderApi.defaultAddress(onSuccess: (data) {
        _address = data;
      });
    } else {
      await OrderApi.addressDetail(
        addressId: addressId,
        onSuccess: (data) {
          _address = data;
        },
      );
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> orderPrice({
    String? addressId,
    String? couponId,
    String? preOrderNo,
    String? shippingType,
  }) async {
    final data = <String, dynamic>{};
    if (addressId != null && addressId.isNotEmpty) {
      data['addressId'] = addressId;
    }
    if (couponId != null && couponId.isNotEmpty) {
      data['couponId'] = couponId;
    }
    if (preOrderNo != null && preOrderNo.isNotEmpty) {
      data['preOrderNo'] = preOrderNo;
    }
    if (shippingType != null && shippingType.isNotEmpty) {
      data['shippingType'] = shippingType;
    }
    await OrderApi.orderPrice(
      data: data,
      onSuccess: (data) {
        _price = data;
        notifyListeners();
      },
    );
  }

  Future<void> createOrder({
    String? addressId,
    String? couponId,
    String? mark,
    String? payChannel,
    String? payType,
    String? phone,
    String? realName,
    String? shippingType,
    String? preOrderNo,
    String? storeId,
    String? preOrderType,
    required List<ConfigOrderDeliveryEntity> items,
    void Function(OrderNoResultEntity? data)? onSuccess,
  }) async {
    final data = <String, dynamic>{};
    if (addressId != null && addressId.isNotEmpty) {
      data['addressId'] = addressId;
    }
    if (couponId != null && couponId.isNotEmpty) {
      data['couponId'] = couponId;
    }
    if (mark != null && mark.isNotEmpty) {
      data['mark'] = mark;
    }
    if (payChannel != null && payChannel.isNotEmpty) {
      data['payChannel'] = payChannel;
    }
    if (payType != null && payType.isNotEmpty) {
      data['payType'] = payType;
    }
    if (phone != null && phone.isNotEmpty) {
      data['phone'] = phone;
    }
    if (realName != null && realName.isNotEmpty) {
      data['realName'] = realName;
    }
    if (storeId != null && storeId.isNotEmpty) {
      data['storeId'] = storeId;
    }
    if (preOrderNo != null && preOrderNo.isNotEmpty) {
      data['preOrderNo'] = preOrderNo;
    }
    if (shippingType != null && shippingType.isNotEmpty) {
      data['shippingType'] = shippingType;
    }
    data['mark'] = '';
    data['useIntegral'] = false;
    data['preOrderRequest'] = _buildLoadOrderPayload(items, preOrderType);
    await OrderApi.createOrder(
      data: data,
      onSuccess: onSuccess,
    );
  }

  Future<void> loadOrder({
    required List<ConfigOrderDeliveryEntity> items,
    String? preOrderType,
  }) async {
    final orderData = _buildLoadOrderPayload(items, preOrderType);
    await OrderApi.loadOrder(
      data: orderData,
      onSuccess: (data) {
        _orderOut = data;
        notifyListeners();
      },
    );
  }

  Map<String, dynamic> _buildLoadOrderPayload(
    List<ConfigOrderDeliveryEntity> items,
    String? preOrderType,
  ) {
    final orderDetails = items.map((e) {
      final json = <String, dynamic>{};
      if (e.attrValueId != null && e.attrValueId!.isNotEmpty) {
        json['attrValueId'] = e.attrValueId;
      }
      if (e.orderNo != null && e.orderNo!.isNotEmpty) {
        json['orderNo'] = e.orderNo;
      }
      if (e.productId != null && e.productId!.isNotEmpty) {
        json['productId'] = e.productId;
      }
      if (e.productNum > 0) {
        json['productNum'] = e.productNum.toString();
      }
      if (e.shoppingCartId != null && e.shoppingCartId!.isNotEmpty) {
        json['shoppingCartId'] = e.shoppingCartId;
      }
      return json;
    }).toList();
    final data = <String, dynamic>{
      'orderDetails': orderDetails,
    };
    if (preOrderType != null && preOrderType.isNotEmpty) {
      data['preOrderType'] = preOrderType;
    }
    return data;
  }
}
