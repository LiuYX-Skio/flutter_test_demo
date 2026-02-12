import 'package:json_annotation/json_annotation.dart';
import '../../../../navigation/utils/app_data_utils.dart';

part 'order_models.g.dart';

@JsonSerializable()
class OrderOutEntity {
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? limit;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? page;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? total;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? totalPage;
  final List<OrderListEntity>? list;

  OrderOutEntity({
    this.limit,
    this.page,
    this.total,
    this.totalPage,
    this.list,
  });

  factory OrderOutEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderOutEntityFromJson(json);

  Map<String, dynamic> toJson() => _$OrderOutEntityToJson(this);
}

@JsonSerializable()
class OrderListEntity {
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? createTime;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? deliveryId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? deliveryName;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? deliveryType;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? id;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? offlinePayStatus;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? orderId;
  @JsonKey(fromJson: AppDataUtils.toBool)
  final bool? paid;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? payPostage;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? payPrice;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? payTime;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? refundStatus;
  final String? refundReason;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? shippingType;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? status;
  final String? statusPic;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? totalNum;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? type;
  final List<CartInfoEntity>? cartInfo;
  final List<OrderInfoListEntity>? orderInfoList;
  final StoreOrderEntity? storeOrder;

  OrderListEntity({
    this.createTime,
    this.deliveryId,
    this.deliveryName,
    this.deliveryType,
    this.id,
    this.offlinePayStatus,
    this.orderId,
    this.paid,
    this.payPostage,
    this.payPrice,
    this.payTime,
    this.refundStatus,
    this.refundReason,
    this.shippingType,
    this.status,
    this.statusPic,
    this.totalNum,
    this.type,
    this.cartInfo,
    this.orderInfoList,
    this.storeOrder,
  });

  factory OrderListEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$OrderListEntityToJson(this);
}

@JsonSerializable()
class CartInfoEntity {
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? id;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? orderId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? productId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? unique;
  final CartDetailInfoEntity? info;

  CartInfoEntity({
    this.id,
    this.orderId,
    this.productId,
    this.unique,
    this.info,
  });

  factory CartInfoEntity.fromJson(Map<String, dynamic> json) =>
      _$CartInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CartInfoEntityToJson(this);
}

@JsonSerializable()
class CartDetailInfoEntity {
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? attrValueId;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? giveIntegral;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? image;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? isReply;
  @JsonKey(fromJson: AppDataUtils.toBool)
  final bool? isSub;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? payNum;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? price;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? productId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? productName;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? productType;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? sku;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? tempId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? vipPrice;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? volume;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? weight;

  CartDetailInfoEntity({
    this.attrValueId,
    this.giveIntegral,
    this.image,
    this.isReply,
    this.isSub,
    this.payNum,
    this.price,
    this.productId,
    this.productName,
    this.productType,
    this.sku,
    this.tempId,
    this.vipPrice,
    this.volume,
    this.weight,
  });

  factory CartDetailInfoEntity.fromJson(Map<String, dynamic> json) =>
      _$CartDetailInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CartDetailInfoEntityToJson(this);
}

@JsonSerializable()
class OrderInfoListEntity {
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? attrId;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? cartNum;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? image;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? isReply;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? price;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? productId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? sku;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? storeName;
  @JsonKey(fromJson: AppDataUtils.toBool)
  final bool? hasCallback;

  OrderInfoListEntity({
    this.attrId,
    this.cartNum,
    this.image,
    this.isReply,
    this.price,
    this.productId,
    this.sku,
    this.storeName,
    this.hasCallback,
  });

  factory OrderInfoListEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderInfoListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$OrderInfoListEntityToJson(this);
}

