import 'package:flutter/foundation.dart';
import '../../home/models/user_models.dart';
import '../api/order_api.dart';
import '../models/order_models.dart';

class GoldViewModel extends ChangeNotifier {
  List<RecycleShopEntity> _recycleOrders = [];
  List<GoldEntity> _canRecycleOrders = [];
  RecycleShopEntity? _detail;
  String? _goldPrice;
  UserCreditEntity? _userCredit;

  List<RecycleShopEntity> get recycleOrders => List.unmodifiable(_recycleOrders);
  List<GoldEntity> get canRecycleOrders => List.unmodifiable(_canRecycleOrders);
  RecycleShopEntity? get detail => _detail;
  String? get goldPrice => _goldPrice;
  UserCreditEntity? get userCredit => _userCredit;

  Future<void> fetchGoldPrice({bool showLoading = false}) async {
    await GoldApi.goldPrice(
      showLoading: showLoading,
      onSuccess: (data) {
        _goldPrice = data;
        notifyListeners();
      },
    );
  }

  Future<void> fetchCanRecycleOrders({
    required int page,
    required String recycleType,
  }) async {
    await GoldApi.canRecycleOrder(
      page: page,
      recycleType: recycleType,
      onSuccess: (data) {
        if (page == 1) {
          _canRecycleOrders = data?.list?.whereType<GoldEntity>().toList() ?? [];
        } else {
          _canRecycleOrders.addAll(
              data?.list?.whereType<GoldEntity>().toList() ?? []);
        }
        notifyListeners();
      },
    );
  }

  Future<void> fetchRecycleOrderList({
    required int page,
    required int status,
    required String recycleType,
  }) async {
    await GoldApi.recycleOrderList(
      page: page,
      status: status,
      recycleType: recycleType,
      onSuccess: (data) {
        if (page == 1) {
          _recycleOrders =
              data?.list?.whereType<RecycleShopEntity>().toList() ?? [];
        } else {
          _recycleOrders.addAll(
              data?.list?.whereType<RecycleShopEntity>().toList() ?? []);
        }
        notifyListeners();
      },
    );
  }

  Future<void> fetchRecycleOrderDetail(String id) async {
    await GoldApi.recycleOrderDetail(
      id: id,
      onSuccess: (data) {
        _detail = data;
        notifyListeners();
      },
    );
  }

  Future<void> cancelRecycleOrder({
    required String id,
    void Function(String? data)? onSuccess,
  }) async {
    await GoldApi.cancelRecycleOrder(
      id: id,
      onSuccess: onSuccess,
    );
  }

  Future<void> recycleOrder({
    required String id,
    required String alipayAccount,
    required String orderInfoId,
    required String realName,
    String? senderName,
    String? senderPhone,
    String? expressNumber,
    String? goldWeight,
    void Function(GoldRecycleEntity? data)? onSuccess,
  }) async {
    final data = <String, dynamic>{
      'alipayAccount': alipayAccount,
      'orderInfoId': orderInfoId,
      'realName': realName,
    };
    if (senderName != null && senderName.isNotEmpty) {
      data['senderName'] = senderName;
    }
    if (senderPhone != null && senderPhone.isNotEmpty) {
      data['senderPhone'] = senderPhone;
    }
    if (expressNumber != null && expressNumber.isNotEmpty) {
      data['expressNumber'] = expressNumber;
    }
    if (goldWeight != null && goldWeight.isNotEmpty) {
      data['goldWeight'] = goldWeight;
    }
    await GoldApi.recycleOrder(
      id: id,
      data: data,
      onSuccess: onSuccess,
    );
  }

  Future<void> phoneRecycleOrder({
    required String recycleType,
    required String alipayAccount,
    required String realName,
    required String orderInfoId,
    void Function(PhoneRecycleEntity? data)? onSuccess,
  }) async {
    final data = <String, dynamic>{
      'recycleType': recycleType,
      'alipayAccount': alipayAccount,
      'realName': realName,
      'orderInfoId': orderInfoId,
    };
    await GoldApi.phoneRecycleOrder(
      data: data,
      onSuccess: onSuccess,
    );
  }

  Future<void> fetchUserCreditDetail({bool showLoading = true}) async {
    await GoldApi.userCreditDetail(
      showLoading: showLoading,
      onSuccess: (data) {
        _userCredit = data;
        notifyListeners();
      },
    );
  }
}
