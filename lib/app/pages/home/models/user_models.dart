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

  /// 月付信息
  final MonthPayEntity? creditAppUser;

  /// 是否测试账号
  final bool? hasTestAccount;

  UserInfoEntity({
    this.id,
    this.nickname,
    this.phone,
    this.avatar,
    this.hasPayPassword,
    this.hasAuthentication,
    this.nowMoney,
    this.level,
    this.creditAppUser,
    this.hasTestAccount,
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

  /// 是否可申请
  final bool? hasApply;

  /// 下次可申请时间
  final String? nextApplyTime;

  UserCreditEntity({
    this.creditLimit,
    this.usedCredit,
    this.availableCredit,
    this.status,
    this.hasApply,
    this.nextApplyTime,
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

/// 月付信息实体
/// 对应 Android 的 MonthPayEntity
@JsonSerializable()
class MonthPayEntity {
  /// 授信额度
  final String? creditAmount;

  /// 可用授信额度
  final String? creditAmountResult;

  /// 还款日
  final int? repaymentDate;

  /// 上月未还金额
  final String? upMonthUnpaidAmount;

  MonthPayEntity({
    this.creditAmount,
    this.creditAmountResult,
    this.repaymentDate,
    this.upMonthUnpaidAmount,
  });

  factory MonthPayEntity.fromJson(Map<String, dynamic> json) =>
      _$MonthPayEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MonthPayEntityToJson(this);
}
