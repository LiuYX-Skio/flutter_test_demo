import 'package:json_annotation/json_annotation.dart';
import '../../../../navigation/utils/app_data_utils.dart';

part 'address_tree_models.g.dart';

@JsonSerializable()
class AddressProvince {
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? id;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? cityId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? parentId;
  @JsonKey(name: 'name', fromJson: AppDataUtils.toStringValue)
  final String? areaName;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? areaId;
  @JsonKey(name: 'child')
  final List<AddressCity>? cities;

  AddressProvince({
    this.id,
    this.cityId,
    this.parentId,
    this.areaName,
    this.areaId,
    this.cities,
  });

  factory AddressProvince.fromJson(Map<String, dynamic> json) =>
      _$AddressProvinceFromJson(json);

  Map<String, dynamic> toJson() => _$AddressProvinceToJson(this);
}

@JsonSerializable()
class AddressCity {
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? id;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? cityId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? parentId;
  @JsonKey(name: 'name', fromJson: AppDataUtils.toStringValue)
  final String? areaName;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? areaId;
  @JsonKey(name: 'child')
  final List<AddressCounty>? counties;

  AddressCity({
    this.id,
    this.cityId,
    this.parentId,
    this.areaName,
    this.areaId,
    this.counties,
  });

  factory AddressCity.fromJson(Map<String, dynamic> json) =>
      _$AddressCityFromJson(json);

  Map<String, dynamic> toJson() => _$AddressCityToJson(this);
}

@JsonSerializable()
class AddressCounty {
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? id;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? cityId;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? parentId;
  @JsonKey(name: 'name', fromJson: AppDataUtils.toStringValue)
  final String? areaName;
  @JsonKey(fromJson: AppDataUtils.toStringValue)
  final String? areaId;

  AddressCounty({
    this.id,
    this.cityId,
    this.parentId,
    this.areaName,
    this.areaId,
  });

  factory AddressCounty.fromJson(Map<String, dynamic> json) =>
      _$AddressCountyFromJson(json);

  Map<String, dynamic> toJson() => _$AddressCountyToJson(this);
}
