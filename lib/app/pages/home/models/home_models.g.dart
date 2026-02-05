// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeTitleDataEntity _$HomeTitleDataEntityFromJson(Map<String, dynamic> json) =>
    HomeTitleDataEntity(
      banner: (json['banner'] as List<dynamic>?)
          ?.map((e) => BannerEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      menuCategoryList: (json['menus'] as List<dynamic>?)
          ?.map((e) => MenuCategoryEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      explosiveMoney: json['explosiveMoney'] == null
          ? null
          : ProductEntity.fromJson(
              json['explosiveMoney'] as Map<String, dynamic>),
      noticeContent: json['noticeContent'] as String?,
    );

Map<String, dynamic> _$HomeTitleDataEntityToJson(
        HomeTitleDataEntity instance) =>
    <String, dynamic>{
      'banner': instance.banner,
      'menus': instance.menuCategoryList,
      'explosiveMoney': instance.explosiveMoney,
      'noticeContent': instance.noticeContent,
    };

BannerEntity _$BannerEntityFromJson(Map<String, dynamic> json) => BannerEntity(
      id: (json['id'] as num?)?.toInt(),
      imageUrl: json['linkUrl'] as String?,
      title: json['name'] as String?,
      sort: (json['sort'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BannerEntityToJson(BannerEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'linkUrl': instance.imageUrl,
      'name': instance.title,
      'sort': instance.sort,
    };

MenuCategoryEntity _$MenuCategoryEntityFromJson(Map<String, dynamic> json) =>
    MenuCategoryEntity(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      iconUrl: json['pic'] as String?,
      linkUrl: json['url'] as String?,
      sort: (json['sort'] as num?)?.toInt(),
      show: (json['show'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MenuCategoryEntityToJson(MenuCategoryEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pic': instance.iconUrl,
      'url': instance.linkUrl,
      'sort': instance.sort,
      'show': instance.show,
    };
