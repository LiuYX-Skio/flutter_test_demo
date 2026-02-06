// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_detail_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopCarSumEntity _$ShopCarSumEntityFromJson(Map<String, dynamic> json) =>
    ShopCarSumEntity(
      count: AppDataUtils.toInt(json['count']),
    );

Map<String, dynamic> _$ShopCarSumEntityToJson(ShopCarSumEntity instance) =>
    <String, dynamic>{
      'count': instance.count,
    };

ShopAttrListEntity _$ShopAttrListEntityFromJson(Map<String, dynamic> json) =>
    ShopAttrListEntity(
      attrValue: json['attrValue'] as String?,
      image: json['image'] as String?,
      isSelect: json['isSelect'] as bool? ?? false,
    );

Map<String, dynamic> _$ShopAttrListEntityToJson(ShopAttrListEntity instance) =>
    <String, dynamic>{
      'attrValue': instance.attrValue,
      'image': instance.image,
      'isSelect': instance.isSelect,
    };

ShopAttrEntity _$ShopAttrEntityFromJson(Map<String, dynamic> json) =>
    ShopAttrEntity(
      attrName: json['attrName'] as String?,
      attrValues: json['attrValues'] as String?,
      id: AppDataUtils.toInt(json['id']),
      isDel: json['isDel'] as bool? ?? false,
      productId: AppDataUtils.toInt(json['productId']),
      type: AppDataUtils.toInt(json['type']),
      attrDetailList: (json['attrDetailList'] as List<dynamic>?)
          ?.map((e) => ShopAttrListEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShopAttrEntityToJson(ShopAttrEntity instance) =>
    <String, dynamic>{
      'attrName': instance.attrName,
      'attrValues': instance.attrValues,
      'id': instance.id,
      'isDel': instance.isDel,
      'productId': instance.productId,
      'type': instance.type,
      'attrDetailList': instance.attrDetailList,
    };

ProduceValueEntity _$ProduceValueEntityFromJson(Map<String, dynamic> json) =>
    ProduceValueEntity(
      attrValue: json['attrValue'] as String?,
      barCode: json['barCode'] as String?,
      id: AppDataUtils.toInt(json['id']),
      sku: json['sku'] as String?,
      isSelect: json['isSelect'] as bool? ?? false,
      price: AppDataUtils.toDouble(json['price']),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ProduceValueEntityToJson(ProduceValueEntity instance) =>
    <String, dynamic>{
      'attrValue': instance.attrValue,
      'barCode': instance.barCode,
      'id': instance.id,
      'sku': instance.sku,
      'isSelect': instance.isSelect,
      'price': instance.price,
      'image': instance.image,
    };

ShopInfoEntity _$ShopInfoEntityFromJson(Map<String, dynamic> json) =>
    ShopInfoEntity(
      activity: json['activity'] as String?,
      addTime: json['addTime'] as String?,
      barCode: json['barCode'] as String?,
      brandId: AppDataUtils.toStringValue(json['brandId']),
      browse: AppDataUtils.toInt(json['browse']),
      cateId: AppDataUtils.toStringValue(json['cateId']),
      content: json['content'] as String?,
      cost: AppDataUtils.toDouble(json['cost']),
      ficti: AppDataUtils.toInt(json['ficti']),
      flatPattern: json['flatPattern'] as String?,
      giveIntegral: AppDataUtils.toInt(json['giveIntegral']),
      id: AppDataUtils.toInt(json['id']),
      image: json['image'] as String?,
      isBargain: json['isBargain'] as bool? ?? false,
      isBenefit: json['isBenefit'] as bool? ?? false,
      isBest: json['isBest'] as bool? ?? false,
      isDel: json['isDel'] as bool? ?? false,
      isGood: json['isGood'] as bool? ?? false,
      isHot: json['isHot'] as bool? ?? false,
      isNew: json['isNew'] as bool? ?? false,
      isPostage: json['isPostage'] as bool? ?? false,
      isRecycle: json['isRecycle'] as bool? ?? false,
      isSeckill: json['isSeckill'] as bool? ?? false,
      isShow: json['isShow'] as bool? ?? false,
      isSub: json['isSub'] as bool? ?? false,
      keyword: json['keyword'] as String?,
      merId: AppDataUtils.toInt(json['merId']),
      merUse: json['merUse'] as bool? ?? false,
      otPrice: AppDataUtils.toDouble(json['otPrice']),
      postage: AppDataUtils.toDouble(json['postage']),
      price: AppDataUtils.toDouble(json['price']),
      sales: AppDataUtils.toInt(json['sales']),
      sliderImage: json['sliderImage'] as String?,
      sliderImageList: (json['sliderImageList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sort: AppDataUtils.toInt(json['sort']),
      specType: json['specType'] as bool? ?? false,
      sppmId: AppDataUtils.toStringValue(json['sppmId']),
      stock: AppDataUtils.toInt(json['stock']),
      storeInfo: json['storeInfo'] as String?,
      storeName: json['storeName'] as String?,
      tempId: AppDataUtils.toInt(json['tempId']),
      unitName: json['unitName'] as String?,
      videoLink: json['videoLink'] as String?,
      vipPrice: AppDataUtils.toDouble(json['vipPrice']),
      hasCallback: json['hasCallback'] as bool? ?? true,
    );

Map<String, dynamic> _$ShopInfoEntityToJson(ShopInfoEntity instance) =>
    <String, dynamic>{
      'activity': instance.activity,
      'addTime': instance.addTime,
      'barCode': instance.barCode,
      'brandId': instance.brandId,
      'browse': instance.browse,
      'cateId': instance.cateId,
      'content': instance.content,
      'cost': instance.cost,
      'ficti': instance.ficti,
      'flatPattern': instance.flatPattern,
      'giveIntegral': instance.giveIntegral,
      'id': instance.id,
      'image': instance.image,
      'isBargain': instance.isBargain,
      'isBenefit': instance.isBenefit,
      'isBest': instance.isBest,
      'isDel': instance.isDel,
      'isGood': instance.isGood,
      'isHot': instance.isHot,
      'isNew': instance.isNew,
      'isPostage': instance.isPostage,
      'isRecycle': instance.isRecycle,
      'isSeckill': instance.isSeckill,
      'isShow': instance.isShow,
      'isSub': instance.isSub,
      'keyword': instance.keyword,
      'merId': instance.merId,
      'merUse': instance.merUse,
      'otPrice': instance.otPrice,
      'postage': instance.postage,
      'price': instance.price,
      'sales': instance.sales,
      'sliderImage': instance.sliderImage,
      'sliderImageList': instance.sliderImageList,
      'sort': instance.sort,
      'specType': instance.specType,
      'sppmId': instance.sppmId,
      'stock': instance.stock,
      'storeInfo': instance.storeInfo,
      'storeName': instance.storeName,
      'tempId': instance.tempId,
      'unitName': instance.unitName,
      'videoLink': instance.videoLink,
      'vipPrice': instance.vipPrice,
      'hasCallback': instance.hasCallback,
    };

ShopCommentEntity _$ShopCommentEntityFromJson(Map<String, dynamic> json) =>
    ShopCommentEntity(
      avatar: json['avatar'] as String?,
      comment: json['comment'] as String?,
      createTime: json['createTime'] as String?,
      id: AppDataUtils.toStringValue(json['id']),
      merchantReplyContent: json['merchantReplyContent'] as String?,
      nickname: json['nickname'] as String?,
      pics: (json['pics'] as List<dynamic>?)?.map((e) => e as String).toList(),
      score: AppDataUtils.toInt(json['score']),
      sku: json['sku'] as String?,
      uid: AppDataUtils.toStringValue(json['uid']),
    );

Map<String, dynamic> _$ShopCommentEntityToJson(ShopCommentEntity instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'comment': instance.comment,
      'createTime': instance.createTime,
      'id': instance.id,
      'merchantReplyContent': instance.merchantReplyContent,
      'nickname': instance.nickname,
      'pics': instance.pics,
      'score': instance.score,
      'sku': instance.sku,
      'uid': instance.uid,
    };

ShopCommentDetailEntity _$ShopCommentDetailEntityFromJson(
        Map<String, dynamic> json) =>
    ShopCommentDetailEntity(
      replyChance: json['replyChance'] as String?,
      sumCount: json['sumCount'] as String?,
      productReply: json['productReply'] == null
          ? null
          : ShopCommentEntity.fromJson(
              json['productReply'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShopCommentDetailEntityToJson(
        ShopCommentDetailEntity instance) =>
    <String, dynamic>{
      'replyChance': instance.replyChance,
      'sumCount': instance.sumCount,
      'productReply': instance.productReply,
    };

ShopCommentOutEntity _$ShopCommentOutEntityFromJson(
        Map<String, dynamic> json) =>
    ShopCommentOutEntity(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => ShopCommentEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      limit: AppDataUtils.toInt(json['limit']),
      page: AppDataUtils.toInt(json['page']),
      total: AppDataUtils.toInt(json['total']),
      totalPage: AppDataUtils.toInt(json['totalPage']),
    );

Map<String, dynamic> _$ShopCommentOutEntityToJson(
        ShopCommentOutEntity instance) =>
    <String, dynamic>{
      'list': instance.list,
      'limit': instance.limit,
      'page': instance.page,
      'total': instance.total,
      'totalPage': instance.totalPage,
    };

ShopDetailEntity _$ShopDetailEntityFromJson(Map<String, dynamic> json) =>
    ShopDetailEntity(
      productValueList: (json['productValueList'] as List<dynamic>?)
          ?.map((e) => ProduceValueEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      userCollect: json['userCollect'] as bool? ?? false,
      productAttr: (json['productAttr'] as List<dynamic>?)
          ?.map((e) => ShopAttrEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      productInfo: json['productInfo'] == null
          ? null
          : ShopInfoEntity.fromJson(
              json['productInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShopDetailEntityToJson(ShopDetailEntity instance) =>
    <String, dynamic>{
      'productValueList': instance.productValueList,
      'userCollect': instance.userCollect,
      'productAttr': instance.productAttr,
      'productInfo': instance.productInfo,
    };
