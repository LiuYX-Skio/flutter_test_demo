// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAddressEntity _$UserAddressEntityFromJson(Map<String, dynamic> json) =>
    UserAddressEntity(
      id: AppDataUtils.toStringValue(json['id']),
      realName: AppDataUtils.toStringValue(json['realName']),
      phone: AppDataUtils.toStringValue(json['phone']),
      province: AppDataUtils.toStringValue(json['province']),
      city: AppDataUtils.toStringValue(json['city']),
      cityId: AppDataUtils.toStringValue(json['cityId']),
      district: AppDataUtils.toStringValue(json['district']),
      detail: AppDataUtils.toStringValue(json['detail']),
      isDefault: AppDataUtils.toBool(json['isDefault']),
    );

Map<String, dynamic> _$UserAddressEntityToJson(UserAddressEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'realName': instance.realName,
      'phone': instance.phone,
      'province': instance.province,
      'city': instance.city,
      'cityId': instance.cityId,
      'district': instance.district,
      'detail': instance.detail,
      'isDefault': instance.isDefault,
    };

UserAddressListEntity _$UserAddressListEntityFromJson(
        Map<String, dynamic> json) =>
    UserAddressListEntity(
      limit: AppDataUtils.toInt(json['limit']),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => UserAddressEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: AppDataUtils.toInt(json['page']),
      total: AppDataUtils.toInt(json['total']),
      totalPage: AppDataUtils.toInt(json['totalPage']),
    );

Map<String, dynamic> _$UserAddressListEntityToJson(
        UserAddressListEntity instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'list': instance.list,
      'page': instance.page,
      'total': instance.total,
      'totalPage': instance.totalPage,
    };
