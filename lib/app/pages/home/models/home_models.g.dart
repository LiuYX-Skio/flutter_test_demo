// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExplosiveMoneyEntity _$ExplosiveMoneyEntityFromJson(
        Map<String, dynamic> json) =>
    ExplosiveMoneyEntity(
      name: json['name'] as String?,
      pic: json['pic'] as String?,
      id: AppDataUtils.toInt(json['id']),
      type: json['type'] as String?,
      info: json['info'] as String?,
    );

Map<String, dynamic> _$ExplosiveMoneyEntityToJson(
        ExplosiveMoneyEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'pic': instance.pic,
      'id': instance.id,
      'type': instance.type,
      'info': instance.info,
    };

HomeTitleDataEntity _$HomeTitleDataEntityFromJson(Map<String, dynamic> json) =>
    HomeTitleDataEntity(
      banner: (json['banner'] as List<dynamic>?)
          ?.map((e) => BannerEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      menuCategoryList: (json['menuCategoryList'] as List<dynamic>?)
          ?.map((e) => MenuCategoryEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      explosiveMoney: (json['explosiveMoney'] as List<dynamic>?)
          ?.map((e) => ExplosiveMoneyEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      id: AppDataUtils.toInt(json['id']),
      imageUrl: json['linkUrl'] as String?,
      title: json['name'] as String?,
    );

Map<String, dynamic> _$BannerEntityToJson(BannerEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'linkUrl': instance.imageUrl,
      'name': instance.title,
    };

MenuCategoryEntity _$MenuCategoryEntityFromJson(Map<String, dynamic> json) =>
    MenuCategoryEntity(
      id: AppDataUtils.toInt(json['id']),
      name: json['name'] as String?,
      iconUrl: json['url'] as String?,
      sort: AppDataUtils.toInt(json['sort']),
      show: AppDataUtils.toInt(json['show']),
    );

Map<String, dynamic> _$MenuCategoryEntityToJson(MenuCategoryEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.iconUrl,
      'sort': instance.sort,
      'show': instance.show,
    };