@JsonSerializable()
class StoreOrderEntity {
  final String? deliveryCode;
  final String? deliveryId;
  final String? deliveryName;
  final String? deliveryType;
  final String? freightPrice;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? id;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? isChannel;
  @JsonKey(fromJson: AppDataUtils.toBool)
  final bool? isDel;
  @JsonKey(fromJson: AppDataUtils.toBool)
  final bool? isSystemDel;
  final String? mark;
  final String? merId;
  final String? orderId;
  final String? outTradeNo;
  final String? paid;
  final String? payPostage;
  final String? payPrice;
  final String? payTime;
  final String? payType;
  final String? pinkId;
  final String? proTotalPrice;
  final String? realName;
  final String? refundPrice;
  final String? refundReason;
  final String? refundReasonTime;
  final String? refundReasonWap;
  final String? refundReasonWapExplain;
  final String? refundReasonWapImg;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? refundStatus;
  final String? remark;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? shippingType;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? status;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? storeId;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? totalNum;
  final String? totalPostage;
  final String? totalPrice;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? type;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? uid;
  final String? updateTime;
  final String? useIntegral;
  final String? userAddress;
  final String? userPhone;
  final String? verifyCode;

  StoreOrderEntity({
    this.deliveryCode,
    this.deliveryId,
    this.deliveryName,
    this.deliveryType,
    this.freightPrice,
    this.id,
    this.isChannel,
    this.isDel,
    this.isSystemDel,
    this.mark,
    this.merId,
    this.orderId,
    this.outTradeNo,
    this.paid,
    this.payPostage,
    this.payPrice,
    this.payTime,
    this.payType,
    this.pinkId,
    this.proTotalPrice,
    this.realName,
    this.refundPrice,
    this.refundReason,
    this.refundReasonTime,
    this.refundReasonWap,
    this.refundReasonWapExplain,
    this.refundReasonWapImg,
    this.refundStatus,
    this.remark,
    this.shippingType,
    this.status,
    this.storeId,
    this.totalNum,
    this.totalPostage,
    this.totalPrice,
    this.type,
    this.uid,
    this.updateTime,
    this.useIntegral,
    this.userAddress,
    this.userPhone,
    this.verifyCode,
  });

  factory StoreOrderEntity.fromJson(Map<String, dynamic> json) =>
      _$StoreOrderEntityFromJson(json);

  Map<String, dynamic> toJson() => _$StoreOrderEntityToJson(this);
}

@JsonSerializable()
class LogisticsOutEntity {
  final String? number;
  final String? type;
  final List<LogisticsEntity>? list;

  LogisticsOutEntity({
    this.number,
    this.type,
    this.list,
  });

  factory LogisticsOutEntity.fromJson(Map<String, dynamic> json) =>
      _$LogisticsOutEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LogisticsOutEntityToJson(this);
}

@JsonSerializable()
class LogisticsEntity {
  final String? time;
  final String? status;

  LogisticsEntity({
    this.time,
    this.status,
  });

  factory LogisticsEntity.fromJson(Map<String, dynamic> json) =>
      _$LogisticsEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LogisticsEntityToJson(this);
}

@JsonSerializable()
class OrderDetailEntity {
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? id;
  final String? orderId;
  final String? realName;
  final String? userPhone;
  final String? userAddress;
  final String? freightPrice;
  final String? totalPrice;
  final String? proTotalPrice;
  final String? payPrice;
  final String? payPostage;
  final String? deductionPrice;
  final String? couponId;
  final String? couponPrice;
  final String? paid;
  final String? payTime;
  final String? deliverTime;
  final String? payType;
  final String? createTime;
  final String? refundReasonWapImg;
  final String? refundReasonWapExplain;
  final String? refundReasonTime;
  final String? refundReasonWap;
  final String? refundReason;
  final String? refundPrice;
  final String? deliveryName;
  final String? deliveryType;
  final String? deliveryId;
  final String? payTypeStr;
  final String? orderStatusMsg;
  final String? courierPhone;
  final String? payTransactionNumber;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? status;
  final List<OrderInfoListEntity>? orderInfoList;
  final LogisticsOutEntity? express;

