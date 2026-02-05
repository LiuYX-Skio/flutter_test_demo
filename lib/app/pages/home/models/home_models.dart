import 'package:json_annotation/json_annotation.dart';
import 'product_models.dart';

part 'home_models.g.dart';

/// 首页顶部数据实体
/// 对应 Android 的 HomeTitleDataEntity
@JsonSerializable()
class HomeTitleDataEntity {
  /// 轮播图列表
  final List<BannerEntity>? banner;

  /// 菜单分类列表
  @JsonKey(name: 'menus')
  final List<MenuCategoryEntity>? menuCategoryList;

  /// 爆款商品
  final ProductEntity? explosiveMoney;

  /// 公告内容
  final String? noticeContent;

  HomeTitleDataEntity({
    this.banner,
    this.menuCategoryList,
    this.explosiveMoney,
    this.noticeContent,
  });

  factory HomeTitleDataEntity.fromJson(Map<String, dynamic> json) =>
      _$HomeTitleDataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$HomeTitleDataEntityToJson(this);
}

/// 轮播图实体
/// 对应 Android 的 BannerEntity
@JsonSerializable()
class BannerEntity {
  /// 轮播图ID
  final int? id;

  /// 图片URL (API字段名为linkUrl)
  @JsonKey(name: 'linkUrl')
  final String? imageUrl;

  /// 标题
  @JsonKey(name: 'name')
  final String? title;

  /// 排序
  final int? sort;

  BannerEntity({
    this.id,
    this.imageUrl,
    this.title,
    this.sort,
  });

  factory BannerEntity.fromJson(Map<String, dynamic> json) =>
      _$BannerEntityFromJson(json);

  Map<String, dynamic> toJson() => _$BannerEntityToJson(this);
}

/// 菜单分类实体
/// 对应 Android 的 MenuCategoryEntity
@JsonSerializable()
class MenuCategoryEntity {
  /// 分类ID
  final int? id;

  /// 分类名称
  final String? name;

  /// 图标URL
  @JsonKey(name: 'pic')
  final String? iconUrl;

  /// 跳转链接
  @JsonKey(name: 'url')
  final String? linkUrl;

  /// 排序
  final int? sort;

  /// 显示状态
  final int? show;

  MenuCategoryEntity({
    this.id,
    this.name,
    this.iconUrl,
    this.linkUrl,
    this.sort,
    this.show,
  });

  factory MenuCategoryEntity.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MenuCategoryEntityToJson(this);
}
