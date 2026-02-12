// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_models.dart';

MenuEntity _$MenuEntityFromJson(Map<String, dynamic> json) => MenuEntity(
      id: AppDataUtils.toInt(json['id']),
      name: json['name'] as String?,
      url: json['url'] as String?,
      isSelect: json['isSelect'] as bool? ?? false,
    );

Map<String, dynamic> _$MenuEntityToJson(MenuEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'isSelect': instance.isSelect,
    };

ShopSortEntity _$ShopSortEntityFromJson(Map<String, dynamic> json) =>
    ShopSortEntity(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : MenuEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      limit: AppDataUtils.toInt(json['limit']),
      page: AppDataUtils.toInt(json['page']),
      total: AppDataUtils.toInt(json['total']),
      totalPage: AppDataUtils.toInt(json['totalPage']),
    );

Map<String, dynamic> _$ShopSortEntityToJson(ShopSortEntity instance) =>
    <String, dynamic>{
      'list': instance.list,
      'limit': instance.limit,
      'page': instance.page,
      'total': instance.total,
      'totalPage': instance.totalPage,
    };

ShopSortShopEntity _$ShopSortShopEntityFromJson(Map<String, dynamic> json) =>
    ShopSortShopEntity(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : ShopInfoEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      limit: AppDataUtils.toInt(json['limit']),
      page: AppDataUtils.toInt(json['page']),
      total: AppDataUtils.toInt(json['total']),
      totalPage: AppDataUtils.toInt(json['totalPage']),
    );

Map<String, dynamic> _$ShopSortShopEntityToJson(ShopSortShopEntity instance) =>
    <String, dynamic>{
      'list': instance.list,
      'limit': instance.limit,
      'page': instance.page,
      'total': instance.total,
      'totalPage': instance.totalPage,
    };

ShopCarEntity _$ShopCarEntityFromJson(Map<String, dynamic> json) =>
    ShopCarEntity(
      isSelect: json['isSelect'] as bool? ?? false,
      attrId: AppDataUtils.toStringValue(json['attrId']),
      attrStatus: AppDataUtils.toBool(json['attrStatus']) ?? false,
      cartNum: AppDataUtils.toInt(json['cartNum']) ?? 0,
      id: AppDataUtils.toStringValue(json['id']),
      image: json['image'] as String?,
      price: AppDataUtils.toStringValue(json['price']),
      productAttrUnique: json['productAttrUnique'] as String?,
      productId: AppDataUtils.toStringValue(json['productId']),
      stock: AppDataUtils.toInt(json['stock']) ?? 0,
      storeName: json['storeName'] as String?,
      suk: json['suk'] as String?,
      vipPrice: json['vipPrice'] as String?,
      recycleType: AppDataUtils.toInt(json['recycleType']),
      hasCallBack: json['hasCallBack'] == null
          ? null
          : AppDataUtils.toBool(json['hasCallBack']),
    );

Map<String, dynamic> _$ShopCarEntityToJson(ShopCarEntity instance) =>
    <String, dynamic>{
      'isSelect': instance.isSelect,
      'attrId': instance.attrId,
      'attrStatus': instance.attrStatus,
      'cartNum': instance.cartNum,
      'id': instance.id,
      'image': instance.image,
      'price': instance.price,
      'productAttrUnique': instance.productAttrUnique,
      'productId': instance.productId,
      'stock': instance.stock,
      'storeName': instance.storeName,
      'suk': instance.suk,
      'vipPrice': instance.vipPrice,
      'recycleType': instance.recycleType,
      'hasCallBack': instance.hasCallBack,
    };

ShopOutCarEntity _$ShopOutCarEntityFromJson(Map<String, dynamic> json) =>
    ShopOutCarEntity(
      limit: AppDataUtils.toInt(json['limit']),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : ShopCarEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: AppDataUtils.toInt(json['page']),
      total: AppDataUtils.toInt(json['total']),
      totalPage: AppDataUtils.toInt(json['totalPage']),
    );

Map<String, dynamic> _$ShopOutCarEntityToJson(ShopOutCarEntity instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'list': instance.list,
      'page': instance.page,
      'total': instance.total,
      'totalPage': instance.totalPage,
    };

ShopAddCarEntity _$ShopAddCarEntityFromJson(Map<String, dynamic> json) =>
    ShopAddCarEntity(
      cartId: AppDataUtils.toInt(json['cartId']),
    );

Map<String, dynamic> _$ShopAddCarEntityToJson(ShopAddCarEntity instance) =>
    <String, dynamic>{
      'cartId': instance.cartId,
    };
