import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserInfo {
  final int? uid;
  final String? phone;
  final String? nikeName;
  final String? avatar;
  final String? token;

  UserInfo({
    this.uid,
    this.phone,
    this.nikeName,
    this.avatar,
    this.token,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      uid: json['uid'],
      phone: json['phone'],
      nikeName: json['nikeName'],
      avatar: json['avatar'],
      token: json['token'],
    );
  }
}