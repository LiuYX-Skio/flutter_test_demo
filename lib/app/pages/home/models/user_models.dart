import 'package:json_annotation/json_annotation.dart';

part 'user_models.g.dart';

/// 用户信息实体
/// 对应 Android 的 UserInfoEntity
@JsonSerializable()
class UserInfoEntity {
  /// 用户ID
  final int? id;

  /// 昵称
  final String? nickname;

  /// 手机号
  final String? phone;

  /// 头像URL
  final String? avatar;

  /// 是否设置支付密码
  final bool? hasPayPassword;

  /// 是否已认证
  final bool? hasAuthentication;

  /// 当前余额
  final double? nowMoney;

  /// 用户等级
  final int? level;

  UserInfoEntity({
    this.id,
    this.nickname,
    this.phone,
    this.avatar,
    this.hasPayPassword,
    this.hasAuthentication,
    this.nowMoney,
    this.level,
  });

  factory UserInfoEntity.fromJson(Map<String, dynamic> json) =>
      _$UserInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoEntityToJson(this);
}

/// 用户信用实体
/// 对应 Android 的 UserCreditEntity
@JsonSerializable()
class UserCreditEntity {
  /// 信用额度
  final double? creditLimit;

  /// 已使用额度
  final double? usedCredit;

  /// 可用额度
  final double? availableCredit;

  /// 信用状态 (0:未申请, 1:审核中, 2:已通过, 3:已拒绝)
  final int? status;

  UserCreditEntity({
    this.creditLimit,
    this.usedCredit,
    this.availableCredit,
    this.status,
  });

  factory UserCreditEntity.fromJson(Map<String, dynamic> json) =>
      _$UserCreditEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserCreditEntityToJson(this);
}

/// 我的额度实体
/// 对应 Android 的 MyCreditEntity
@JsonSerializable()
class MyCreditEntity {
  /// 总额度
  final double? totalLimit;

  /// 可用额度
  final double? availableLimit;

  /// 已使用额度
  final double? usedLimit;

  MyCreditEntity({
    this.totalLimit,
    this.availableLimit,
    this.usedLimit,
  });

  factory MyCreditEntity.fromJson(Map<String, dynamic> json) =>
      _$MyCreditEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MyCreditEntityToJson(this);
}
