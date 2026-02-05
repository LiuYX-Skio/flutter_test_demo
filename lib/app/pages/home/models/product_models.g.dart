// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductEntity _$ProductEntityFromJson(Map<String, dynamic> json) =>
    ProductEntity(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      description: json['description'] as String?,
      stock: (json['stock'] as num?)?.toInt(),
      salesCount: (json['salesCount'] as num?)?.toInt(),
      tag: json['tag'] as String?,
      categoryId: (json['categoryId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductEntityToJson(ProductEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'description': instance.description,
      'stock': instance.stock,
      'salesCount': instance.salesCount,
      'tag': instance.tag,
      'categoryId': instance.categoryId,
    };

ShopOutEntity<T> _$ShopOutEntityFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ShopOutEntity<T>(
      list: (json['list'] as List<dynamic>?)?.map(fromJsonT).toList(),
      limit: (json['limit'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      totalPage: (json['totalPage'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ShopOutEntityToJson<T>(
  ShopOutEntity<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'list': instance.list?.map(toJsonT).toList(),
      'limit': instance.limit,
      'page': instance.page,
      'total': instance.total,
      'totalPage': instance.totalPage,
    };
