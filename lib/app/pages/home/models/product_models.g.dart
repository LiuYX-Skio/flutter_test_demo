// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductEntity _$ProductEntityFromJson(Map<String, dynamic> json) =>
    ProductEntity(
      id: (json['id'] as num?)?.toInt(),
      name: json['storeName'] as String?,
      imageUrl: json['image'] as String?,
      price: ProductEntity._stringToDouble(json['price']),
      originalPrice: ProductEntity._stringToDouble(json['otPrice']),
      description: json['description'] as String?,
      stock: (json['stock'] as num?)?.toInt(),
      salesCount: (json['sales'] as num?)?.toInt(),
      tag: json['tag'] as String?,
      categoryId: (json['categoryId'] as num?)?.toInt(),
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
      limit: (json['limit'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      totalPage: (json['totalPage'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ShopOutEntityToJson(ShopOutEntity instance) =>
    <String, dynamic>{
      'list': instance.list,
      'limit': instance.limit,
      'page': instance.page,
      'total': instance.total,
      'totalPage': instance.totalPage,
    };
