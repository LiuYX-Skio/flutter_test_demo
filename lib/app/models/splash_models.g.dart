// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUpdateEntity _$AppUpdateEntityFromJson(Map<String, dynamic> json) =>
    AppUpdateEntity(
      apkDesc: json['apkDesc'] as String?,
      apkSize: json['apkSize'] as String?,
      createdAt: json['createdAt'] as String?,
      downloadUrl: json['downloadUrl'] as String?,
      name: json['name'] as String?,
      versionCode: (json['versionCode'] as num?)?.toInt(),
      versionName: json['versionName'] as String?,
    );

Map<String, dynamic> _$AppUpdateEntityToJson(AppUpdateEntity instance) =>
    <String, dynamic>{
      'apkDesc': instance.apkDesc,
      'apkSize': instance.apkSize,
      'createdAt': instance.createdAt,
      'downloadUrl': instance.downloadUrl,
      'name': instance.name,
      'versionCode': instance.versionCode,
      'versionName': instance.versionName,
    };

UserCreditEntity _$UserCreditEntityFromJson(Map<String, dynamic> json) =>
    UserCreditEntity(
      creditScore: (json['creditScore'] as num?)?.toInt(),
      creditLevel: json['creditLevel'] as String?,
    );

Map<String, dynamic> _$UserCreditEntityToJson(UserCreditEntity instance) =>
    <String, dynamic>{
      'creditScore': instance.creditScore,
      'creditLevel': instance.creditLevel,
    };

IpAddressEntity _$IpAddressEntityFromJson(Map<String, dynamic> json) =>
    IpAddressEntity(
      ip: json['ip'] as String?,
    );

Map<String, dynamic> _$IpAddressEntityToJson(IpAddressEntity instance) =>
    <String, dynamic>{
      'ip': instance.ip,
    };