  OrderDetailEntity({
    this.id,
    this.orderId,
    this.realName,
    this.userPhone,
    this.userAddress,
    this.freightPrice,
    this.totalPrice,
    this.proTotalPrice,
    this.payPrice,
    this.payPostage,
    this.deductionPrice,
    this.couponId,
    this.couponPrice,
    this.paid,
    this.payTime,
    this.deliverTime,
    this.payType,
    this.createTime,
    this.refundReasonWapImg,
    this.refundReasonWapExplain,
    this.refundReasonTime,
    this.refundReasonWap,
    this.refundReason,
    this.refundPrice,
    this.deliveryName,
    this.deliveryType,
    this.deliveryId,
    this.payTypeStr,
    this.orderStatusMsg,
    this.courierPhone,
    this.payTransactionNumber,
    this.status,
    this.orderInfoList,
    this.express,
  });

  factory OrderDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailEntityFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailEntityToJson(this);
}

@JsonSerializable()
class ConfigOrderInfoEntity {
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? attrValueId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? giveIntegral;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? image;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? isReply;
  @JsonKey(fromJson: AppDataUtils.toBool)
  final bool? isSub;
  @JsonKey(fromJson: AppDataUtils.toInt)
  int? payNum;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? price;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? productId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? productName;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? productType;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? sku;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? tempId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? vipPrice;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? volume;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? weight;
  @JsonKey(fromJson: AppDataUtils.toBool)
  final bool? hasCallback;
  @JsonKey(fromJson: AppDataUtils.toBool)
  final bool? hasMonthCredit;

  ConfigOrderInfoEntity({
    this.attrValueId,
    this.giveIntegral,
    this.image,
    this.isReply,
    this.isSub,
    this.payNum,
    this.price,
    this.productId,
    this.productName,
    this.productType,
    this.sku,
    this.tempId,
    this.vipPrice,
    this.volume,
    this.weight,
    this.hasCallback,
    this.hasMonthCredit,
  });

  factory ConfigOrderInfoEntity.fromJson(Map<String, dynamic> json) =>
      _$ConfigOrderInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigOrderInfoEntityToJson(this);
}

@JsonSerializable()
class ConfigOrderInfoOutEntity {
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? addressId;
  final List<String>? cartIdList;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? city;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? couponFee;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? detail;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? district;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? freightFee;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? orderProNum;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? payFee;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? phone;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? proTotalFee;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? province;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? realName;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? remark;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? userBalance;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? userCouponId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? userIntegral;
  @JsonKey(fromJson: AppDataUtils.toBool)
  final bool? hasMonthCredit;
  final List<ConfigOrderInfoEntity>? orderDetailList;

  ConfigOrderInfoOutEntity({
    this.addressId,
    this.cartIdList,
    this.city,
    this.couponFee,
    this.detail,
    this.district,
    this.freightFee,
    this.orderProNum,
    this.payFee,
    this.phone,
    this.proTotalFee,
    this.province,
    this.realName,
    this.remark,
    this.userBalance,
    this.userCouponId,
    this.userIntegral,
    this.hasMonthCredit,
    this.orderDetailList,
  });

  factory ConfigOrderInfoOutEntity.fromJson(Map<String, dynamic> json) =>
      _$ConfigOrderInfoOutEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigOrderInfoOutEntityToJson(this);
}

@JsonSerializable()
class ConfigOrderOutEntity {
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? aliPayStatus;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? payWeixinOpen;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? preOrderNo;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? yuePayStatus;
  final ConfigOrderInfoOutEntity? orderInfoVo;

  ConfigOrderOutEntity({
    this.aliPayStatus,
    this.payWeixinOpen,
    this.preOrderNo,
    this.yuePayStatus,
    this.orderInfoVo,
  });

  factory ConfigOrderOutEntity.fromJson(Map<String, dynamic> json) =>
      _$ConfigOrderOutEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigOrderOutEntityToJson(this);
}

@JsonSerializable()
class ConfigOrderPriceEntity {
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? couponFee;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? deductionPrice;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? freightFee;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? payFee;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? proTotalFee;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? surplusIntegral;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? useIntegral;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? usedIntegral;

  ConfigOrderPriceEntity({
    this.couponFee,
    this.deductionPrice,
    this.freightFee,
    this.payFee,
    this.proTotalFee,
    this.surplusIntegral,
    this.useIntegral,
    this.usedIntegral,
  });

