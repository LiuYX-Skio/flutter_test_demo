import 'package:json_annotation/json_annotation.dart';

part 'splash_models.g.dart';

/// 基础响应数据包装类
/// 对应 Android 的 BaseResultData<T>
class BaseResultData<T> {
  final T? data;
  final int? code;
  final String? message;

  BaseResultData({
    this.data,
    this.code,
    this.message,
  });

  factory BaseResultData.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic)? fromJsonT,
      ) {
    return BaseResultData<T>(
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      code: json['code'] as int?,
      message: json['message'] as String?,
    );
  }

  /// 判断请求是否成功
  bool get isSuccess => code == 200;
}

/// 应用更新实体
/// 对应 Android 的 AppUpdateEntity
@JsonSerializable()
class AppUpdateEntity {
  /// 更新描述
  final String? apkDesc;

  /// APK 大小
  final String? apkSize;

  /// 创建时间
  final String? createdAt;

  /// 下载 URL
  final String? downloadUrl;

  /// 应用名称
  final String? name;

  /// 版本号
  final int? versionCode;

  /// 版本名称
  final String? versionName;

  AppUpdateEntity({
    this.apkDesc,
    this.apkSize,
    this.createdAt,
    this.downloadUrl,
    this.name,
    this.versionCode,
    this.versionName,
  });

  factory AppUpdateEntity.fromJson(Map<String, dynamic> json) =>
      _$AppUpdateEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AppUpdateEntityToJson(this);
}

/// 用户信用实体
/// 对应 Android 的 UserCreditEntity
@JsonSerializable()
class UserCreditEntity {
  /// 信用分数
  final int? creditScore;

  /// 信用等级
  final String? creditLevel;

  UserCreditEntity({
    this.creditScore,
    this.creditLevel,
  });

  factory UserCreditEntity.fromJson(Map<String, dynamic> json) =>
      _$UserCreditEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserCreditEntityToJson(this);
}

/// IP 地址实体
/// 对应 Android 的 IpAddressEntity
@JsonSerializable()
class IpAddressEntity {
  /// IP 地址
  final String? ip;

  IpAddressEntity({this.ip});

  factory IpAddressEntity.fromJson(Map<String, dynamic> json) =>
      _$IpAddressEntityFromJson(json);

  Map<String, dynamic> toJson() => _$IpAddressEntityToJson(this);
}
