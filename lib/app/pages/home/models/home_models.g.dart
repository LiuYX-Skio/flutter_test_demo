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
      menuCategoryList: (json['menuCategoryList'] as List<dynamic>?)
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
      'menuCategoryList': instance.menuCategoryList,
      'explosiveMoney': instance.explosiveMoney,
      'noticeContent': instance.noticeContent,
    };

BannerEntity _$BannerEntityFromJson(Map<String, dynamic> json) => BannerEntity(
      id: (json['id'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] as String?,
      linkUrl: json['linkUrl'] as String?,
      title: json['title'] as String?,
      sort: (json['sort'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BannerEntityToJson(BannerEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'linkUrl': instance.linkUrl,
      'title': instance.title,
      'sort': instance.sort,
    };

MenuCategoryEntity _$MenuCategoryEntityFromJson(Map<String, dynamic> json) =>
    MenuCategoryEntity(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      iconUrl: json['iconUrl'] as String?,
      linkUrl: json['linkUrl'] as String?,
      sort: (json['sort'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MenuCategoryEntityToJson(MenuCategoryEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconUrl': instance.iconUrl,
      'linkUrl': instance.linkUrl,
      'sort': instance.sort,
    };
