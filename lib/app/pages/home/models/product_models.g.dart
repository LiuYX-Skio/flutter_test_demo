// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductEntity _$ProductEntityFromJson(Map<String, dynamic> json) =>
    ProductEntity(
      id: AppDataUtils.toInt(json['id']),
      name: json['storeName'] as String?,
      imageUrl: json['image'] as String?,
      price: AppDataUtils.toDouble(json['price']),
      originalPrice: AppDataUtils.toDouble(json['otPrice']),
      description: json['description'] as String?,
      stock: AppDataUtils.toInt(json['stock']),
      salesCount: AppDataUtils.toInt(json['sales']),
      tag: json['tag'] as String?,
      categoryId: AppDataUtils.toInt(json['categoryId']),
    );

Map<String, dynamic> _$ProductEntityToJson(ProductEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeName': instance.name,
      'image': instance.imageUrl,
      'price': instance.price,
      'otPrice': instance.originalPrice,
      'description': instance.description,
      'stock': instance.stock,
      'sales': instance.salesCount,
      'tag': instance.tag,
      'categoryId': instance.categoryId,
    };

ShopOutEntity _$ShopOutEntityFromJson(Map<String, dynamic> json) =>
    ShopOutEntity(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => ProductEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      limit: AppDataUtils.toInt(json['limit']),
      page: AppDataUtils.toInt(json['page']),
      total: AppDataUtils.toInt(json['total']),
      totalPage: AppDataUtils.toInt(json['totalPage']),
    );

Map<String, dynamic> _$ShopOutEntityToJson(ShopOutEntity instance) =>
    <String, dynamic>{
      'list': instance.list,
      'limit': instance.limit,
      'page': instance.page,
      'total': instance.total,
      'totalPage': instance.totalPage,
    };
