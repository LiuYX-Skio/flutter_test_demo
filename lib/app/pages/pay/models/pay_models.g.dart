// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_models.dart';

WxPayEntity _$WxPayEntityFromJson(Map<String, dynamic> json) => WxPayEntity(
      appId: AppDataUtils.toStringValue(json['appId']),
      nonceStr: AppDataUtils.toStringValue(json['nonceStr']),
      packages: AppDataUtils.toStringValue(json['packages']),
      timeStamp: AppDataUtils.toStringValue(json['timeStamp']),
      paySign: AppDataUtils.toStringValue(json['paySign']),
      partnerid: AppDataUtils.toStringValue(json['partnerid']),
      outTradeNo: AppDataUtils.toStringValue(json['outTradeNo']),
      prepayId: AppDataUtils.toStringValue(json['prepayId']),
    );

Map<String, dynamic> _$WxPayEntityToJson(WxPayEntity instance) =>
    <String, dynamic>{
      'appId': instance.appId,
      'nonceStr': instance.nonceStr,
      'packages': instance.packages,
      'timeStamp': instance.timeStamp,
      'paySign': instance.paySign,
      'partnerid': instance.partnerid,
      'outTradeNo': instance.outTradeNo,
      'prepayId': instance.prepayId,
    };

ShopPayEntity _$ShopPayEntityFromJson(Map<String, dynamic> json) =>
    ShopPayEntity(
      aliPayConfig: json['aliPayConfig'] as Map<String, dynamic>?,
      orderNo: AppDataUtils.toStringValue(json['orderNo']),
      alipayRequest: AppDataUtils.toStringValue(json['alipayRequest']),
      payType: AppDataUtils.toStringValue(json['payType']),
      status: AppDataUtils.toBool(json['status']) ?? false,
      jsConfig: json['jsConfig'] is! Map<String, dynamic>
          ? null
          : WxPayEntity.fromJson(json['jsConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShopPayEntityToJson(ShopPayEntity instance) =>
    <String, dynamic>{
      'aliPayConfig': instance.aliPayConfig,
      'orderNo': instance.orderNo,
      'alipayRequest': instance.alipayRequest,
      'payType': instance.payType,
      'status': instance.status,
      'jsConfig': instance.jsConfig,
    };

MonthPayRecallEntity _$MonthPayRecallEntityFromJson(
        Map<String, dynamic> json) =>
    MonthPayRecallEntity(
      alipayRequest: AppDataUtils.toStringValue(json['alipayRequest']),
      orderNo: AppDataUtils.toStringValue(json['orderNo']),
      jsConfig: json['jsConfig'] is! Map<String, dynamic>
          ? null
          : WxPayEntity.fromJson(json['jsConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MonthPayRecallEntityToJson(
        MonthPayRecallEntity instance) =>
    <String, dynamic>{
      'alipayRequest': instance.alipayRequest,
      'orderNo': instance.orderNo,
      'jsConfig': instance.jsConfig,
    };
