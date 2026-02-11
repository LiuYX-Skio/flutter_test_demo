// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoEntity _$UserInfoEntityFromJson(Map<String, dynamic> json) =>
    UserInfoEntity(
      id: (json['id'] as num?)?.toInt(),
      nickname: json['nickname'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      hasPayPassword: json['hasPayPassword'] as bool?,
      hasAuthentication: json['hasAuthentication'] as bool?,
      nowMoney: (json['nowMoney'] as num?)?.toDouble(),
      level: (json['level'] as num?)?.toInt(),
      creditAppUser: json['creditAppUser'] == null
          ? null
          : MonthPayEntity.fromJson(
              json['creditAppUser'] as Map<String, dynamic>),
      hasTestAccount: json['hasTestAccount'] as bool?,
    );

Map<String, dynamic> _$UserInfoEntityToJson(UserInfoEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'hasPayPassword': instance.hasPayPassword,
      'hasAuthentication': instance.hasAuthentication,
      'nowMoney': instance.nowMoney,
      'level': instance.level,
      'creditAppUser': instance.creditAppUser,
      'hasTestAccount': instance.hasTestAccount,
    };

UserCreditEntity _$UserCreditEntityFromJson(Map<String, dynamic> json) =>
    UserCreditEntity(
      creditLimit: (json['creditLimit'] as num?)?.toDouble(),
      usedCredit: (json['usedCredit'] as num?)?.toDouble(),
      availableCredit: (json['availableCredit'] as num?)?.toDouble(),
      status: (json['status'] as num?)?.toInt(),
      hasApply: json['hasApply'] as bool?,
      nextApplyTime: json['nextApplyTime'] as String?,
    );

Map<String, dynamic> _$UserCreditEntityToJson(UserCreditEntity instance) =>
    <String, dynamic>{
      'creditLimit': instance.creditLimit,
      'usedCredit': instance.usedCredit,
      'availableCredit': instance.availableCredit,
      'status': instance.status,
      'hasApply': instance.hasApply,
      'nextApplyTime': instance.nextApplyTime,
    };

MyCreditEntity _$MyCreditEntityFromJson(Map<String, dynamic> json) =>
    MyCreditEntity(
      totalLimit: (json['totalLimit'] as num?)?.toDouble(),
      availableLimit: (json['availableLimit'] as num?)?.toDouble(),
      usedLimit: (json['usedLimit'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MyCreditEntityToJson(MyCreditEntity instance) =>
    <String, dynamic>{
      'totalLimit': instance.totalLimit,
      'availableLimit': instance.availableLimit,
      'usedLimit': instance.usedLimit,
    };

MonthPayEntity _$MonthPayEntityFromJson(Map<String, dynamic> json) =>
    MonthPayEntity(
      creditAmount: json['creditAmount'] as String?,
      creditAmountResult: json['creditAmountResult'] as String?,
      repaymentDate: (json['repaymentDate'] as num?)?.toInt(),
      upMonthUnpaidAmount: json['upMonthUnpaidAmount'] as String?,
    );

Map<String, dynamic> _$MonthPayEntityToJson(MonthPayEntity instance) =>
    <String, dynamic>{
      'creditAmount': instance.creditAmount,
      'creditAmountResult': instance.creditAmountResult,
      'repaymentDate': instance.repaymentDate,
      'upMonthUnpaidAmount': instance.upMonthUnpaidAmount,
    };
