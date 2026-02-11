// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_tree_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressProvince _$AddressProvinceFromJson(Map<String, dynamic> json) =>
    AddressProvince(
      id: AppDataUtils.toStringValue(json['id']),
      cityId: AppDataUtils.toStringValue(json['cityId']),
      parentId: AppDataUtils.toStringValue(json['parentId']),
      areaName: AppDataUtils.toStringValue(json['name']),
      areaId: AppDataUtils.toStringValue(json['cityId']),
      cities: (json['child'] as List<dynamic>?)
          ?.map((e) => AddressCity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AddressProvinceToJson(AddressProvince instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cityId': instance.cityId,
      'parentId': instance.parentId,
      'name': instance.areaName,
      'child': instance.cities,
    };

AddressCity _$AddressCityFromJson(Map<String, dynamic> json) => AddressCity(
      id: AppDataUtils.toStringValue(json['id']),
      cityId: AppDataUtils.toStringValue(json['cityId']),
      parentId: AppDataUtils.toStringValue(json['parentId']),
      areaName: AppDataUtils.toStringValue(json['name']),
      areaId: AppDataUtils.toStringValue(json['cityId']),
      counties: (json['child'] as List<dynamic>?)
          ?.map((e) => AddressCounty.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AddressCityToJson(AddressCity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cityId': instance.cityId,
      'parentId': instance.parentId,
      'name': instance.areaName,
      'child': instance.counties,
    };

AddressCounty _$AddressCountyFromJson(Map<String, dynamic> json) =>
    AddressCounty(
      id: AppDataUtils.toStringValue(json['id']),
      cityId: AppDataUtils.toStringValue(json['cityId']),
      parentId: AppDataUtils.toStringValue(json['parentId']),
      areaName: AppDataUtils.toStringValue(json['name']),
      areaId: AppDataUtils.toStringValue(json['cityId']),
    );

Map<String, dynamic> _$AddressCountyToJson(AddressCounty instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cityId': instance.cityId,
      'parentId': instance.parentId,
      'name': instance.areaName,
    };
