import 'package:json_annotation/json_annotation.dart';

part 'product_models.g.dart';

/// 商品实体
/// 对应 Android 的 ProductEntity
@JsonSerializable()
class ProductEntity {
  /// 商品ID
  final int? id;

  /// 商品名称
  final String? name;

  /// 商品图片URL
  final String? imageUrl;

  /// 商品价格
  final double? price;

  /// 原价
  final double? originalPrice;

  /// 商品描述
  final String? description;

  /// 库存数量
  final int? stock;

  /// 销售数量
  final int? salesCount;

  /// 商品标签
  final String? tag;

  /// 商品分类ID
  final int? categoryId;

  ProductEntity({
    this.id,
    this.name,
    this.imageUrl,
    this.price,
    this.originalPrice,
    this.description,
    this.stock,
    this.salesCount,
    this.tag,
    this.categoryId,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ProductEntityToJson(this);
}

/// 分页数据包装器
/// 对应 Android 的 ShopOutEntity<T>
@JsonSerializable(genericArgumentFactories: true)
class ShopOutEntity<T> {
  /// 数据列表
  final List<T>? list;

  /// 每页数量
  final int? limit;

  /// 当前页码
  final int? page;

  /// 总数量
  final int? total;

  /// 总页数
  final int? totalPage;

  ShopOutEntity({
    this.list,
    this.limit,
    this.page,
    this.total,
    this.totalPage,
  });

  factory ShopOutEntity.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ShopOutEntityFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ShopOutEntityToJson(this, toJsonT);
}
