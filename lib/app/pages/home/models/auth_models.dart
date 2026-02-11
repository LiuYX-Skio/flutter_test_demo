import '../../../../navigation/utils/app_data_utils.dart';

class UploadIdCardEntity {
  final String? url;
  final String? name;
  final String? idCard;

  const UploadIdCardEntity({
    this.url,
    this.name,
    this.idCard,
  });

  factory UploadIdCardEntity.fromJson(Map<String, dynamic> json) {
    return UploadIdCardEntity(
      url: AppDataUtils.toStringValue(json['url']),
      name: AppDataUtils.toStringValue(json['name']),
      idCard: AppDataUtils.toStringValue(json['idCard']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'url': url,
      'name': name,
      'idCard': idCard,
    };
  }
}
