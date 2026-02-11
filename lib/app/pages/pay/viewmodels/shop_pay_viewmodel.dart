import 'package:flutter/foundation.dart';
import '../../home/models/user_models.dart';
import '../api/pay_api.dart';
import '../services/pay_sdk_service.dart';

class ShopPayViewModel extends ChangeNotifier {
  static const int viewTypeOrderPay = 1;
  static const int viewTypeRecallPay = 2;

  static const int payTypeAliPay = 1;
  static const int payTypeMonthPay = 2;
  static const int payTypeBalance = 3;
  static const int payTypeAliPayHb = 4;
  static const int payTypeWx = 5;

  int _payType = payTypeWx;
  bool _isPaying = false;
  String? _errorMessage;
  UserCreditEntity? _userCreditEntity;

  int get payType => _payType;
  bool get isPaying => _isPaying;
  String? get errorMessage => _errorMessage;
  UserCreditEntity? get userCreditEntity => _userCreditEntity;

  void updatePayType(int type) {
    _payType = type;
    notifyListeners();
  }

  Future<void> userCreditDetail() async {
    await PayApi.userCreditDetail(
      onSuccess: (data) {
        _userCreditEntity = data;
        notifyListeners();
      },
      onError: (exception) {
        _errorMessage = exception.message;
        notifyListeners();
      },
    );
  }

  Future<bool> submitOrderPay({
    required String orderNo,
    String? orderId,
    int stageNum = 0,
    String? password,
  }) async {
    _isPaying = true;
    _errorMessage = null;
    notifyListeners();

    final payload = <String, dynamic>{
      'from': 'app',
      'orderNo': orderNo,
    };
    if ((password ?? '').isNotEmpty) {
      payload['payPassword'] = password;
    }

    switch (_payType) {
      case payTypeAliPayHb:
        payload['payChannel'] = 'appAliPay';
        payload['payType'] = 'alipay_stages';
        payload['stagesNumber'] = stageNum.toString();
        break;
      case payTypeAliPay:
        payload['payChannel'] = 'appAliPay';
        payload['payType'] = 'alipay';
        break;
      case payTypeMonthPay:
        payload['payChannel'] = 'AndroidApp';
        payload['payType'] = 'credit';
        break;
      case payTypeBalance:
        payload['payChannel'] = 'AndroidApp';
        payload['payType'] = 'yue';
        break;
      case payTypeWx:
      default:
        payload['payChannel'] = 'weixinAppAndroid';
        payload['payType'] = 'weixin';
        break;
    }

    bool success = false;
    await PayApi.payOrder(
      data: payload,
      onSuccess: (data) async {
        if (data == null) return;
        if (_payType == payTypeAliPay || _payType == payTypeAliPayHb) {
          final sdkResult = await PaySdkService.pay(
            type: PaySdkType.alipay,
            aliPayOrderInfo: data.alipayRequest,
          );
          success = sdkResult.success;
          if (!sdkResult.success) {
            _errorMessage = sdkResult.message;
          }
        } else if (_payType == payTypeWx) {
          final sdkResult = await PaySdkService.pay(
            type: PaySdkType.wechat,
            wxConfig: data.jsConfig,
          );
          success = sdkResult.success;
          if (!sdkResult.success) {
            _errorMessage = sdkResult.message;
          }
        } else {
          success = true;
        }
      },
      onError: (exception) {
        _errorMessage = exception.message;
      },
    );

    _isPaying = false;
    notifyListeners();
    return success;
  }

  Future<bool> submitRecallPay({
    required String billMonthItem,
    required String money,
  }) async {
    _isPaying = true;
    _errorMessage = null;
    notifyListeners();

    final payChannel = _payType == payTypeWx ? 'weixinAppAndroid' : 'alipay';

    bool success = false;
    await PayApi.recallMonthMoney(
      data: {
        'billMonthItem': billMonthItem,
        'money': money,
        'payChannel': payChannel,
      },
      onSuccess: (data) async {
        if (data == null) return;
        if (_payType == payTypeWx) {
          final sdkResult = await PaySdkService.pay(
            type: PaySdkType.wechat,
            wxConfig: data.jsConfig,
          );
          success = sdkResult.success;
          if (!sdkResult.success) {
            _errorMessage = sdkResult.message;
          }
        } else {
          final sdkResult = await PaySdkService.pay(
            type: PaySdkType.alipay,
            aliPayOrderInfo: data.alipayRequest,
          );
          success = sdkResult.success;
          if (!sdkResult.success) {
            _errorMessage = sdkResult.message;
          }
        }
      },
      onError: (exception) {
        _errorMessage = exception.message;
      },
    );
    _isPaying = false;
    notifyListeners();
    return success;
  }

  Future<bool> submitTestPay({
    required String money,
  }) async {
    _isPaying = true;
    _errorMessage = null;
    notifyListeners();

    final payload = <String, dynamic>{
      'money': money,
      'payChannel': _payType == payTypeWx ? 'weixinAppAndroid' : 'appAliPay',
      'payType': _payType == payTypeWx ? 'weixin' : 'alipay',
    };
    bool success = false;
    await PayApi.payTest(
      data: payload,
      onSuccess: (data) async {
        if (data == null) return;
        if (_payType == payTypeWx) {
          final sdkResult = await PaySdkService.pay(
            type: PaySdkType.wechat,
            wxConfig: data.jsConfig,
          );
          success = sdkResult.success;
          if (!sdkResult.success) {
            _errorMessage = sdkResult.message;
          }
        } else {
          final sdkResult = await PaySdkService.pay(
            type: PaySdkType.alipay,
            aliPayOrderInfo: data.alipayRequest,
          );
          success = sdkResult.success;
          if (!sdkResult.success) {
            _errorMessage = sdkResult.message;
          }
        }
      },
      onError: (exception) {
        _errorMessage = exception.message;
      },
    );

    _isPaying = false;
    notifyListeners();
    return success;
  }
}
