import 'package:json_annotation/json_annotation.dart';
import '../../../../navigation/utils/app_data_utils.dart';

part 'address_models.g.dart';

@JsonSerializable()
class UserAddressEntity {
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? id;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? realName;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? phone;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? province;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? city;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? cityId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? district;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? detail;
  @JsonKey(fromJson: AppDataUtils.toBool)
  final bool? isDefault;

  UserAddressEntity({
    this.id,
    this.realName,
    this.phone,
    this.province,
    this.city,
    this.cityId,
    this.district,
    this.detail,
    this.isDefault,
  });

  factory UserAddressEntity.fromJson(Map<String, dynamic> json) =>
      _$UserAddressEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserAddressEntityToJson(this);

  String get fullAddress =>
      '${province ?? ''}${city ?? ''}${district ?? ''}${detail ?? ''}';
}

@JsonSerializable()
class UserAddressListEntity {
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? limit;
  final List<UserAddressEntity>? list;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? page;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? total;
  @JsonKey(fromJson: AppDataUtils.toInt)
  final int? totalPage;

  UserAddressListEntity({
    this.limit,
    this.list,
    this.page,
    this.total,
    this.totalPage,
  });

  factory UserAddressListEntity.fromJson(Map<String, dynamic> json) =>
      _$UserAddressListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserAddressListEntityToJson(this);
}
