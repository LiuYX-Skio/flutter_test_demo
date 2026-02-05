import 'package:json_annotation/json_annotation.dart';

part 'address_models.g.dart';

/// 地址实体
/// 对应 Android 的 AddressEntity
@JsonSerializable()
class AddressEntity {
  /// 地址ID
  final int? id;

  /// 收货人姓名
  final String? name;

  /// 收货人手机号
  final String? phone;

  /// 省份
  final String? province;

  /// 城市
  final String? city;

  /// 区县
  final String? district;

  /// 详细地址
  final String? detail;

  /// 是否为默认地址
  final bool? isDefault;

  AddressEntity({
    this.id,
    this.name,
    this.phone,
    this.province,
    this.city,
    this.district,
    this.detail,
    this.isDefault,
  });

  factory AddressEntity.fromJson(Map<String, dynamic> json) =>
      _$AddressEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AddressEntityToJson(this);

  /// 获取完整地址
  String get fullAddress {
    return '${province ?? ''}${city ?? ''}${district ?? ''}${detail ?? ''}';
  }
}
