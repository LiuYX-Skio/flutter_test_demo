import 'package:json_annotation/json_annotation.dart';
import '../../../../navigation/utils/app_data_utils.dart';

part 'pay_models.g.dart';

@JsonSerializable()
class WxPayEntity {
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? appId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? nonceStr;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? packages;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? timeStamp;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? paySign;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? partnerid;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? outTradeNo;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? prepayId;

  const WxPayEntity({
    this.appId,
    this.nonceStr,
    this.packages,
    this.timeStamp,
    this.paySign,
    this.partnerid,
    this.outTradeNo,
    this.prepayId,
  });

  factory WxPayEntity.fromJson(Map<String, dynamic> json) =>
      _$WxPayEntityFromJson(json);

  Map<String, dynamic> toJson() => _$WxPayEntityToJson(this);
}

@JsonSerializable()
class ShopPayEntity {
  final Map<String, dynamic>? aliPayConfig;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? orderNo;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? alipayRequest;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? payType;
  @JsonKey(fromJson: AppDataUtils.toBool, defaultValue: false)
  final bool status;
  final WxPayEntity? jsConfig;

  const ShopPayEntity({
    this.aliPayConfig,
    this.orderNo,
    this.alipayRequest,
    this.payType,
    this.status = false,
    this.jsConfig,
  });

  factory ShopPayEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopPayEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopPayEntityToJson(this);
}

@JsonSerializable()
class MonthPayRecallEntity {
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? alipayRequest;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? orderNo;
  final WxPayEntity? jsConfig;

  const MonthPayRecallEntity({
    this.alipayRequest,
    this.orderNo,
    this.jsConfig,
  });

  factory MonthPayRecallEntity.fromJson(Map<String, dynamic> json) =>
      _$MonthPayRecallEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MonthPayRecallEntityToJson(this);
}
