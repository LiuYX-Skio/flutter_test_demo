// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderOutEntity _$OrderOutEntityFromJson(Map<String, dynamic> json) =>
    OrderOutEntity(
      limit: AppDataUtils.toInt(json['limit']),
      page: AppDataUtils.toInt(json['page']),
      total: AppDataUtils.toInt(json['total']),
      totalPage: AppDataUtils.toInt(json['totalPage']),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => OrderListEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderOutEntityToJson(OrderOutEntity instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'page': instance.page,
      'total': instance.total,
      'totalPage': instance.totalPage,
      'list': instance.list,
    };

OrderListEntity _$OrderListEntityFromJson(Map<String, dynamic> json) =>
    OrderListEntity(
      createTime: json['createTime'] as String?,
      deliveryId: json['deliveryId'] as String?,
      deliveryName: json['deliveryName'] as String?,
      deliveryType: json['deliveryType'] as String?,
      id: AppDataUtils.toInt(json['id']),
      offlinePayStatus: AppDataUtils.toInt(json['offlinePayStatus']),
      orderId: json['orderId'] as String?,
      paid: AppDataUtils.toBool(json['paid']),
      payPostage: json['payPostage'] as String?,
      payPrice: json['payPrice'] as String?,
      payTime: json['payTime'] as String?,
      refundStatus: AppDataUtils.toInt(json['refundStatus']),
      refundReason: json['refundReason'] as String?,
      shippingType: AppDataUtils.toInt(json['shippingType']),
      status: AppDataUtils.toInt(json['status']),
      statusPic: json['statusPic'] as String?,
      totalNum: AppDataUtils.toInt(json['totalNum']),
      type: AppDataUtils.toInt(json['type']),
      cartInfo: (json['cartInfo'] as List<dynamic>?)
          ?.map((e) => CartInfoEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderInfoList: (json['orderInfoList'] as List<dynamic>?)
          ?.map((e) => OrderInfoListEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      storeOrder: json['storeOrder'] == null
          ? null
          : StoreOrderEntity.fromJson(
              json['storeOrder'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderListEntityToJson(OrderListEntity instance) =>
    <String, dynamic>{
      'createTime': instance.createTime,
      'deliveryId': instance.deliveryId,
      'deliveryName': instance.deliveryName,
      'deliveryType': instance.deliveryType,
      'id': instance.id,
      'offlinePayStatus': instance.offlinePayStatus,
      'orderId': instance.orderId,
      'paid': instance.paid,
      'payPostage': instance.payPostage,
      'payPrice': instance.payPrice,
      'payTime': instance.payTime,
      'refundStatus': instance.refundStatus,
      'refundReason': instance.refundReason,
      'shippingType': instance.shippingType,
      'status': instance.status,
      'statusPic': instance.statusPic,
      'totalNum': instance.totalNum,
      'type': instance.type,
      'cartInfo': instance.cartInfo,
      'orderInfoList': instance.orderInfoList,
      'storeOrder': instance.storeOrder,
    };

CartInfoEntity _$CartInfoEntityFromJson(Map<String, dynamic> json) =>
    CartInfoEntity(
      id: AppDataUtils.toInt(json['id']),
      orderId: json['orderId'] as String?,
      productId: json['productId'] as String?,
      unique: json['unique'] as String?,
      info: json['info'] == null
          ? null
          : CartDetailInfoEntity.fromJson(
              json['info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartInfoEntityToJson(CartInfoEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'productId': instance.productId,
      'unique': instance.unique,
      'info': instance.info,
    };

CartDetailInfoEntity _$CartDetailInfoEntityFromJson(Map<String, dynamic> json) =>
    CartDetailInfoEntity(
      attrValueId: AppDataUtils.toInt(json['attrValueId']),
      giveIntegral: AppDataUtils.toInt(json['giveIntegral']),
      image: json['image'] as String?,
      isReply: json['isReply'] as String?,
      isSub: AppDataUtils.toBool(json['isSub']),
      payNum: AppDataUtils.toInt(json['payNum']),
      price: json['price'] as String?,
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      productType: json['productType'] as String?,
      sku: json['sku'] as String?,
      tempId: AppDataUtils.toInt(json['tempId']),
      vipPrice: json['vipPrice'] as String?,
      volume: json['volume'] as String?,
      weight: json['weight'] as String?,
    );

Map<String, dynamic> _$CartDetailInfoEntityToJson(
        CartDetailInfoEntity instance) =>
    <String, dynamic>{
      'attrValueId': instance.attrValueId,
      'giveIntegral': instance.giveIntegral,
      'image': instance.image,
      'isReply': instance.isReply,
      'isSub': instance.isSub,
      'payNum': instance.payNum,
      'price': instance.price,
      'productId': instance.productId,
      'productName': instance.productName,
      'productType': instance.productType,
      'sku': instance.sku,
      'tempId': instance.tempId,
      'vipPrice': instance.vipPrice,
      'volume': instance.volume,
      'weight': instance.weight,
    };

OrderInfoListEntity _$OrderInfoListEntityFromJson(Map<String, dynamic> json) =>
    OrderInfoListEntity(
      attrId: json['attrId'] as String?,
      cartNum: AppDataUtils.toInt(json['cartNum']),
      image: json['image'] as String?,
      isReply: AppDataUtils.toInt(json['isReply']),
      price: json['price'] as String?,
      productId: json['productId'] as String?,
      sku: json['sku'] as String?,
      storeName: json['storeName'] as String?,
      hasCallback: AppDataUtils.toBool(json['hasCallback']),
    );

Map<String, dynamic> _$OrderInfoListEntityToJson(
        OrderInfoListEntity instance) =>
    <String, dynamic>{
      'attrId': instance.attrId,
      'cartNum': instance.cartNum,
      'image': instance.image,
      'isReply': instance.isReply,
      'price': instance.price,
      'productId': instance.productId,
      'sku': instance.sku,
      'storeName': instance.storeName,
      'hasCallback': instance.hasCallback,
    };

StoreOrderEntity _$StoreOrderEntityFromJson(Map<String, dynamic> json) =>
    StoreOrderEntity(
      deliveryCode: json['deliveryCode'] as String?,
      deliveryId: json['deliveryId'] as String?,
      deliveryName: json['deliveryName'] as String?,
      deliveryType: json['deliveryType'] as String?,
      freightPrice: json['freightPrice'] as String?,
      id: AppDataUtils.toInt(json['id']),
      isChannel: AppDataUtils.toInt(json['isChannel']),
      isDel: AppDataUtils.toBool(json['isDel']),
      isSystemDel: AppDataUtils.toBool(json['isSystemDel']),
      mark: json['mark'] as String?,
      merId: json['merId'] as String?,
      orderId: json['orderId'] as String?,
      outTradeNo: json['outTradeNo'] as String?,
      paid: json['paid'] as String?,
      payPostage: json['payPostage'] as String?,
      payPrice: json['payPrice'] as String?,
      payTime: json['payTime'] as String?,
      payType: json['payType'] as String?,
      pinkId: json['pinkId'] as String?,
      proTotalPrice: json['proTotalPrice'] as String?,
      realName: json['realName'] as String?,
      refundPrice: json['refundPrice'] as String?,
      refundReason: json['refundReason'] as String?,
      refundReasonTime: json['refundReasonTime'] as String?,
      refundReasonWap: json['refundReasonWap'] as String?,
      refundReasonWapExplain: json['refundReasonWapExplain'] as String?,
      refundReasonWapImg: json['refundReasonWapImg'] as String?,
      refundStatus: AppDataUtils.toInt(json['refundStatus']),
      remark: json['remark'] as String?,
      shippingType: AppDataUtils.toInt(json['shippingType']),
      status: AppDataUtils.toInt(json['status']),
      storeId: AppDataUtils.toInt(json['storeId']),
      totalNum: AppDataUtils.toInt(json['totalNum']),
      totalPostage: json['totalPostage'] as String?,
      totalPrice: json['totalPrice'] as String?,
      type: AppDataUtils.toInt(json['type']),
      uid: AppDataUtils.toInt(json['uid']),
      updateTime: json['updateTime'] as String?,
      useIntegral: json['useIntegral'] as String?,
      userAddress: json['userAddress'] as String?,
      userPhone: json['userPhone'] as String?,
      verifyCode: json['verifyCode'] as String?,
    );

Map<String, dynamic> _$StoreOrderEntityToJson(StoreOrderEntity instance) =>
    <String, dynamic>{
      'deliveryCode': instance.deliveryCode,
      'deliveryId': instance.deliveryId,
      'deliveryName': instance.deliveryName,
      'deliveryType': instance.deliveryType,
      'freightPrice': instance.freightPrice,
      'id': instance.id,
      'isChannel': instance.isChannel,
      'isDel': instance.isDel,
      'isSystemDel': instance.isSystemDel,
      'mark': instance.mark,
      'merId': instance.merId,
      'orderId': instance.orderId,
      'outTradeNo': instance.outTradeNo,
      'paid': instance.paid,
      'payPostage': instance.payPostage,
      'payPrice': instance.payPrice,
      'payTime': instance.payTime,
      'payType': instance.payType,
      'pinkId': instance.pinkId,
      'proTotalPrice': instance.proTotalPrice,
      'realName': instance.realName,
      'refundPrice': instance.refundPrice,
      'refundReason': instance.refundReason,
      'refundReasonTime': instance.refundReasonTime,
      'refundReasonWap': instance.refundReasonWap,
      'refundReasonWapExplain': instance.refundReasonWapExplain,
      'refundReasonWapImg': instance.refundReasonWapImg,
      'refundStatus': instance.refundStatus,
      'remark': instance.remark,
      'shippingType': instance.shippingType,
      'status': instance.status,
      'storeId': instance.storeId,
      'totalNum': instance.totalNum,
      'totalPostage': instance.totalPostage,
      'totalPrice': instance.totalPrice,
      'type': instance.type,
      'uid': instance.uid,
      'updateTime': instance.updateTime,
      'useIntegral': instance.useIntegral,
      'userAddress': instance.userAddress,
      'userPhone': instance.userPhone,
      'verifyCode': instance.verifyCode,
    };

LogisticsOutEntity _$LogisticsOutEntityFromJson(Map<String, dynamic> json) =>
    LogisticsOutEntity(
      number: json['number'] as String?,
      type: json['type'] as String?,
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => LogisticsEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LogisticsOutEntityToJson(LogisticsOutEntity instance) =>
    <String, dynamic>{
      'number': instance.number,
      'type': instance.type,
      'list': instance.list,
    };

LogisticsEntity _$LogisticsEntityFromJson(Map<String, dynamic> json) =>
    LogisticsEntity(
      time: json['time'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$LogisticsEntityToJson(LogisticsEntity instance) =>
    <String, dynamic>{
      'time': instance.time,
      'status': instance.status,
    };

OrderDetailEntity _$OrderDetailEntityFromJson(Map<String, dynamic> json) =>
    OrderDetailEntity(
      id: AppDataUtils.toInt(json['id']),
      orderId: json['orderId'] as String?,
      realName: json['realName'] as String?,
      userPhone: json['userPhone'] as String?,
      userAddress: json['userAddress'] as String?,
      freightPrice: json['freightPrice'] as String?,
      totalPrice: json['totalPrice'] as String?,
      proTotalPrice: json['proTotalPrice'] as String?,
      payPrice: json['payPrice'] as String?,
      payPostage: json['payPostage'] as String?,
      deductionPrice: json['deductionPrice'] as String?,
      couponId: json['couponId'] as String?,
      couponPrice: json['couponPrice'] as String?,
      paid: json['paid'] as String?,
      payTime: json['payTime'] as String?,
      deliverTime: json['deliverTime'] as String?,
      payType: json['payType'] as String?,
      createTime: json['createTime'] as String?,
      refundReasonWapImg: json['refundReasonWapImg'] as String?,
      refundReasonWapExplain: json['refundReasonWapExplain'] as String?,
      refundReasonTime: json['refundReasonTime'] as String?,
      refundReasonWap: json['refundReasonWap'] as String?,
      refundReason: json['refundReason'] as String?,
      refundPrice: json['refundPrice'] as String?,
      deliveryName: json['deliveryName'] as String?,
      deliveryType: json['deliveryType'] as String?,
      deliveryId: json['deliveryId'] as String?,
      payTypeStr: json['payTypeStr'] as String?,
      orderStatusMsg: json['orderStatusMsg'] as String?,
      courierPhone: json['courierPhone'] as String?,
      payTransactionNumber: json['payTransactionNumber'] as String?,
      status: AppDataUtils.toInt(json['status']),
      orderInfoList: (json['orderInfoList'] as List<dynamic>?)
          ?.map((e) => OrderInfoListEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      express: json['express'] == null
          ? null
          : LogisticsOutEntity.fromJson(
              json['express'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderDetailEntityToJson(OrderDetailEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'realName': instance.realName,
      'userPhone': instance.userPhone,
      'userAddress': instance.userAddress,
      'freightPrice': instance.freightPrice,
      'totalPrice': instance.totalPrice,
      'proTotalPrice': instance.proTotalPrice,
      'payPrice': instance.payPrice,
      'payPostage': instance.payPostage,
      'deductionPrice': instance.deductionPrice,
      'couponId': instance.couponId,
      'couponPrice': instance.couponPrice,
      'paid': instance.paid,
      'payTime': instance.payTime,
      'deliverTime': instance.deliverTime,
      'payType': instance.payType,
      'createTime': instance.createTime,
      'refundReasonWapImg': instance.refundReasonWapImg,
      'refundReasonWapExplain': instance.refundReasonWapExplain,
      'refundReasonTime': instance.refundReasonTime,
      'refundReasonWap': instance.refundReasonWap,
      'refundReason': instance.refundReason,
      'refundPrice': instance.refundPrice,
      'deliveryName': instance.deliveryName,
      'deliveryType': instance.deliveryType,
      'deliveryId': instance.deliveryId,
      'payTypeStr': instance.payTypeStr,
      'orderStatusMsg': instance.orderStatusMsg,
      'courierPhone': instance.courierPhone,
      'payTransactionNumber': instance.payTransactionNumber,
      'status': instance.status,
      'orderInfoList': instance.orderInfoList,
      'express': instance.express,
    };

ConfigOrderInfoEntity _$ConfigOrderInfoEntityFromJson(
        Map<String, dynamic> json) =>
    ConfigOrderInfoEntity(
      attrValueId: json['attrValueId'] as String?,
      giveIntegral: json['giveIntegral'] as String?,
      image: json['image'] as String?,
      isReply: json['isReply'] as String?,
      isSub: AppDataUtils.toBool(json['isSub']),
      payNum: AppDataUtils.toInt(json['payNum']),
      price: json['price'] as String?,
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      productType: json['productType'] as String?,
      sku: json['sku'] as String?,
      tempId: json['tempId'] as String?,
      vipPrice: json['vipPrice'] as String?,
      volume: json['volume'] as String?,
      weight: json['weight'] as String?,
      hasCallback: AppDataUtils.toBool(json['hasCallback']),
      hasMonthCredit: AppDataUtils.toBool(json['hasMonthCredit']),
    );

Map<String, dynamic> _$ConfigOrderInfoEntityToJson(
        ConfigOrderInfoEntity instance) =>
    <String, dynamic>{
      'attrValueId': instance.attrValueId,
      'giveIntegral': instance.giveIntegral,
      'image': instance.image,
      'isReply': instance.isReply,
      'isSub': instance.isSub,
      'payNum': instance.payNum,
      'price': instance.price,
      'productId': instance.productId,
      'productName': instance.productName,
      'productType': instance.productType,
      'sku': instance.sku,
      'tempId': instance.tempId,
      'vipPrice': instance.vipPrice,
      'volume': instance.volume,
      'weight': instance.weight,
      'hasCallback': instance.hasCallback,
      'hasMonthCredit': instance.hasMonthCredit,
    };

ConfigOrderInfoOutEntity _$ConfigOrderInfoOutEntityFromJson(
        Map<String, dynamic> json) =>
    ConfigOrderInfoOutEntity(
      addressId: json['addressId'] as String?,
      cartIdList: (json['cartIdList'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      city: json['city'] as String?,
      couponFee: json['couponFee'] as String?,
      detail: json['detail'] as String?,
      district: json['district'] as String?,
      freightFee: json['freightFee'] as String?,
      orderProNum: json['orderProNum'] as String?,
      payFee: json['payFee'] as String?,
      phone: json['phone'] as String?,
      proTotalFee: json['proTotalFee'] as String?,
      province: json['province'] as String?,
      realName: json['realName'] as String?,
      remark: json['remark'] as String?,
      userBalance: json['userBalance'] as String?,
      userCouponId: json['userCouponId'] as String?,
      userIntegral: json['userIntegral'] as String?,
      hasMonthCredit: AppDataUtils.toBool(json['hasMonthCredit']),
      orderDetailList: (json['orderDetailList'] as List<dynamic>?)
          ?.map((e) => ConfigOrderInfoEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConfigOrderInfoOutEntityToJson(
        ConfigOrderInfoOutEntity instance) =>
    <String, dynamic>{
      'addressId': instance.addressId,
      'cartIdList': instance.cartIdList,
      'city': instance.city,
      'couponFee': instance.couponFee,
      'detail': instance.detail,
      'district': instance.district,
      'freightFee': instance.freightFee,
      'orderProNum': instance.orderProNum,
      'payFee': instance.payFee,
      'phone': instance.phone,
      'proTotalFee': instance.proTotalFee,
      'province': instance.province,
      'realName': instance.realName,
      'remark': instance.remark,
      'userBalance': instance.userBalance,
      'userCouponId': instance.userCouponId,
      'userIntegral': instance.userIntegral,
      'hasMonthCredit': instance.hasMonthCredit,
      'orderDetailList': instance.orderDetailList,
    };

ConfigOrderOutEntity _$ConfigOrderOutEntityFromJson(
        Map<String, dynamic> json) =>
    ConfigOrderOutEntity(
      aliPayStatus: json['aliPayStatus'] as String?,
      payWeixinOpen: json['payWeixinOpen'] as String?,
      preOrderNo: json['preOrderNo'] as String?,
      yuePayStatus: json['yuePayStatus'] as String?,
      orderInfoVo: json['orderInfoVo'] == null
          ? null
          : ConfigOrderInfoOutEntity.fromJson(
              json['orderInfoVo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConfigOrderOutEntityToJson(
        ConfigOrderOutEntity instance) =>
    <String, dynamic>{
      'aliPayStatus': instance.aliPayStatus,
      'payWeixinOpen': instance.payWeixinOpen,
      'preOrderNo': instance.preOrderNo,
      'yuePayStatus': instance.yuePayStatus,
      'orderInfoVo': instance.orderInfoVo,
    };

ConfigOrderPriceEntity _$ConfigOrderPriceEntityFromJson(
        Map<String, dynamic> json) =>
    ConfigOrderPriceEntity(
      couponFee: json['couponFee'] as String?,
      deductionPrice: json['deductionPrice'] as String?,
      freightFee: json['freightFee'] as String?,
      payFee: json['payFee'] as String?,
      proTotalFee: json['proTotalFee'] as String?,
      surplusIntegral: json['surplusIntegral'] as String?,
      useIntegral: json['useIntegral'] as String?,
      usedIntegral: json['usedIntegral'] as String?,
    );

Map<String, dynamic> _$ConfigOrderPriceEntityToJson(
        ConfigOrderPriceEntity instance) =>
    <String, dynamic>{
      'couponFee': instance.couponFee,
      'deductionPrice': instance.deductionPrice,
      'freightFee': instance.freightFee,
      'payFee': instance.payFee,
      'proTotalFee': instance.proTotalFee,
      'surplusIntegral': instance.surplusIntegral,
      'useIntegral': instance.useIntegral,
      'usedIntegral': instance.usedIntegral,
    };

GoldEntity _$GoldEntityFromJson(Map<String, dynamic> json) => GoldEntity(
      attrId: json['attrId'] as String?,
      cartNum: json['cartNum'] as String?,
      image: json['image'] as String?,
      isReply: AppDataUtils.toInt(json['isReply']),
      orderId: json['orderId'] as String?,
      orderInfoId: json['orderInfoId'] as String?,
      price: json['price'] as String?,
      recyclePrice: json['recyclePrice'] as String?,
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      storeName: json['storeName'] as String?,
      sku: json['sku'] as String?,
    );

Map<String, dynamic> _$GoldEntityToJson(GoldEntity instance) =>
    <String, dynamic>{
      'attrId': instance.attrId,
      'cartNum': instance.cartNum,
      'image': instance.image,
      'isReply': instance.isReply,
      'orderId': instance.orderId,
      'orderInfoId': instance.orderInfoId,
      'price': instance.price,
      'recyclePrice': instance.recyclePrice,
      'productId': instance.productId,
      'productName': instance.productName,
      'storeName': instance.storeName,
      'sku': instance.sku,
    };

GoldOutEntity _$GoldOutEntityFromJson(Map<String, dynamic> json) =>
    GoldOutEntity(
      limit: AppDataUtils.toInt(json['limit']),
      page: AppDataUtils.toInt(json['page']),
      total: AppDataUtils.toInt(json['total']),
      totalPage: AppDataUtils.toInt(json['totalPage']),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => GoldEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GoldOutEntityToJson(GoldOutEntity instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'page': instance.page,
      'total': instance.total,
      'totalPage': instance.totalPage,
      'list': instance.list,
    };

RecycleShopEntity _$RecycleShopEntityFromJson(Map<String, dynamic> json) =>
    RecycleShopEntity(
      alipayAccount: json['alipayAccount'] as String?,
      createTime: json['createTime'] as String?,
      expressNumber: json['expressNumber'] as String?,
      goldWeight: AppDataUtils.toInt(json['goldWeight']),
      id: json['id'] as String?,
      orderInfoId: json['orderInfoId'] as String?,
      orderNo: json['orderNo'] as String?,
      realName: json['realName'] as String?,
      recyclePrice: json['recyclePrice'] as String?,
      status: AppDataUtils.toInt(json['status']),
      orderInfoResponse: json['orderInfoResponse'] == null
          ? null
          : GoldEntity.fromJson(
              json['orderInfoResponse'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecycleShopEntityToJson(RecycleShopEntity instance) =>
    <String, dynamic>{
      'alipayAccount': instance.alipayAccount,
      'createTime': instance.createTime,
      'expressNumber': instance.expressNumber,
      'goldWeight': instance.goldWeight,
      'id': instance.id,
      'orderInfoId': instance.orderInfoId,
      'orderNo': instance.orderNo,
      'realName': instance.realName,
      'recyclePrice': instance.recyclePrice,
      'status': instance.status,
      'orderInfoResponse': instance.orderInfoResponse,
    };

RecycleShopOutEntity _$RecycleShopOutEntityFromJson(
        Map<String, dynamic> json) =>
    RecycleShopOutEntity(
      limit: AppDataUtils.toInt(json['limit']),
      page: AppDataUtils.toInt(json['page']),
      total: AppDataUtils.toInt(json['total']),
      totalPage: AppDataUtils.toInt(json['totalPage']),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => RecycleShopEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecycleShopOutEntityToJson(
        RecycleShopOutEntity instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'page': instance.page,
      'total': instance.total,
      'totalPage': instance.totalPage,
      'list': instance.list,
    };

GoldRecycleEntity _$GoldRecycleEntityFromJson(Map<String, dynamic> json) =>
    GoldRecycleEntity(
      id: AppDataUtils.toInt(json['id']),
    );

Map<String, dynamic> _$GoldRecycleEntityToJson(GoldRecycleEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

PhoneRecycleEntity _$PhoneRecycleEntityFromJson(Map<String, dynamic> json) =>
    PhoneRecycleEntity(
      id: AppDataUtils.toInt(json['id']),
    );

Map<String, dynamic> _$PhoneRecycleEntityToJson(PhoneRecycleEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

OrderNoResultEntity _$OrderNoResultEntityFromJson(Map<String, dynamic> json) =>
    OrderNoResultEntity(
      preOrderNo: json['preOrderNo'] as String?,
      orderNo: json['orderNo'] as String?,
    );

Map<String, dynamic> _$OrderNoResultEntityToJson(
        OrderNoResultEntity instance) =>
    <String, dynamic>{
      'preOrderNo': instance.preOrderNo,
      'orderNo': instance.orderNo,
    };
