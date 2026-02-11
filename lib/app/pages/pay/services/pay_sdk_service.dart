import '../models/pay_models.dart';

enum PaySdkType { alipay, wechat }

class PaySdkResult {
  final bool success;
  final String? message;

  const PaySdkResult({
    required this.success,
    this.message,
  });
}

/// 支付 SDK 适配层
/// 注意：按需求此处保留空实现，后续由业务方接入真实 SDK。
class PaySdkService {
  static Future<PaySdkResult> pay({
    required PaySdkType type,
    String? aliPayOrderInfo,
    WxPayEntity? wxConfig,
  }) async {
    return const PaySdkResult(
      success: false,
      message: '支付SDK尚未接入',
    );
  }
}

