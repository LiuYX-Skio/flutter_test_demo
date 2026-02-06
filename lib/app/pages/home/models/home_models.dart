import 'package:json_annotation/json_annotation.dart';
import '../../../../navigation/utils/app_data_utils.dart';

part 'home_models.g.dart';

/// 爆款商品实体
/// 对应 Android 的 ExplosiveMoneyEntity
@JsonSerializable()
class ExplosiveMoneyEntity {
  /// 商品名称
  final String? name;

  /// 商品图片
  final String? pic;

  /// 商品ID
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? id;

  /// 商品类型
  final String? type;

  /// 商品信息
  final String? info;

  ExplosiveMoneyEntity({
    this.name,
    this.pic,
    this.id,
    this.type,
    this.info,
  });

  factory ExplosiveMoneyEntity.fromJson(Map<String, dynamic> json) {
    try {
      return _$ExplosiveMoneyEntityFromJson(json);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$ExplosiveMoneyEntityToJson(this);
}

/// 首页顶部数据实体
/// 对应 Android 的 HomeTitleDataEntity
@JsonSerializable()
class HomeTitleDataEntity {
  /// 轮播图列表
  final List<BannerEntity>? banner;

  /// 菜单分类列表
  final List<MenuCategoryEntity>? menuCategoryList;

  /// 爆款商品列表
  final List<ExplosiveMoneyEntity>? explosiveMoney;

  /// 公告内容
  final String? noticeContent;

  HomeTitleDataEntity({
    this.banner,
    this.menuCategoryList,
    this.explosiveMoney,
    this.noticeContent,
  });

  factory HomeTitleDataEntity.fromJson(Map<String, dynamic> json) {
    try {
      return _$HomeTitleDataEntityFromJson(json);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$HomeTitleDataEntityToJson(this);
}

/// 轮播图实体
/// 对应 Android 的 BannerEntity
@JsonSerializable()
class BannerEntity {
  /// 轮播图ID
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? id;

  /// 图片URL (API字段名为linkUrl)
  @JsonKey(name: 'linkUrl')
  final String? imageUrl;

  /// 标题
  @JsonKey(name: 'name')
  final String? title;

  BannerEntity({
    this.id,
    this.imageUrl,
    this.title,
  });

  factory BannerEntity.fromJson(Map<String, dynamic> json) {
    try {
      return _$BannerEntityFromJson(json);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$BannerEntityToJson(this);
}

/// 菜单分类实体
/// 对应 Android 的 MenuCategoryEntity
@JsonSerializable()
class MenuCategoryEntity {
  /// 分类ID
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? id;

  /// 分类名称
  final String? name;

  /// 图标URL
  @JsonKey(name: 'url')
  final String? iconUrl;

  /// 排序
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? sort;

  /// 显示状态
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? show;

  MenuCategoryEntity({
    this.id,
    this.name,
    this.iconUrl,
    this.sort,
    this.show,
  });

  factory MenuCategoryEntity.fromJson(Map<String, dynamic> json) {
    try {
      return _$MenuCategoryEntityFromJson(json);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$MenuCategoryEntityToJson(this);
}