  factory ConfigOrderPriceEntity.fromJson(Map<String, dynamic> json) =>
      _$ConfigOrderPriceEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigOrderPriceEntityToJson(this);
}

@JsonSerializable()
class GoldEntity {
  final String? attrId;
  final String? cartNum;
  final String? image;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? isReply;
  final String? orderId;
  final String? orderInfoId;
  final String? price;
  final String? recyclePrice;
  final String? productId;
  final String? productName;
  final String? storeName;
  final String? sku;

  GoldEntity({
    this.attrId,
    this.cartNum,
    this.image,
    this.isReply,
    this.orderId,
    this.orderInfoId,
    this.price,
    this.recyclePrice,
    this.productId,
    this.productName,
    this.storeName,
    this.sku,
  });

  factory GoldEntity.fromJson(Map<String, dynamic> json) =>
      _$GoldEntityFromJson(json);

  Map<String, dynamic> toJson() => _$GoldEntityToJson(this);
}

@JsonSerializable()
class GoldOutEntity {
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? limit;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? page;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? total;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? totalPage;
  final List<GoldEntity>? list;

  GoldOutEntity({
    this.limit,
    this.page,
    this.total,
    this.totalPage,
    this.list,
  });

  factory GoldOutEntity.fromJson(Map<String, dynamic> json) =>
      _$GoldOutEntityFromJson(json);

  Map<String, dynamic> toJson() => _$GoldOutEntityToJson(this);
}

@JsonSerializable()
class RecycleShopEntity {
  final String? alipayAccount;
  final String? createTime;
  final String? expressNumber;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? goldWeight;
  final String? id;
  final String? orderInfoId;
  final String? orderNo;
  final String? realName;
  final String? recyclePrice;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? status;
  final GoldEntity? orderInfoResponse;

  RecycleShopEntity({
    this.alipayAccount,
    this.createTime,
    this.expressNumber,
    this.goldWeight,
    this.id,
    this.orderInfoId,
    this.orderNo,
    this.realName,
    this.recyclePrice,
    this.status,
    this.orderInfoResponse,
  });

  factory RecycleShopEntity.fromJson(Map<String, dynamic> json) =>
      _$RecycleShopEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RecycleShopEntityToJson(this);
}

@JsonSerializable()
class RecycleShopOutEntity {
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? limit;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? page;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? total;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? totalPage;
  final List<RecycleShopEntity>? list;

  RecycleShopOutEntity({
    this.limit,
    this.page,
    this.total,
    this.totalPage,
    this.list,
  });

  factory RecycleShopOutEntity.fromJson(Map<String, dynamic> json) =>
      _$RecycleShopOutEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RecycleShopOutEntityToJson(this);
}

@JsonSerializable()
class GoldRecycleEntity {
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? id;

  GoldRecycleEntity({this.id});

  factory GoldRecycleEntity.fromJson(Map<String, dynamic> json) =>
      _$GoldRecycleEntityFromJson(json);

  Map<String, dynamic> toJson() => _$GoldRecycleEntityToJson(this);
}

@JsonSerializable()
class PhoneRecycleEntity {
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? id;

  PhoneRecycleEntity({this.id});

  factory PhoneRecycleEntity.fromJson(Map<String, dynamic> json) =>
      _$PhoneRecycleEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneRecycleEntityToJson(this);
}

@JsonSerializable()
class OrderNoResultEntity {
  final String? preOrderNo;
  final String? orderNo;

  OrderNoResultEntity({this.preOrderNo, this.orderNo});

  factory OrderNoResultEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderNoResultEntityFromJson(json);

  Map<String, dynamic> toJson() => _$OrderNoResultEntityToJson(this);
}

class ConfigOrderDeliveryEntity {
  String? attrValueId;
  String? orderNo;
  String? productId;
  int productNum;
  String? sku;
  String? shoppingCartId;

  ConfigOrderDeliveryEntity({
    this.attrValueId,
    this.orderNo,
    this.productId,
    this.productNum = 1,
    this.sku,
    this.shoppingCartId,
  });
}
