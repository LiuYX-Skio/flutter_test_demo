import 'package:json_annotation/json_annotation.dart';

part 'product_models.g.dart';

/// 商品实体
/// 对应 Android 的 ProductEntity
@JsonSerializable()
class ProductEntity {
  /// 商品ID
  final int? id;

  /// 商品名称
  @JsonKey(name: 'storeName')
  final String? name;

  /// 商品图片URL
  @JsonKey(name: 'image')
  final String? imageUrl;

  /// 商品价格
  @JsonKey(fromJson: _stringToDouble)
  final double? price;

  /// 原价
  @JsonKey(name: 'otPrice', fromJson: _stringToDouble)
  final double? originalPrice;

  /// 商品描述
  final String? description;

  /// 库存数量
  final int? stock;

  /// 销售数量
  @JsonKey(name: 'sales')
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

  /// 将字符串或数字转换为 double
  static double? _stringToDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

/// 分页数据包装器
/// 对应 Android 的 ShopOutEntity
@JsonSerializable()
class ShopOutEntity {
  /// 数据列表
  final List<ProductEntity>? list;

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

  factory ShopOutEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopOutEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopOutEntityToJson(this);
}
