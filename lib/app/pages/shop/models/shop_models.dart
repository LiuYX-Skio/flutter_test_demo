import 'package:json_annotation/json_annotation.dart';
import '../../../../navigation/utils/app_data_utils.dart';
import 'shop_detail_models.dart';

part 'shop_models.g.dart';

/// 菜单实体类
/// 对应 Android 的 MenuEntity
@JsonSerializable()
class MenuEntity {
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? id;

  final String? name;

  final String? url;

  /// 是否选中（非服务端字段）
  @JsonKey(defaultValue: false)
  final bool isSelect;

  const MenuEntity({
    this.id,
    this.name,
    this.url,
    this.isSelect = false,
  });

  factory MenuEntity.fromJson(Map<String, dynamic> json) =>
      _$MenuEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MenuEntityToJson(this);

  MenuEntity copyWith({bool? isSelect}) {
    return MenuEntity(
      id: id,
      name: name,
      url: url,
      isSelect: isSelect ?? this.isSelect,
    );
  }
}

/// 分类列表
/// 对应 Android 的 ShopSortEntity
@JsonSerializable()
class ShopSortEntity {
  final List<MenuEntity?>? list;

  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? limit;

  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? page;

  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? total;

  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? totalPage;

  const ShopSortEntity({
    this.list,
    this.limit,
    this.page,
    this.total,
    this.totalPage,
  });

  factory ShopSortEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopSortEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopSortEntityToJson(this);
}

/// 分类下商品列表
/// 对应 Android 的 ShopSortShopEntity
@JsonSerializable()
class ShopSortShopEntity {
  final List<ShopInfoEntity?>? list;

  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? limit;

  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? page;

  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? total;

  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? totalPage;

  const ShopSortShopEntity({
    this.list,
    this.limit,
    this.page,
    this.total,
    this.totalPage,
  });

  factory ShopSortShopEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopSortShopEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopSortShopEntityToJson(this);
}

/// 购物车商品
/// 对应 Android 的 ShopCarEntity
@JsonSerializable()
class ShopCarEntity {
  /// 是否选中（非服务端字段）
  @JsonKey(defaultValue: false)
  final bool isSelect;

  final String? attrId;

  @JsonKey(fromJson: AppDataUtils.toBool, defaultValue: false)
  final bool attrStatus;

  @JsonKey(fromJson: AppDataUtils.toInt, defaultValue: 0)
  final int cartNum;

  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? id;

  final String? image;

  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? price;

  final String? productAttrUnique;

  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? productId;

  @JsonKey(fromJson: AppDataUtils.toInt, defaultValue: 0)
  final int stock;

  final String? storeName;

  @JsonKey(name: 'suk')
  final String? suk;

  final String? vipPrice;

  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? recycleType;

  @JsonKey(fromJson: AppDataUtils.toBool)
  final bool? hasCallBack;

  const ShopCarEntity({
    this.isSelect = false,
    this.attrId,
    this.attrStatus = false,
    this.cartNum = 0,
    this.id,
    this.image,
    this.price,
    this.productAttrUnique,
    this.productId,
    this.stock = 0,
    this.storeName,
    this.suk,
    this.vipPrice,
    this.recycleType,
    this.hasCallBack,
  });

  factory ShopCarEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopCarEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopCarEntityToJson(this);

  ShopCarEntity copyWith({
    bool? isSelect,
    int? cartNum,
  }) {
    return ShopCarEntity(
      isSelect: isSelect ?? this.isSelect,
      attrId: attrId,
      attrStatus: attrStatus,
      cartNum: cartNum ?? this.cartNum,
      id: id,
      image: image,
      price: price,
      productAttrUnique: productAttrUnique,
      productId: productId,
      stock: stock,
      storeName: storeName,
      suk: suk,
      vipPrice: vipPrice,
      recycleType: recycleType,
      hasCallBack: hasCallBack,
    );
  }
}

/// 购物车列表分页
/// 对应 Android 的 ShopOutCarEntity
@JsonSerializable()
class ShopOutCarEntity {
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? limit;

  final List<ShopCarEntity?>? list;

  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? page;

  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? total;

  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? totalPage;

  const ShopOutCarEntity({
    this.limit,
    this.list,
    this.page,
    this.total,
    this.totalPage,
  });

  factory ShopOutCarEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopOutCarEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopOutCarEntityToJson(this);
}

/// 添加购物车返回
/// 对应 Android 的 ShopAddCarEntity
@JsonSerializable()
class ShopAddCarEntity {
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? cartId;

  const ShopAddCarEntity({this.cartId});

  factory ShopAddCarEntity.fromJson(Map<String, dynamic> json) =>
      _$ShopAddCarEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ShopAddCarEntityToJson(this);
}

